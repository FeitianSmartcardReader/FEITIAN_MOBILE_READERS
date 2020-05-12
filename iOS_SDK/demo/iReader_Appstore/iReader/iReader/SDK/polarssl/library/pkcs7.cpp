#if !defined(POLARSSL_CONFIG_FILE)
#include "polarssl/config.h"
#else
#include POLARSSL_CONFIG_FILE
#endif

#if defined(POLARSSL_PKCS7_C)
#include "polarssl/pkcs7.h"
#include "polarssl/asn1.h"
#include "polarssl/oid.h"
#include "polarssl/oid.zh-cn.h"
#include "polarssl/md.h"
#include "polarssl/sm2.h"

#if defined (POLARSSL_PLATFORM_C)
#include "polarssl/platform.h"
#else
#define polarssl_printf    printf
#define polarssl_malloc    malloc
#define polarssl_free      free
#endif

#include <string.h>
#include <stdlib.h>
#if defined(_WIN32) && !defined(EFIX64) && !defined(EFI32)
#include <windows.h>
#else
#include <time.h>
#endif

#if defined(EFIX64) || defined(EFI32)
#include <stdio.h>
#endif

#if defined(POLARSSL_FS_IO)
#include <stdio.h>
#if !defined(_WIN32)
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#endif
#endif

#if defined(POLARSSL_PKCS7_DATA_C)
#include "polarssl/pkcs7_data.h"
#endif

#if defined(POLARSSL_PKCS7_SIGNED_DATA_C)
#include "polarssl/pkcs7_signed_data.h"
#endif

namespace FT_POLARSSL {
void pkcs7_init( pkcs7_context *ctx )
{
    memset( ctx, 0, sizeof( pkcs7_context ) );
}

pkcs7_type_t pkcs7_get_type( pkcs7_context *ctx )
{
    return( ctx->type );
}

int pkcs7_parse( pkcs7_context *ctx, const unsigned char *input, size_t ilen)
{
    int ret;
    size_t len;
    unsigned char *p, *end, *content_end;
    pkcs7_buf type;

    if( ctx == NULL || input == NULL || ilen == 0 )
        return( POLARSSL_ERR_PKCS7_BAD_INPUT_DATA );

    p = (unsigned char *) polarssl_malloc( ilen );

    if( p == NULL )
        return ( POLARSSL_ERR_PKCS7_MALLOC_FAILED );

    len = ilen;

    memcpy( p, input, ilen );
    ctx->raw.p = p;
    ctx->raw.len = len;
    end = p + len;

    /*
      ContentInfo ::= SEQUENCE {
      contentType ContentType,
      content
      [0] EXPLICIT ANY DEFINED BY contentType OPTIONAL }

      ContentType ::= OBJECT IDENTIFIER */
    if( ( ret = asn1_get_tag( &p, end, &len,
                              ASN1_CONSTRUCTED | ASN1_SEQUENCE ) ) != 0 )
    {
        pkcs7_free( ctx );
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT );
    }

