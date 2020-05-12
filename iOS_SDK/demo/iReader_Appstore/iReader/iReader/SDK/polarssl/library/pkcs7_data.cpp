#if !defined(POLARSSL_CONFIG_FILE)
#include "polarssl/config.h"
#else
#include POLARSSL_CONFIG_FILE
#endif

#if defined(POLARSSL_PKCS7_DATA_C)
#include "polarssl/pkcs7_data.h"
#include "polarssl/asn1.h"
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

void pkcs7_data_init( pkcs7_data_context *ctx )
{
    polarssl_zeroize( ctx, sizeof( pkcs7_data_context ) );
}

int pkcs7_data_parse( unsigned char **p,
                      const unsigned char *end,
                      pkcs7_data_context *ctx)
{
    int ret;
    size_t len;
    unsigned char *begin;

    if ( *p == end )
    {
        ctx->data.p = NULL;
        ctx->data.len = 0;
        return( 0 );
    }
    begin = *p;
#if defined(DATA_CONTENT_END_AFTER_IDENTIFIER)
    return( POLARSSL_ERR_PKCS7_INVALID_FORMAT +
            POLARSSL_ERR_ASN1_LENGTH_MISMATCH );
#endif
    /* Data ::= OCTET STRING */


    if( ( ret = asn1_get_tag( p, end, &len, ASN1_OCTET_STRING ) ) != 0 )
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

    memcpy( ctx->raw.p, begin, ( end - begin ) );
    ctx->raw.len = end - begin;

    ctx->data.p = ctx->raw.p + (*p - begin );
    ctx->data.len = len;

    *p += len;

    return( 0 );
}

void pkcs7_data_free( pkcs7_data_context *ctx )
{
    if( ctx->raw.p )
    {
        polarssl_free( ctx->raw.p );
    }
    polarssl_zeroize( ctx, sizeof( pkcs7_data_context ) );
}
}

#endif  /* POLARSSL_PKCS7_DATA_C */
