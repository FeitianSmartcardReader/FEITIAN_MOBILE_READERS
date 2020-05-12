/*
 *  SM3 implementation
 *
 *  Reference:
 *  http://www.oscca.gov.cn/UpFile/20101222141857786.pdf
 */

#if !defined(POLARSSL_CONFIG_FILE)
#include "polarssl/config.h"
#else
#include POLARSSL_CONFIG_FILE
#endif

#if defined(POLARSSL_SM3_C)

#include "polarssl/sm3.h"

#if defined(POLARSSL_FS_IO) || defined(POLARSSL_SELF_TEST)
#include <stdio.h>
#endif

#if defined(POLARSSL_PLATFORM_C)
#include "polarssl/platform.h"
#else
#define polarssl_printf printf
#endif

namespace FT_POLARSSL {
static void polarssl_zeroize(void *v, size_t n){
    volatile unsigned char *p = (volatile unsigned char *)v; while( n-- ) *p++ = 0;
}

/*
 * 32-bit integer manipulation macros (big endian)
 */
#ifndef GET_UINT32_BE
#define GET_UINT32_BE(n,b,i)                            \
    {                                                   \
        (n) = ( (uint32_t) (b)[(i)    ] << 24 )        \
            | ( (uint32_t) (b)[(i) + 1] << 16 )         \
            | ( (uint32_t) (b)[(i) + 2] <<  8 )         \
            | ( (uint32_t) (b)[(i) + 3]       );        \
    }
#endif

#ifndef PUT_UINT32_BE
#define PUT_UINT32_BE(n,b,i)                            \
    {                                                   \
        (b)[(i)    ] = (unsigned char) ( (n) >> 24 );   \
        (b)[(i) + 1] = (unsigned char) ( (n) >> 16 );   \
        (b)[(i) + 2] = (unsigned char) ( (n) >>  8 );   \
        (b)[(i) + 3] = (unsigned char) ( (n)       );   \
    }
#endif

void sm3_init( sm3_context *ctx )
{
    memset( ctx, 0, sizeof( sm3_context ) );
}

void sm3_free( sm3_context *ctx )
{
    if ( ctx == NULL )
        return;

    polarssl_zeroize( ctx, sizeof( sm3_context ) );
}

void sm3_starts( sm3_context *ctx )
{
    ctx->total[0] = 0;
    ctx->total[1] = 0;

    ctx->state[0] = 0x7380166F;
    ctx->state[1] = 0x4914B2B9;
    ctx->state[2] = 0x172442D7;
    ctx->state[3] = 0xDA8A0600;
    ctx->state[4] = 0xA96F30BC;
    ctx->state[5] = 0x163138AA;
    ctx->state[6] = 0xE38DEE4D;
    ctx->state[7] = 0xB0FB0E4E;
}

void sm3_process( sm3_context *ctx, const unsigned char data[64] )
{
    uint32_t A, B, C, D, E, F, G, H;
    uint32_t W1[68], W2[64];
    uint32_t tt1, tt2;
    int j;
    GET_UINT32_BE( W1[ 0], data,  0 );
    GET_UINT32_BE( W1[ 1], data,  4 );
    GET_UINT32_BE( W1[ 2], data,  8 );
    GET_UINT32_BE( W1[ 3], data, 12 );
    GET_UINT32_BE( W1[ 4], data, 16 );
    GET_UINT32_BE( W1[ 5], data, 20 );
    GET_UINT32_BE( W1[ 6], data, 24 );
    GET_UINT32_BE( W1[ 7], data, 28 );
    GET_UINT32_BE( W1[ 8], data, 32 );
    GET_UINT32_BE( W1[ 9], data, 36 );
    GET_UINT32_BE( W1[10], data, 40 );
    GET_UINT32_BE( W1[11], data, 44 );
    GET_UINT32_BE( W1[12], data, 48 );
    GET_UINT32_BE( W1[13], data, 52 );
    GET_UINT32_BE( W1[14], data, 56 );
    GET_UINT32_BE( W1[15], data, 60 );

#define S(x,n) ((x << n%32) | ((x & 0xFFFFFFFF) >> (32 - n%32)))
#define P(x) ((x) ^ (S((x), 15)) ^ (S((x), 23)))
#define R(t)                                                    \
    (                                                           \
        P(W1[ t - 16 ] ^ W1[ t - 9 ] ^ S(W1[ t - 3 ], 15)) ^    \
        S(W1[ t - 13 ], 7) ^                                    \
        W1[ t - 6]                                              \
        )

    for ( j = 16; j < 68; j++)
        W1[j] = R(j);

    for ( j = 0; j < 64; j++)
        W2[j] = W1[j] ^ W1[j+4];

#undef P
#undef R


#define P(x) (x ^ (S(x, 9)) ^ (S(x, 17)))
#define SS1(t) (S((S(A,12) + E + S(T, t)), 7))
#define SS2(t) (SS1(t) ^ S(A, 12))
#define TT1(t) (FF(A, B, C) + D + SS2(t) + W2[t])
#define TT2(t) (GG(E, F, G) + H + SS1(t) + W1[t])

#define T 0x79CC4519
#define FF(x, y, z) (x ^ y ^ z)
#define GG(x, y, z) (x ^ y ^ z)

#define CF(a, b, c, d, e, f, g, h, t)           \
    {                                           \
        tt1 = TT1(t);                           \
        tt2 = TT2(t);                           \
        d = c;                                  \
        c = S(b, 9);                            \
        b = a;                                  \
        a = tt1;                                \
        h = g;                                  \
        g = S(f, 19);                           \
        f = e;                                  \
        e = P(tt2);                             \
    }

    A = ctx->state[0];
    B = ctx->state[1];
    C = ctx->state[2];
    D = ctx->state[3];
    E = ctx->state[4];
    F = ctx->state[5];
    G = ctx->state[6];
    H = ctx->state[7];

    for( j = 0; j < 16; j++ )
        CF(A, B, C, D, E, F, G, H, j);

#undef T
#undef FF
#undef GG

#define T 0x7A879D8A
#define FF(x, y, z) ((x & y) | (x & z) | (y & z))
#define GG(x, y, z) ((x & y) |((~x) & z))

    for( j = 16; j < 64; j++ )
        CF(A, B, C, D, E, F, G, H, j);

#undef S
#undef T
#undef FF
#undef GG
#undef P
#undef SS1
#undef SS2
#undef TT1
#undef TT2
#undef CF

    ctx->state[0] ^= A;
    ctx->state[1] ^= B;
    ctx->state[2] ^= C;
    ctx->state[3] ^= D;
    ctx->state[4] ^= E;
    ctx->state[5] ^= F;
    ctx->state[6] ^= G;
    ctx->state[7] ^= H;
}

void sm3_update( sm3_context *ctx, const unsigned char *input, size_t ilen )
{
    size_t fill;
    uint32_t left;

    if( ilen == 0 )
        return;

    left = ctx->total[0] & 0x3F;
    fill = 64 - left;

    ctx->total[0] += (uint32_t) ilen;
    ctx->total[0] &= 0xFFFFFFFF;

    if( ctx->total[0] < (uint32_t) ilen )
        ctx->total[1]++;

    if( left && ilen >= fill )
    {
        memcpy( (void *) (ctx->buffer + left), input, fill );
        sm3_process( ctx, ctx->buffer );
        input += fill;
        ilen -= fill;
        left = 0;
    }

    while( ilen >= 64 )
    {
        sm3_process(ctx, input );
        input += 64;
        ilen -= 64;
    }
    if( ilen > 0 )
        memcpy( (void *) (ctx->buffer + left), input, ilen );
}

static const unsigned char sm3_padding[64] =
{
    0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};

void sm3_finish( sm3_context *ctx, unsigned char output[32] )
{
    unsigned int last, padn;
    unsigned int high, low;
    unsigned char msglen[8];

    high = ( ctx->total[0] >> 29 )
        | ( ctx->total[1] <<  3 );
    low  = ( ctx->total[0] <<  3 );

    PUT_UINT32_BE( high, msglen, 0 );
    PUT_UINT32_BE( low,  msglen, 4 );

    last = ctx->total[0] & 0x3F;
    padn = ( last < 56 ) ? ( 56 - last ) : ( 120 - last );

    sm3_update( ctx, (unsigned char *) sm3_padding, padn );
    sm3_update( ctx, msglen, 8 );

    PUT_UINT32_BE( ctx->state[0], output,  0 );
    PUT_UINT32_BE( ctx->state[1], output,  4 );
    PUT_UINT32_BE( ctx->state[2], output,  8 );
    PUT_UINT32_BE( ctx->state[3], output, 12 );
    PUT_UINT32_BE( ctx->state[4], output, 16 );
    PUT_UINT32_BE( ctx->state[5], output, 20 );
    PUT_UINT32_BE( ctx->state[6], output, 24 );
    PUT_UINT32_BE( ctx->state[7], output, 28 );
}

void sm3( const unsigned char *input, size_t ilen, unsigned char output[32] )
{
    sm3_context ctx;

    sm3_init( &ctx );
    sm3_starts( &ctx );
    sm3_update( &ctx, input, ilen );
    sm3_finish( &ctx, output );
    sm3_free( &ctx );
}

void sm3_hmac_starts( sm3_context *ctx, const unsigned char *key, size_t keylen )
{
    size_t i;
    unsigned char sum[32];
    if( keylen > 64 )
    {
        sm3( key, keylen, sum );
        keylen = 32;
        key = sum;
    }

    memset( ctx->ipad, 0x36, 64 );
    memset( ctx->opad, 0x5c, 64 );

    for( i = 0; i < keylen; i++ )
    {
        ctx->ipad[i] = (unsigned char)( ctx->ipad[i] ^ key[i] );
        ctx->opad[i] = (unsigned char)( ctx->opad[i] ^ key[i] );
    }

    sm3_starts( ctx );
    sm3_update( ctx, ctx->ipad, 64 );

    polarssl_zeroize(sum, sizeof( sum ) );
}

void sm3_hmac_update( sm3_context *ctx, const unsigned char *input,
                      size_t ilen)
{
    sm3_update( ctx, input, ilen );
}

void sm3_hmac_finish( sm3_context *ctx, unsigned char output[32] )
{
    unsigned char tempbuf[32];

    sm3_finish( ctx, tempbuf );
    sm3_starts( ctx );
    sm3_update( ctx, ctx->opad, 64 );
    sm3_update( ctx, tempbuf, 32 );
    sm3_finish( ctx, output );

    polarssl_zeroize(tempbuf, sizeof(tempbuf) );
}

void sm3_hmac_reset( sm3_context *ctx )
{
    sm3_starts( ctx );
    sm3_update( ctx, ctx->ipad, 64 );
}

void sm3_hmac( const unsigned char *key, size_t keylen,
               const unsigned char *input, size_t ilen,
               unsigned char output[32] )
{
    sm3_context ctx;

    sm3_init( &ctx );
    sm3_hmac_starts( &ctx, key, keylen );
    sm3_hmac_update( &ctx, input, ilen );
    sm3_hmac_finish( &ctx, output );

    sm3_free( &ctx );
}

#if defined(POLARSSL_SELF_TEST)

static unsigned char sm3_test_buf[2][65] =
{
    { "abc" },
    { "abcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcd" }
};
static const int sm3_test_buflen[3] =
{
    3, 64
};
static const unsigned char sm3_test_sum[3][32] =
{
    { 0x66, 0xc7, 0xf0, 0xf4, 0x62, 0xee, 0xed, 0xd9, 0xd1, 0xf2,
      0xd4, 0x6b, 0xdc, 0x10, 0xe4, 0xe2, 0x41, 0x67, 0xc4, 0x87,
      0x5c, 0xf2, 0xf7, 0xa2, 0x29, 0x7d, 0xa0, 0x2b, 0x8f, 0x4b,
      0xa8, 0xe0 },
    { 0xde, 0xbe, 0x9f, 0xf9, 0x22, 0x75, 0xb8, 0xa1, 0x38, 0x60,
      0x48, 0x89, 0xc1, 0x8e, 0x5a, 0x4d, 0x6f, 0xdb, 0x70, 0xe5,
      0x38, 0x7e, 0x57, 0x65, 0x29, 0x3d, 0xcb, 0xa3, 0x9c, 0x0c,
      0x57, 0x32}
};
int sm3_self_test( int verbose )
{
    int i, ret = 0;
    unsigned char sm3sum[32];
    sm3_context ctx;

    sm3_init( &ctx );

    for( i = 0; i < 2; i++ )
    {
        if ( verbose != 0 )
            polarssl_printf("  SM3 test #%d: ", i + 1 );

        sm3_starts( &ctx );
        sm3_update( &ctx, sm3_test_buf[i], sm3_test_buflen[i] );
        sm3_finish( &ctx, sm3sum );
        if ( memcmp( sm3sum, sm3_test_sum[i], 32 ) != 0 )
        {
            if( verbose != 0)
            {
                polarssl_printf( "failed\n" );
                ret = 1;
                break;
            }
        }

        if( verbose != 0 )
            polarssl_printf( "passed\n");
    }

    sm3_free( &ctx );
    return(ret);
}

#endif  /* POLARSSL_SELF_TEST */
}

#endif  /* POLARSSL_SM3_C */