    if( len > (size_t) (end - p) )
    {
        pkcs7_free( ctx );
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT +
                POLARSSL_ERR_ASN1_LENGTH_MISMATCH );
    }

    //pkcs7 type
    if( ( ret = asn1_get_tag( &p, end, &len, ASN1_OID ) ) != 0 )
    {
        pkcs7_free( ctx );
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT + ret );
    }

    type.p = p;
    type.len = len;
    p += len;

    /* content raw buffer */
    /* maybe not exist context[0] tag, e.g. data type in detached signedData */
    if( p < end )
    {
        ret = asn1_get_tag( &p, end, &len,
                            ASN1_CONSTRUCTED | ASN1_CONTEXT_SPECIFIC | 0 );
        if( ret != 0 )
        {
            pkcs7_free( ctx );
            return( POLARSSL_ERR_PKCS7_INVALID_FORMAT + ret );
        }

        content_end = p + len;
    }
    else if( p == end )
    {
        content_end = end;
    }
    else
    {
        pkcs7_free( ctx );
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT );
    }

    /* data */
    if( ( type.len == OID_SIZE( OID_PKCS7_DATA ) &&
          memcmp( OID_PKCS7_DATA, type.p, type.len ) == 0 ) ||
        ( type.len == OID_SIZE( OID_P7_DATA_ZH ) &&
          memcmp( OID_P7_DATA_ZH, type.p, type.len ) == 0 ) )
    {
        ctx->content = polarssl_malloc( sizeof( pkcs7_data_context ) );

        if( ctx->content == NULL )
        {
            pkcs7_free( ctx );
            return( POLARSSL_ERR_PKCS7_MALLOC_FAILED );
        }

        ctx->type = POLARSSL_P7_DATA;

        pkcs7_data_init( p7_data( ctx ) );
        ret = pkcs7_data_parse( &p, content_end, p7_data( ctx ) );

        if( ret != 0 )
        {
            pkcs7_free( ctx );
        }

        return( ret );
    }

    /* signedData */
    if( ( type.len == OID_SIZE( OID_PKCS7_SIGNED_DATA ) &&
          memcmp( OID_PKCS7_SIGNED_DATA, type.p, type.len ) == 0 )||
        ( type.len == OID_SIZE( OID_P7_SIGNED_DATA_ZH ) &&
          memcmp( OID_P7_SIGNED_DATA_ZH, type.p, type.len ) ==0 ) )
    {
        ctx->content = polarssl_malloc( sizeof( pkcs7_signed_data_context ) );

        if( ctx->content == NULL )
        {
            pkcs7_free( ctx );
            return( POLARSSL_ERR_PKCS7_MALLOC_FAILED );
        }

        ctx->type = POLARSSL_P7_SIGNED_DATA;

        pkcs7_signed_data_init( p7_signed_data( ctx ) );

        ret = pkcs7_signed_data_parse( &p, content_end, p7_signed_data( ctx ) );

        if( ret != 0 )
        {
            pkcs7_free( ctx );
        }
        return( ret );
    }

    pkcs7_free( ctx );
    return( POLARSSL_ERR_PKCS7_INVALID_FORMAT );
}

void pkcs7_free( pkcs7_context *ctx )
{
    if( ctx->raw.p != NULL )
    {
        free( ctx->raw.p );
        ctx->raw.p = NULL;
        ctx->raw.len = 0;
    }

    if( ctx->content != NULL )
    {
        switch( ctx->type )
        {
            case POLARSSL_P7_DATA:
                pkcs7_data_free( p7_data( ctx ) );
                break;
            case POLARSSL_P7_SIGNED_DATA:
                pkcs7_signed_data_free( p7_signed_data( ctx ) );
                break;
            case POLARSSL_P7_NONE:
            case POLARSSL_P7_ENVELOPED_DATA:
            case POLARSSL_P7_SIGNED_ENVELOPED_DATA:
            case POLARSSL_P7_DIGESTED_DATA:
            case POLARSSL_P7_ENCRYPTED_DATA:
            default:
                break;
        }
        free( ctx->content );
        ctx->content = NULL;
    }

    ctx->type = POLARSSL_P7_NONE;
}

int hash_msg( const md_info_t *md,
              const unsigned char *buf, size_t buf_len,
              unsigned char *output )
{
    md_context_t md_ctx;
    int ret;

    if( ( ret = md_init_ctx( &md_ctx, md ) ) != 0 )
    {
        return( ret );
    }

    md_starts( &md_ctx );
    md_update( &md_ctx, buf, buf_len);
    md_finish( &md_ctx, output );
    md_free( &md_ctx );

    return( 0 );
}

static unsigned char default_user_id[] = {
    0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38,
    0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38
};
static size_t default_user_id_len = sizeof(default_user_id);

int pkcs7_verify_signed_data( pkcs7_context *ctx )
{
    pkcs7_data_context *content;
    pkcs7_signed_data_context *signed_data_ctx;
    unsigned char *data;
    size_t len;
    int ret;

    if( POLARSSL_P7_SIGNED_DATA != pkcs7_get_type( ctx ) )
    {
        return( POLARSSL_ERR_PKCS7_VERIFY_FAILED );
    }

    signed_data_ctx = p7_signed_data( ctx );

    if( POLARSSL_P7_DATA != pkcs7_get_type( signed_data_ctx->content_info ) )
    {
        return( POLARSSL_ERR_PKCS7_VERIFY_FAILED );
    }

    content = p7_data( signed_data_ctx->content_info );

    data = content->data.p;
    len = content->data.len;

    if( 0 == len || data == NULL )
    {
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT );
    }

    ret = pkcs7_verify_signed_data_detached( ctx, data, len );

    return( ret );
}


