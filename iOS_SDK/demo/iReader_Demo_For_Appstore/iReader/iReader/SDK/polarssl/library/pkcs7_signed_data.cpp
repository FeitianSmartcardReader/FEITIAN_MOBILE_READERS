#if !defined(POLARSSL_CONFIG_FILE)
#include "polarssl/config.h"
#else
#include POLARSSL_CONFIG_FILE
#endif

#if defined(POLARSSL_PKCS7_SIGNED_DATA_C)
#include "polarssl/pkcs7_signed_data.h"
#include "polarssl/pkcs7_data.h"
#include "polarssl/asn1.h"
#include "polarssl/oid.h"
#include "polarssl/oid.zh-cn.h"
#include "polarssl/x509.h"
#include "polarssl/pkcs7-sm2-config.h"
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

namespace FT_POLARSSL {
/* Implementation that should never be optimized out by the compiler */
static void polarssl_zeroize( void *v, size_t n ) {
    volatile unsigned char *p = (volatile unsigned char *)v; while( n-- ) *p++ = 0;
}


int get_algos_type( asn1_buf alg, digest_algo_type_t *alg_type )
{

    //len of oid maybe equal?
#define ALGO_CMP(algo, oid)      OID_CMP(oid,&algo)

    //<digest>With<Public>
    if( ALGO_CMP(alg, OID_PKCS1_MD5) )
    {
        alg_type->md_type = POLARSSL_MD_MD5;
        alg_type->pk_type = POLARSSL_PK_RSA;
        return( 0 );
    }
    if( ALGO_CMP(alg, OID_PKCS1_SHA1) )
    {
        alg_type->md_type = POLARSSL_MD_SHA1;
        alg_type->pk_type = POLARSSL_PK_RSA;
        return( 0 );
    }
    if( ALGO_CMP(alg, OID_PKCS1_SHA256) )
    {
        alg_type->md_type = POLARSSL_MD_SHA256;
        alg_type->pk_type = POLARSSL_PK_RSA;
        return( 0 );
    }
    if( ALGO_CMP(alg, OID_PKCS1_SHA512) )
    {
        alg_type->md_type = POLARSSL_MD_SHA512;
        alg_type->pk_type = POLARSSL_PK_RSA;
        return( 0 );
    }
    if( ALGO_CMP(alg, OID_SM3_WITH_SM2) )
    {
        alg_type->md_type = POLARSSL_MD_SM3;
        alg_type->pk_type = POLARSSL_PK_SM2;
        return( 0 );
    }

    //digest algorithm
    if( ALGO_CMP(alg, OID_DIGEST_ALG_MD5) )
    {
        alg_type->md_type = POLARSSL_MD_MD5;
        //alg_type->pk_type = POLARSSL_PK_RSA;
        return( 0 );
    }
    if( ALGO_CMP(alg, OID_DIGEST_ALG_SHA1) )
    {
        alg_type->md_type = POLARSSL_MD_SHA1;
        //alg_type->pk_type = POLARSSL_PK_RSA;
        return( 0 );
    }
    if( ALGO_CMP(alg, OID_DIGEST_ALG_SHA256) )
    {
        alg_type->md_type = POLARSSL_MD_SHA256;
        //alg_type->pk_type = POLARSSL_PK_RSA;
        return( 0 );
    }
    if( ALGO_CMP(alg, OID_DIGEST_ALG_SHA512))
    {
        alg_type->md_type = POLARSSL_MD_SHA512;
        //alg_type->pk_type = POLARSSL_PK_RSA;
        return( 0 );
    }
    if( ALGO_CMP(alg, OID_DIGEST_ALG_SM3) )
    {
        alg_type->md_type = POLARSSL_MD_SM3;
        //alg_type->pk_type = POLARSSL_PK_SM2;
        return( 0 );
    }

    //public algorithm
    if( ALGO_CMP(alg, OID_PKCS1_RSA) )
    {
        alg_type->pk_type = POLARSSL_PK_RSA;
        return( 0 );
    }
    if( ALGO_CMP(alg, OID_SM2_SIGN) )
    {
        alg_type->pk_type = POLARSSL_PK_SM2;
        return( 0 );
    }
 #undef ALGO_CMP
    return( POLARSSL_ERR_PKCS7_INVALID_ALG );
}

/*
  DigestAlgorithmIdentifiers ::=
  SET OF DigestAlgorithmIdentifier
*/
static int  pkcs7_signed_data_get_digest_algos( unsigned char **p,
                                                const unsigned char* end,
                                                digest_algo_type_t *alogs )
{
    int ret;
    size_t len;
    asn1_buf alg;
    digest_algo_type_t *cur;

    /* get main SET tag */
    if( ( ret = asn1_get_tag( p, end, &len,
                              ASN1_CONSTRUCTED | ASN1_SET ) ) != 0 )
    {
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT + ret );
    }

