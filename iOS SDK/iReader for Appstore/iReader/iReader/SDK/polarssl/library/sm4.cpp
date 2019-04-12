/*
 * Implementation of sm4 encryption/decryption
 *
 * Reference:
 * http://www.oscca.gov.cn/UpFile/200621016423197990.pdf
 */

#if !defined(POLARSSL_CONFIG_FILE)
#include "polarssl/config.h"
#else
#include POLARSSL_CONFIG_FILE
#endif

#if defined(POLARSSL_SM4_C)

#include "polarssl/sm4.h"

#if defined(POLARSSL_PLATFORM_C)
#include "polarssl/platform.h"
#else
#define polarssl_printf printf
#endif

namespace FT_POLARSSL {
/* Implementation that should never be optimized out by the compiler */
static void polarssl_zeroize( void *v, size_t n ) {
    volatile unsigned char *p = (volatile unsigned char *)v; while( n-- ) *p++ = 0;
}

/*
 * 32-bit integer manipulation macros (big endian)
 */
#ifndef GET_UINT32_BE
#define GET_UINT32_BE(n,b,i)                            \
    {                                                   \
        (n) = ( (uint32_t) (b)[(i)    ] << 24 )         \
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

#define SWAP(a,b) { uint32_t t = a; a = b; b = t; t = 0; }

#define S(x,n) ((x << n) | ((x & 0xFFFFFFFF) >> (32 - n)))
#define T(x1, x2, x3, k) {                      \
        A = (x1) ^ (x2) ^ (x3) ^ (k);           \
        PUT_UINT32_BE(A, a, 0);                 \
        b[0] = SBOX[a[0]];                      \
        b[1] = SBOX[a[1]];                      \
        b[2] = SBOX[a[2]];                      \
        b[3] = SBOX[a[3]];                      \
        GET_UINT32_BE(B, b, 0);                 \
    }

static const unsigned char SBOX[256] = {
    0xd6,0x90,0xe9,0xfe,0xcc,0xe1,0x3d,0xb7,0x16,0xb6,0x14,0xc2,0x28,0xfb,0x2c,0x05,
    0x2b,0x67,0x9a,0x76,0x2a,0xbe,0x04,0xc3,0xaa,0x44,0x13,0x26,0x49,0x86,0x06,0x99,
    0x9c,0x42,0x50,0xf4,0x91,0xef,0x98,0x7a,0x33,0x54,0x0b,0x43,0xed,0xcf,0xac,0x62,
    0xe4,0xb3,0x1c,0xa9,0xc9,0x08,0xe8,0x95,0x80,0xdf,0x94,0xfa,0x75,0x8f,0x3f,0xa6,
    0x47,0x07,0xa7,0xfc,0xf3,0x73,0x17,0xba,0x83,0x59,0x3c,0x19,0xe6,0x85,0x4f,0xa8,
    0x68,0x6b,0x81,0xb2,0x71,0x64,0xda,0x8b,0xf8,0xeb,0x0f,0x4b,0x70,0x56,0x9d,0x35,
    0x1e,0x24,0x0e,0x5e,0x63,0x58,0xd1,0xa2,0x25,0x22,0x7c,0x3b,0x01,0x21,0x78,0x87,
    0xd4,0x00,0x46,0x57,0x9f,0xd3,0x27,0x52,0x4c,0x36,0x02,0xe7,0xa0,0xc4,0xc8,0x9e,
    0xea,0xbf,0x8a,0xd2,0x40,0xc7,0x38,0xb5,0xa3,0xf7,0xf2,0xce,0xf9,0x61,0x15,0xa1,
    0xe0,0xae,0x5d,0xa4,0x9b,0x34,0x1a,0x55,0xad,0x93,0x32,0x30,0xf5,0x8c,0xb1,0xe3,
    0x1d,0xf6,0xe2,0x2e,0x82,0x66,0xca,0x60,0xc0,0x29,0x23,0xab,0x0d,0x53,0x4e,0x6f,
    0xd5,0xdb,0x37,0x45,0xde,0xfd,0x8e,0x2f,0x03,0xff,0x6a,0x72,0x6d,0x6c,0x5b,0x51,
    0x8d,0x1b,0xaf,0x92,0xbb,0xdd,0xbc,0x7f,0x11,0xd9,0x5c,0x41,0x1f,0x10,0x5a,0xd8,
    0x0a,0xc1,0x31,0x88,0xa5,0xcd,0x7b,0xbd,0x2d,0x74,0xd0,0x12,0xb8,0xe5,0xb4,0xb0,
    0x89,0x69,0x97,0x4a,0x0c,0x96,0x77,0x7e,0x65,0xb9,0xf1,0x09,0xc5,0x6e,0xc6,0x84,
    0x18,0xf0,0x7d,0xec,0x3a,0xdc,0x4d,0x20,0x79,0xee,0x5f,0x3e,0xd7,0xcb,0x39,0x48
};


static void sm4_setkey( uint32_t SK[32], const unsigned char key[SM4_KEY_SIZE] )
{
    uint32_t MK[4], K[36], A, B; /* C = L(B) */
    unsigned char a[4], b[4];
    size_t i;
    /* system parameter */
    static const uint32_t FK[4] = {
        0xA3B1BAC6,
        0x56AA3350,
        0x677D9197,
        0xB27022DC
    };

    /* fixed parameter */
    static const uint32_t CK[32] = {
        0x00070e15, 0x1c232a31, 0x383f464d, 0x545b6269,
        0x70777e85, 0x8c939aa1, 0xa8afb6bd, 0xc4cbd2d9,
        0xe0e7eef5, 0xfc030a11, 0x181f262d, 0x343b4249,
        0x50575e65, 0x6c737a81, 0x888f969d, 0xa4abb2b9,
        0xc0c7ced5, 0xdce3eaf1, 0xf8ff060d, 0x141b2229,
        0x30373e45, 0x4c535a61, 0x686f767d, 0x848b9299,
        0xa0a7aeb5, 0xbcc3cad1, 0xd8dfe6ed, 0xf4fb0209,
        0x10171e25, 0x2c333a41, 0x484f565d, 0x646b7279
    };

    GET_UINT32_BE( MK[0], key, 0 );
    GET_UINT32_BE( MK[1], key, 4 );
    GET_UINT32_BE( MK[2], key, 8 );
    GET_UINT32_BE( MK[3], key, 12 );

    K[0] = MK[0] ^ FK[0];
    K[1] = MK[1] ^ FK[1];
    K[2] = MK[2] ^ FK[2];
    K[3] = MK[3] ^ FK[3];


#define L(x) ((x) ^ S(x, 13) ^ S(x, 23))

    for( i = 0; i < 32; i++ )
    {
        T(K[i+1], K[i+2], K[i+3], CK[i]);
        K[i+4] = K[i] ^ L(B);
        SK[i] = K[i+4];
    }
#undef L
}

void sm4_init( sm4_context *ctx )
{
    memset( ctx, 0, sizeof( sm4_context ) );
}

void sm4_free( sm4_context *ctx )
{
    if( ctx == NULL )
        return;

    polarssl_zeroize( ctx, sizeof( sm4_context ) );
}

int sm4_setkey_enc( sm4_context *ctx, const unsigned char key[SM4_KEY_SIZE] )
{
    sm4_setkey( ctx->sk, key );

    return( 0 );
}

int sm4_setkey_dec( sm4_context *ctx, const unsigned char key[SM4_KEY_SIZE] )
{
    int i;

    sm4_setkey( ctx->sk, key );

    for( i = 0; i < 16; i++ )
    {
        SWAP( ctx->sk[i    ], ctx->sk[31 - i] );
    }

    return( 0 );
}


int sm4_crypt_ecb( sm4_context *ctx,
                   const unsigned char input[16],
                   unsigned char output[16] )
{
    uint32_t X[36], A, B; //C = L(B);
    unsigned char a[4], b[4];
    size_t i;

    GET_UINT32_BE( X[0], input,  0 );
    GET_UINT32_BE( X[1], input,  4 );
    GET_UINT32_BE( X[2], input,  8 );
    GET_UINT32_BE( X[3], input, 12 );

#define L(x) ((x) ^ S(x, 2) ^ S(x, 10) ^ S(x, 18) ^ S(x, 24))

    for( i = 0; i < 32; i++ )
    {
        T(X[i+1], X[i+2], X[i+3], ctx->sk[i]);

        X[i+4] = X[i] ^ L(B);
    }

#undef L
    /* output =  R(X32, X33, X34, X35) = (X35, X34, X33, X32)*/
    PUT_UINT32_BE( X[35], output,  0 );
    PUT_UINT32_BE( X[34], output,  4 );
    PUT_UINT32_BE( X[33], output,  8 );
    PUT_UINT32_BE( X[32], output, 12 );
    polarssl_zeroize( X, sizeof(X) );
    return( 0 );
}

#undef T
#undef S

#if defined(POLARSSL_CIPHER_MODE_CBC)

int sm4_crypt_cbc( sm4_context *ctx,
                   int mode,
                   size_t length,
                   unsigned char iv[16],
                   const unsigned char *input,
                   unsigned char output[16] )
{
    int i;
    unsigned char temp[16];
    if( length % 16 )
        return ( POLARSSL_ERR_SM4_INVALID_INPUT_LENGTH );
    if( mode == SM4_ENCRYPT )
    {
        while( length > 0 )
        {
            for( i = 0; i < 16; i++)
                output[i] = (unsigned char)( input[i] ^ iv[i] );

            sm4_crypt_ecb( ctx, output, output );
            memcpy( iv, output, 16 );

            input  += 16;
            output += 16;
            length -= 16;
        }
    }
    else                       /* SM4_DECRYPT */
    {
        while( length > 0 )
        {
            memcpy( temp, input, 16 );
            sm4_crypt_ecb( ctx, input , output );

            for( i = 0; i < 16; i++ )
                output[i] = (unsigned char)( output[i] ^ iv[i] );

            memcpy( iv, temp,  16 );
            input  += 16;
            output += 16;
            length -= 16;
        }
    }

    return( 0 );
}

#endif  /* POLARSSL_CIPHER_MODE_CBC */

#if defined(POLARSSL_SELF_TEST)
static const unsigned char sm4_test_key[16] = {
    0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef,
    0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x10
};

static const unsigned char sm4_test_buf[16] = {
    0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef,
    0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x10
};

static const unsigned char sm4_ecb_enc[2][16] = {
    {
        0x68, 0x1e, 0xdf, 0x34, 0xd2, 0x06, 0x96, 0x5e,
        0x86, 0xb3, 0xe9, 0x4f, 0x53, 0x6e, 0x42, 0x46
    },
    {
        0x59, 0x52, 0x98, 0xc7, 0xc6, 0xfd, 0x27, 0x1f,
        0x04, 0x02, 0xf8, 0x04, 0xc3, 0x3d, 0x3f, 0x66
    }
};

int sm4_self_test( int verbose )
{
    sm4_context ctx;
    int ret = 0;
    size_t i;
    unsigned char output[16];

    sm4_init( &ctx );

    /* encryption test */
    ctx.mode = SM4_ENCRYPT;
    sm4_setkey_enc( &ctx, sm4_test_key );

    sm4_crypt_ecb( &ctx, sm4_test_buf, output );
    if( memcmp( output, sm4_ecb_enc[0], 16) != 0 )
    {
        if( verbose != 0)
        {
            polarssl_printf( "  sm4 encryption failed\n" );
            ret = 1;
            goto err;
        }
    }

    polarssl_printf( "  sm4 encryption passed \n" );


    i = 0;
    while( i++ < 1000000 - 1  )
    {
        sm4_crypt_ecb( &ctx, output, output );
    }

    if(memcmp( output, sm4_ecb_enc[1], 16) != 0 )
    {
        if( verbose != 0)
        {
            polarssl_printf( "  sm4 encryption failed\n" );
            ret = 1;
            goto err;
        }
    }

    polarssl_printf( "  sm4 encryption passed \n" );

    /* decryption test */
    ctx.mode = SM4_DECRYPT;
    sm4_setkey_dec( &ctx, sm4_test_key );

    sm4_crypt_ecb( &ctx, sm4_ecb_enc[0], output );
    if( memcmp( output, sm4_test_buf, 16 ) != 0 )
    {
        if( verbose != 0 )
        {
            polarssl_printf( "  sm4 decryption failed\n" );
            ret = 1;
            goto err;
        }
    }

    polarssl_printf( "  sm4 decryption passed \n" );

    sm4_crypt_ecb( &ctx, sm4_ecb_enc[1], output);
    i = 0;
    while( i++ < 1000000 - 1  )
    {
        sm4_crypt_ecb( &ctx, output, output );
    }

    if( memcmp( output, sm4_test_buf, 16) != 0 )
    {
        if( verbose != 0)
        {
            polarssl_printf( "  sm4 decryption failed\n" );
            ret = 1;
            goto err;
        }
    }

    polarssl_printf( "  sm4 decryption passed \n" );
     


err:
    sm4_free( &ctx );
    return( ret );
}

#endif  /* POLARSSL_SELF_TEST */
}

#endif  /* POLARSSL_SM4_C */