#ifdef ABC_BANK_PKCS7
/* parse input data */
typedef enum {
    ABC_DATA_TRANS = 0,
    ABC_DATA_FILE,
    ABC_DATA_CONTROL,
} abc_data_type;

typedef struct _abc_data_t
{
    asn1_buf raw;
    abc_data_type tag;
    const unsigned char *p;
    size_t len;
}
abc_data_t;

int abc_data_parse( const unsigned char *input,
                   size_t ilen,
                   abc_data_t *data,
                   int data_count)
{
    int count;
    int ret = 0;
    int i;
    abc_data_t *cur;
    const unsigned char *p, *end;
    unsigned short tag;
    size_t len;

    p = input;
    end = input + ilen;
    cur = data;
    count = 0;

    while( p < end )
    {
        ret = 0;

        if( data_count < count )
        {
            ret = -1;
            break;
        }

        tag = *((unsigned short*) p);
        switch( tag )
        {
            case 0x3030:
                cur->tag = ABC_DATA_TRANS;
                break;
            case 0x3130:
                cur->tag = ABC_DATA_FILE;
                break;
            case 0x3230:
                cur->tag = ABC_DATA_CONTROL;
                break;
            default:
                ret = -1;
                break;
        }
        if( ret != 0 )
            break;

        cur->raw.p = (unsigned char*)p;

        p += 2;
        len = 0;

        for( i = 0; i < 16; i++)
        {
            if( *p < '0' || *p > '9' )
            {
                ret = -1;
                break;
            }
            len *= 10;
            len += *p++ - '0';
        }

        if( ret != 0 )
            break;
        cur->raw.len = len + 18;
        cur->len = len;
        cur->p = p;

        p += len;
        ++cur;
        ++count;
    }

    return( ret );
}