    end = *p + len;
    cur = alogs;

    while( *p < end )
    {
        if ( ( ret = asn1_get_alg_null( p, end, &alg ) ) != 0 )
        {
            return( POLARSSL_ERR_PKCS7_INVALID_FORMAT + ret );
        }

        if( ( ret = get_algos_type( alg, cur ) ) != 0 )
        {
            return( ret );
        }

        if( *p < end )
        {
            cur->next = (digest_algo_type_t *) polarssl_malloc( sizeof( digest_algo_type_t ) );
            if ( cur->next == NULL )
            {
                return( POLARSSL_ERR_PKCS7_MALLOC_FAILED );

            }
            cur = cur->next;
            polarssl_zeroize( cur, sizeof( digest_algo_type_t ) );
        }
    }

    cur->next = NULL;
    return( 0 );
}

static int pkcs7_signed_data_get_signer_infos( unsigned char **p,
                                               const unsigned char *end,
                                               pkcs7_signed_data_context *ctx)
{
    int ret;
    size_t len;
    signer_info_t *cur;
    unsigned char *seq_begin, *seq_end;
    /* get main SET tag */
    if( ( ret = asn1_get_tag( p, end, &len,
                              ASN1_CONSTRUCTED | ASN1_SET ) ) != 0)
    {
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT + ret );
    }

    end = *p + len;
    cur = (signer_info_t *) polarssl_malloc( sizeof( signer_info_t ) );

    if( cur == NULL)
    {
        return( POLARSSL_ERR_PKCS7_MALLOC_FAILED );
    }

    pkcs7_signer_info_init( cur );
    ctx->signer_infos = cur;

    while( *p < end )
    {
        seq_begin = *p;

        if( ( ret = asn1_get_tag( p, end, &len,
                                  ASN1_CONSTRUCTED | ASN1_SEQUENCE ) ) != 0 )
        {
            return( POLARSSL_ERR_PKCS7_INVALID_FORMAT + ret );
        }

        *p += len;
        seq_end = *p;

        ret = pkcs7_signer_info_parse( &seq_begin , seq_end,  cur);
        if( ret != 0)
        {
            return( ret );
        }

        ctx->signer_info_count++;

        if( *p <  end )
        {
            cur->next = (signer_info_t *) polarssl_malloc( sizeof( signer_info_t ) );

            if( cur->next == NULL )
            {
                return( POLARSSL_ERR_PKCS7_MALLOC_FAILED );
            }

            cur = cur->next;
            pkcs7_signer_info_init( cur );
        }
    }

    cur->next = NULL;

    return( 0 );
}

void pkcs7_signer_info_init( signer_info_t *signer_info )
{
    polarssl_zeroize( signer_info,  sizeof( signer_info_t ) );
}


