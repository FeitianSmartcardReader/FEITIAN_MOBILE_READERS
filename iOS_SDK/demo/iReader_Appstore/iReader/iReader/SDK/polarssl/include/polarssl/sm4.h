/**
 * \file sm4.h
 *
 * \brief SM4 block cipher
 *
 */

#ifndef POLARSSL_SM4_H
#define POLARSSL_SM4_H

#if !defined(POLARSSL_CONFIG_FILE)
#include "config.h"
using namespace FT_POLARSSL;
#else
#include POLARSSL_CONFIG_FILE
#endif

#include <string.h>

#if defined(_MSC_VER) && !defined(EFIX64) && !defined(EFI32)
#include <basetsd.h>
namespace FT_POLARSSL {
typedef UINT32 uint32_t;
}
#else
#include <inttypes.h>
#endif

namespace FT_POLARSSL {
	
#define SM4_ENCRYPT     1
#define SM4_DECRYPT     0

#define SM4_KEY_SIZE    16

#define POLARSSL_ERR_SM4_INVALID_INPUT_LENGTH  -0x0042

/**
 * \brief             SM4 context structure
 */
typedef struct
{
    int mode;             /*!< encrypt/decrypt */
    uint32_t sk[32];      /*!< SM4 subkeys */
} sm4_context;

/**
 * \brief            Initialize SM4 context
 *
 * \param ctx        SM4 context to be initialized
 */
void sm4_init( sm4_context *ctx );

/**
 * \brief            Clear SM4 context
 *
 * \param ctx        SM4 context to be cleared
 */
void sm4_free( sm4_context *ctx );

/**
 * \brief            SM4 key schedule (encryption)
 *
 * \param ctx        SM4 context to be initialized
 * \param key        8-byte secret key
 *
 * \return           0
 */
int sm4_setkey_enc( sm4_context *ctx, const unsigned char key[SM4_KEY_SIZE] );

/**
 * \brief            SM4 key schedule (decryption)
 *
 * \param ctx        SM4 context to be initialized
 * \param key        8-byte secret key
 *
 * \return           0
 */
int sm4_setkey_dec( sm4_context *ctx, const unsigned char key[SM4_KEY_SIZE] );

/**
 * \brief            SM4-ECB block encryptio/decryption
 *
 * \param ctx        SM4 context
 * \param input      64-bit input block
 * \param output     64-bit output block
 *
 * \return           0 if successful
 */
int sm4_crypt_ecb( sm4_context *ctx,
                   const unsigned char input[16],
                   unsigned char output[16] );

#if defined(POLARSSL_CIPHER_MODE_CBC)

/**
 * \brief            SM4-CBC buffer encryption/decryption
 *
 * \param ctx        SM4 context
 * \param mode       SM4_ENCRYPT or SM4_DECRYPT
 * \param length     length of the input data
 * \param iv         initialization vector (updated after use)
 * \param input      buffer holding the input data
 * \param output     buffer holding the output data
 */
int sm4_crypt_cbc( sm4_context *ctx,
                   int mode,
                   size_t length,
                   unsigned char iv[16],
                   const unsigned char *input,
                   unsigned char *output );
#endif

int sm4_self_test( int verbose );
}

#endif  /* POLARSSL_SM4_H */