int rsa_pkcs1_v15_verify_ABC( rsa_context *ctx,
                             int mode,
                             md_type_t md_alg,
                             unsigned int hashlen,
                             const unsigned char *h1,
                             const unsigned char *h2,
                             const unsigned char *sig )
{
    int ret;
    size_t len, siglen, asn1_len;
    unsigned char *p, *end;
    unsigned char buf[POLARSSL_MPI_MAX_SIZE];
    md_type_t msg_md_alg;
    const md_info_t *md_info;
    asn1_buf oid;

    if( mode == RSA_PRIVATE && ctx->padding != RSA_PKCS_V15 )
        return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );

    siglen = ctx->len;

    if( siglen < 16 || siglen > sizeof( buf ) )
        return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );

    ret = ( mode == RSA_PUBLIC )
    ? rsa_public(  ctx, sig, buf )
    : POLARSSL_ERR_RSA_BAD_INPUT_DATA;

    if( ret != 0 )
        return( ret );

    p = buf;

    if( *p++ != 0 || *p++ != RSA_SIGN )
        return( POLARSSL_ERR_RSA_INVALID_PADDING );

    while( *p != 0 )
    {
        if( p >= buf + siglen - 1 || *p != 0xFF )
            return( POLARSSL_ERR_RSA_INVALID_PADDING );
        p++;
    }
    p++;

    len = siglen - ( p - buf );

    if( len == hashlen && md_alg == POLARSSL_MD_NONE )
    {
        return( POLARSSL_ERR_RSA_VERIFY_FAILED );
    }

    md_info = md_info_from_type( md_alg );
    if( md_info == NULL )
        return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );
    hashlen = md_get_size( md_info );

    end = p + len;

    // Parse the ASN.1 structure inside the PKCS#1 v1.5 structure
    //

    /* signatrue ::= SEQUENCE {
     digestAlgorithm DigestAlgorithmIdentifier,
     SEQUENCE {
     hash h1
     hash h2}
     }
     hash ::= OCTET STRING
     */
    if( len < 59 ) //sha1
    {
        return( POLARSSL_ERR_RSA_VERIFY_FAILED );
    }

    //don't use asn1 function parse outer sequence
    //sha512 algo break length rule
    if( *p != ( ASN1_CONSTRUCTED | ASN1_SEQUENCE ) )
    {
        return( POLARSSL_ERR_RSA_VERIFY_FAILED );
    }

    p++;
    asn1_len = *p;
    p++;

    /*
     if( ( ret = asn1_get_tag( &p, end, &asn1_len,
     ASN1_CONSTRUCTED | ASN1_SEQUENCE ) ) != 0 )
     return( POLARSSL_ERR_RSA_VERIFY_FAILED );
     */

    if( asn1_len + 2 != len )
        return( POLARSSL_ERR_RSA_VERIFY_FAILED );

    if( ( ret = asn1_get_tag( &p, end, &asn1_len,
                             ASN1_CONSTRUCTED | ASN1_SEQUENCE ) ) != 0 )
        return( POLARSSL_ERR_RSA_VERIFY_FAILED );

    // 10 = 5*(1 + 1); 1 = length of (tag or len);
    // 5: sequence*2 digestaAlgorithm octet*2
    if( asn1_len + 10 + hashlen*2 != len )
        return( POLARSSL_ERR_RSA_VERIFY_FAILED );


    if( ( ret = asn1_get_tag( &p, end, &oid.len, ASN1_OID ) ) != 0 )
        return( POLARSSL_ERR_RSA_VERIFY_FAILED );

    oid.p = p;
    p += oid.len;

    if( oid_get_md_alg( &oid, &msg_md_alg ) != 0 )
        return( POLARSSL_ERR_RSA_VERIFY_FAILED );

    if( md_alg != msg_md_alg )
        return( POLARSSL_ERR_RSA_VERIFY_FAILED );


    /*
     * assume the algorithm parameters must be NULL
     */
    if( ( ret = asn1_get_tag( &p, end, &asn1_len, ASN1_NULL ) ) != 0 )
        return( POLARSSL_ERR_RSA_VERIFY_FAILED );
    if( ( ret = asn1_get_tag( &p, end, &asn1_len,
                             ASN1_CONSTRUCTED | ASN1_SEQUENCE ) ) != 0)
        return( POLARSSL_ERR_RSA_VERIFY_FAILED );
    //h1
    if( ( ret = asn1_get_tag( &p, end, &asn1_len, ASN1_OCTET_STRING ) ) != 0 )
        return( POLARSSL_ERR_RSA_VERIFY_FAILED );

    if( asn1_len != hashlen )
        return( POLARSSL_ERR_RSA_VERIFY_FAILED );

    if( memcmp( p, h1, hashlen ) != 0 )
        return( POLARSSL_ERR_RSA_VERIFY_FAILED );

    p += hashlen;
    //h2
    if( ( ret = asn1_get_tag( &p, end, &asn1_len, ASN1_OCTET_STRING ) ) != 0 )
        return( POLARSSL_ERR_RSA_VERIFY_FAILED );

    if( asn1_len != hashlen )
        return( POLARSSL_ERR_RSA_VERIFY_FAILED );

    if( memcmp( p, h2, hashlen ) != 0 )
        return( POLARSSL_ERR_RSA_VERIFY_FAILED );

    p += hashlen;

    if( p != end )
        return( POLARSSL_ERR_RSA_VERIFY_FAILED );

    return( 0 );
}