int pkcs7_signer_info_parse(unsigned char **p,
                            const unsigned char *end,
                            signer_info_t *signer_info)
{
    signer_info_t *cur;
    unsigned char *begin;
    asn1_buf alg;
    size_t len;
    int ret;

    /*
      SignerInfo ::= SEQUENCE {
      version Version,
      issuerAndSerialNumber IssuerAndSerialNumber,
      digestAlgorithm DigestAlgorithmIdentifier,
      authenticatedAttributes
      [0] IMPLICIT Attributes OPTIONAL,
      digestEncryptionAlgorithm
      DigestEncryptionAlgorithmIdentifier,
      encryptedDigest EncryptedDigest,
      unauthenticatedAttributes
      [1] IMPLICIT Attributes OPTIONAL }

      EncryptedDigest ::= OCTET STRING
    */

    /* sotre pointer */
    begin = *p;
    cur = signer_info;

    if( ( ret = asn1_get_tag( p, end, &len,
                              ASN1_CONSTRUCTED | ASN1_SEQUENCE ) ) != 0 )
    {
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT + ret );
    }
    if( *p+len != end )
    {
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT +
                POLARSSL_ERR_ASN1_LENGTH_MISMATCH );
    }

    cur->raw.p = (unsigned char *) polarssl_malloc( end - begin );

    if( cur->raw.p == NULL )
    {
        return( POLARSSL_ERR_PKCS7_MALLOC_FAILED );
    }

    /* store SEQUENCE */
    memcpy( cur->raw.p, begin, end - begin );
    cur->raw.len = end - begin;

    /* switch pointer to local */
    begin = cur->raw.p + ( *p - begin );

    /* switch END to local */
    end = begin + len;

    /* move p to SEQUENCE end */
    *p += len;

    /* get version Version ::= INTEGER */
    if( ( ret = asn1_get_int( &begin, end, &cur->version ) ) != 0 )
    {
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT + ret );
    }
    if( cur->version != 1 )
    {
        return( POLARSSL_ERR_PKCS7_INVALID_VERSION );
    }

    /* issuer and serial number */
    if( ( ret = asn1_get_tag( &begin, end, &len,
                              ASN1_CONSTRUCTED | ASN1_SEQUENCE ) ) != 0 )
    {
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT + ret );
    }

    /* issuer */
    cur->issuer_raw.p = begin;
    if( ( ret = asn1_get_tag( &begin, end, &len,
                              ASN1_CONSTRUCTED | ASN1_SEQUENCE ) ) != 0 )
    {
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT + ret );
    }

    if( len && ( ret = x509_get_name( &begin, begin + len, &cur->issuer ) ) != 0 )
    {
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT + ret );
    }
    cur->issuer_raw.len = begin - cur->issuer_raw.p;

    /* serial number */
    if( ( ret = asn1_get_tag( &begin, end, &len, ASN1_INTEGER ) ) != 0 )
    {
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT + ret );
    }

    cur->serial.p = begin;
    cur->serial.len = len;

    begin += len;

    /* digest algorithm */
    if( ( ret = asn1_get_alg_null( &begin, end, &alg ) ) != 0 )
    {
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT + ret );
    }

    if( ( ret = get_algos_type( alg, &cur->digest_algo ) ) != 0 )
    {
        return( ret );
    }

    /* skip authenticatedAttributes */
    if( ( ret = asn1_get_tag( &begin, end, &len,
                              ASN1_CONSTRUCTED | ASN1_CONTEXT_SPECIFIC | 0 ) ) == 0 )
    {
        begin += len;
    }

    /* public key algorithm */
    if( ( ret = asn1_get_alg_null( &begin, end, &alg ) ) != 0 )
    {
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT + ret );
    }

    if( ( ret = get_algos_type( alg, &cur->digest_algo ) ) != 0 )
    {
        return( ret );
    }

    if( cur->digest_algo.pk_type == POLARSSL_PK_SM2 )
    {
#ifdef SIGNER_INFO_SM2_SIG_USE_SEQUENCE
        cur->sig.p = begin;
        if( ( ret = asn1_get_tag( &begin, end, &len,
                                  ASN1_CONSTRUCTED | ASN1_SEQUENCE ) ) != 0 )
        {
            return( POLARSSL_ERR_PKCS7_INVALID_ALG + ret );
        }
        cur->sig.len = (begin - cur->sig.p) + len;

        /* unauthenticatedAttributes */
        /* not process */
        return( 0 );
#endif
    }
    /* encrypt digest, signature */
    if( ( ret = asn1_get_tag( &begin, end, &len, ASN1_OCTET_STRING ) ) != 0 )
    {
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT + ret );
    }

    cur->sig.p = begin;
    cur->sig.len = len;

    /* unauthenticatedAttributes */
    /* not process */

    return( 0 );
}

void pkcs7_signer_info_free( signer_info_t *signer_info )
{

    if( signer_info->raw.len )
    {
        polarssl_free( signer_info->raw.p );
    }

    polarssl_zeroize( signer_info, sizeof( signer_info_t ) );
}

void pkcs7_signed_data_init( pkcs7_signed_data_context *ctx )
{
    polarssl_zeroize( ctx, sizeof( pkcs7_signed_data_context ) );
}

int pkcs7_signed_data_parse( unsigned char **p,
                             const unsigned char *end,
                             pkcs7_signed_data_context *ctx )
{
    int ret;
    size_t len;
    unsigned char *begin;
    unsigned char *content;
    unsigned char *temp;

    if( *p == end)
    {
        return( POLARSSL_ERR_PKCS7_BAD_INPUT_DATA );
    }

    /*
      SignedData ::= SEQUENCE {
      version Version,
      digestAlgorithms DigestAlgorithmIdentifiers,
      contentInfo ContentInfo,
      certificates
      [0] IMPLICIT ExtendedCertificatesAndCertificates
      OPTIONAL,
      crls
      [1] IMPLICIT CertificateRevocationLists OPTIONAL,
      signerInfos SignerInfos }
    */

    begin = *p;


    if( ( ret = asn1_get_tag( p, end, &len,
                              ASN1_CONSTRUCTED | ASN1_SEQUENCE ) ) != 0 )
    {
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT + ret );
    }

    if( *p + len != end )
    {
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT +
                POLARSSL_ERR_ASN1_LENGTH_MISMATCH );
    }

    ctx->raw.p = (unsigned char*) polarssl_malloc( end - begin );

    if( ctx->raw.p == NULL )
    {
        return( POLARSSL_ERR_PKCS7_MALLOC_FAILED );
    }

    memcpy( ctx->raw.p, begin , end - begin );
    ctx->raw.len = end - begin;

    /* switch P to local pointer */
    begin = ctx->raw.p + ( *p - begin );
    end = begin + len;
    /* move p to end of signData */
    *p += len;

    /* get version Version ::= INTEGER */
    if( ( ret = asn1_get_int( &begin, end, &ctx->version ) ) != 0 ||
        ctx->version != 1 )
    {
        return( POLARSSL_ERR_PKCS7_INVALID_VERSION );
    }

    /* get digest algorithms */
    if( ( ret = pkcs7_signed_data_get_digest_algos( &begin, end,
                                                    &ctx->digest_algos) ) != 0 )
    {
        return( ret );
    }

    content = begin;

    if( ( ret = asn1_get_tag( &begin, end, &len,
                             ASN1_CONSTRUCTED | ASN1_SEQUENCE ) ) != 0 )
    {
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT + ret );
    }

    begin += len;
    /* contentInfo is the content that is signed. It can
       have any of the defined content types. */
    ctx->content_info = (pkcs7_context*) polarssl_malloc( sizeof( pkcs7_context ) );
    if( ctx->content_info == NULL )
    {
        return( POLARSSL_ERR_PKCS7_MALLOC_FAILED );
    }
    pkcs7_init( ctx->content_info );
    if( ( ret = pkcs7_parse( ctx->content_info, content, begin - content ) ) != 0 )
    {
        return( ret );
    }

    /* certificates OPTIONAL */
    if( ( ret = asn1_get_tag( &begin, end, &len,
                              ASN1_CONSTRUCTED | ASN1_CONTEXT_SPECIFIC | 0 ) ) == 0)
    {
        x509_crt_init( &ctx->certs );
        temp = content = begin;
        begin += len;
        
        while( content < begin )
        {
            if( ( ret = asn1_get_tag( &temp, end, &len,
                                     ASN1_CONSTRUCTED | ASN1_SEQUENCE) ) != 0 )
            {
                return( POLARSSL_ERR_PKCS7_INVALID_FORMAT );
            }
            temp += len;
            
            if( ( ret = x509_crt_parse( &ctx->certs, content,
                                       temp - content ) ) != 0)
            {
                return( ret );
            }
            /* move pointer to next cert */
            content = temp;
        }
        
        if( content != begin)
        {
            return( POLARSSL_ERR_PKCS7_INVALID_FORMAT );
        }
    }

    /* crls OPTIONAL */
    if( ( ret = asn1_get_tag( &begin, end , &len,
                              ASN1_CONSTRUCTED | ASN1_CONTEXT_SPECIFIC | 1 ) ) == 0)
    {
        if( ( ret = x509_crl_parse(&ctx->crls, begin, len ) ) != 0)
        {
            return( ret );
        }
        
        temp = content = begin;
        begin += len;
        
        while( content < begin )
        {
            if( ( ret = asn1_get_tag( &temp, end, &len,
                                     ASN1_CONSTRUCTED | ASN1_SEQUENCE) ) != 0 )
            {
                return( POLARSSL_ERR_PKCS7_INVALID_FORMAT );
            }
            temp += len;
            
            if( ( ret = x509_crl_parse( &ctx->crls, content,
                                       temp - content ) ) != 0)
            {
                return( ret );
            }
            /* move pointer to next cert */
            content = temp;
        }
        
        if( content != begin)
        {
            return( POLARSSL_ERR_PKCS7_INVALID_FORMAT );
        }
        
        begin += len;
    }
    /* signer infos */
    ret = pkcs7_signed_data_get_signer_infos( &begin, end, ctx );

    return( ret );
}