int pkcs7_verify_signed_data_detached( pkcs7_context *ctx,
                                            const unsigned char *input,
                                            size_t ilen)
{
    pkcs7_signed_data_context *signed_data_ctx;
    signer_info_t *signer_info;
    x509_crt *crt;

    pk_context *pk;

    const md_info_t *md;

    unsigned char h1[POLARSSL_MD_MAX_SIZE], h2[POLARSSL_MD_MAX_SIZE];
    unsigned int hash_len;

    abc_data_t data[3], *trans;

    int ret;

    if( (ret = abc_data_parse( input, ilen, data,
                              sizeof(data)/sizeof(abc_data_t) ) ) != 0)
    {
        return( POLARSSL_ERR_PKCS7_VERIFY_FAILED );
    }
    trans = data;
    while( trans <= data+3 &&
          ABC_DATA_TRANS != trans->tag )
    {
        ++trans;
    }

    if( trans->tag != ABC_DATA_TRANS )
        return( POLARSSL_ERR_PKCS7_VERIFY_FAILED );

    if( POLARSSL_P7_SIGNED_DATA != pkcs7_get_type( ctx ) )
    {
        return( POLARSSL_ERR_PKCS7_VERIFY_FAILED );
    }
    signed_data_ctx = p7_signed_data( ctx );
    
    signer_info = signed_data_ctx->signer_infos;

    if( signer_info->version != 1 )
    {
        return( POLARSSL_ERR_PKCS7_VERIFY_FAILED );
    }

    while( signer_info != NULL )
    {

        /* mutil-signerInfo? */
        crt = &signed_data_ctx->certs;
        /* find singer */
        while( crt != NULL )
        {
            if( signer_info->serial.len == crt->serial.len &&
               memcmp(signer_info->serial.p, crt->serial.p, crt->serial.len ) == 0 )
            {
                break;
            }

            crt = crt->next;
        }

        if( crt == NULL )
        {
            return( POLARSSL_ERR_PKCS7_INVALID_FORMAT );
        }

        md = md_info_from_type( signer_info->digest_algo.md_type );
        pk = &crt->pk;

        hash_len = md_get_size( md );
        if( POLARSSL_PK_RSA == pk_get_type( pk ) )
        {
            hash_msg( md, input, ilen, h1 );
            hash_msg( md, trans->raw.p, trans->raw.len, h2 );
            ret = rsa_pkcs1_v15_verify_ABC( pk_rsa( *pk ), RSA_PUBLIC,
                                           md->type, hash_len,
                                           h1, h2, signer_info->sig.p );

        }
        else if( POLARSSL_PK_ECKEY == pk_get_type( pk ) &&
                POLARSSL_ECP_SM2 == pk_ec( *pk )->grp.id )
        {
            ret = hash_msg_with_user_id( pk_ec(*pk), md, input, ilen,
                                        default_user_id, default_user_id_len,
                                        h1 );
            if( ret != 0 )
            {
                ret = POLARSSL_ERR_PKCS7_VERIFY_FAILED;
                break;
            }
            ret = pk_verify( pk, md->type,
                            h1, hash_len,
                            signer_info->sig.p,
                            signer_info->sig.len );


        }
        else
        {
            ret = POLARSSL_ERR_PKCS7_VERIFY_FAILED;
        }
        if( ret != 0 )
        {
            break;
        }

        signer_info = signer_info->next;
    }

    return( ret );
}

#else /* ABC_BANK_PKCS7 */

int pkcs7_verify_signed_data_detached( pkcs7_context *ctx,
                                       const unsigned char *input,
                                       size_t ilen)
{
    pkcs7_signed_data_context *signed_data_ctx;
    signer_info_t *signer_info;
    x509_crt *crt;

    pk_context *pk;

    const md_info_t *md;

    unsigned char hash[ POLARSSL_MD_MAX_SIZE ];
    size_t hash_len;

    int ret = 0;


    if( POLARSSL_P7_SIGNED_DATA != pkcs7_get_type( ctx ) )
    {
        return( POLARSSL_ERR_PKCS7_VERIFY_FAILED );
    }

    signed_data_ctx = p7_signed_data( ctx );

    signer_info = signed_data_ctx->signer_infos;

    if( signer_info->version != 1 )
    {
        return( POLARSSL_ERR_PKCS7_INVALID_VERSION );
    }

    while( signer_info != NULL )
    {

        /* mutil-signerInfo? */
        crt = &signed_data_ctx->certs;
        /* find singer */
        while( crt != NULL )
        {
            if( signer_info->serial.len == crt->serial.len &&
                memcmp(signer_info->serial.p, crt->serial.p, crt->serial.len ) == 0 )
            {
                break;
            }

            crt = crt->next;
        }

        if( crt == NULL )
        {
            return( POLARSSL_ERR_PKCS7_INVALID_FORMAT );
        }

        md = md_info_from_type( signer_info->digest_algo.md_type );
        pk = &crt->pk;

        hash_len = md_get_size( md );

        if( POLARSSL_PK_ECKEY == pk_get_type( pk ) &&
            POLARSSL_ECP_SM2 == pk_ec( *pk )->grp.id )
        {
            ret = hash_msg_with_user_id( pk_ec(*pk), md, input, ilen,
                                         default_user_id, default_user_id_len,
                                         hash );
        }
        else if( POLARSSL_PK_RSA == pk_get_type( pk ) )
        {
            ret = hash_msg( md, input, ilen, hash );
        }
        if( ret != 0 )
        {
            ret = POLARSSL_ERR_PKCS7_VERIFY_FAILED;
            break;
        }
        ret = pk_verify( pk, md->type,
                         hash, hash_len,
                         signer_info->sig.p,
                         signer_info->sig.len );

        if( ret != 0 )
        {
            ret = POLARSSL_ERR_PKCS7_VERIFY_FAILED;
            break;
        }

        signer_info = signer_info->next;
    }

    return( ret );
}
#endif
}

#endif  /* POLARSSL_PKCS7_C */