void pkcs7_signed_data_free( pkcs7_signed_data_context *ctx )
{

    digest_algo_type_t *alg_cur, *alg_next;
    signer_info_t *info_cur, *info_next;

    if( ctx->raw.len )
    {
        polarssl_free( ctx->raw.p );
    }

    alg_cur = ctx->digest_algos.next;
    while( alg_cur )
    {
        alg_next = alg_cur->next;
        polarssl_free( alg_cur );
        alg_cur = alg_next;
    }

    pkcs7_free( ctx->content_info );
    polarssl_free( ctx->content_info );

    x509_crt_free( &ctx->certs );
    x509_crt_free( &ctx->certs );

    info_cur = ctx->signer_infos;
    while( info_cur )
    {
        info_next = info_cur->next;
        pkcs7_signer_info_free( info_cur );
        polarssl_free( info_cur );
        info_cur = info_next;
    }

    polarssl_zeroize( ctx, sizeof( pkcs7_signed_data_context ) );
}

int pkcs7_get_singer_info_count( pkcs7_context *ctx, int *count )
{
    pkcs7_signed_data_context *signed_data_ctx;

    if( POLARSSL_P7_SIGNED_DATA != pkcs7_get_type( ctx ) )
    {
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT );
    }

    signed_data_ctx = p7_signed_data( ctx );

    if( signed_data_ctx == NULL )
    {
        return( POLARSSL_ERR_PKCS7_INVALID_FORMAT );
    }

    *count = signed_data_ctx->signer_info_count;

    return( 0 );
}

signed_data_content_type_t pkcs7_get_signed_data_content_type( pkcs7_context *ctx )
{
    pkcs7_signed_data_context *signed_data_ctx;
    pkcs7_data_context *data_ctx;

    if( POLARSSL_P7_SIGNED_DATA != pkcs7_get_type( ctx ) )
        return( SIGNED_DATA_NONE );

    signed_data_ctx = p7_signed_data( ctx );
    data_ctx = p7_data( signed_data_ctx->content_info );

    if( data_ctx->data.len == 0 )
        return( SIGNED_DATA_DETACHED );

    return( SIGNED_DATA_ATTACHED );
}
}

#endif  /* POLARSSL_PKCS7_SIGNED_DATA_C */
