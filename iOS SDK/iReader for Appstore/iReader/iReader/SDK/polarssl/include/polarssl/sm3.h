/**
 * \file sm3.h
 *
 * \brief SM3 cryptographic hash function
 *
 * 
 */
#ifndef POLARSSL_SM3_H
#define POLARSSL_SM3_H

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

/**
 * \brief sm3 context structure
 */
typedef struct
{
    uint32_t total[2];          /*!< number of bytes processed */
    uint32_t state[8];          /*!< intermediate digest state */
    unsigned char buffer[64];   /*!< data block being processed */
    unsigned char ipad[64];     /*!< HMAC: inner padding */
    unsigned char opad[64];     /*!< HMAC: outer padding */
}
sm3_context;

/**
 * \brief                     Inintialize SM3 context
 *
 * \param ctx                 SM3 context to be initialized
 */
void sm3_init( sm3_context *ctx );

/**
 * \brief                      Clear SM3 context
 *
 * \param ctx                  SM3 context to be cleared
 */
void sm3_free( sm3_context *ctx );

/**
 * \brief                       SM3 context steup
 *
 * \param ctx                   context to be initialized
 */
void sm3_starts( sm3_context *ctx );

/**
 * \brief                       SM3 process buffer
 *
 * \param ctx                   SM3 context
 * \param input                 buffer holding the data
 * \param ilen                  length of the input data
 */
void sm3_update( sm3_context *ctx, const unsigned char *input, size_t ilen );

/**
 * \brief                        SM3 final digest
 *
 * \param ctx                    SM3 context
 * \param output                 SM3 checksum result
 */
void sm3_finish( sm3_context *ctx, unsigned char output[32] );

/* Internal use */
void sm3_process( sm3_context *ctx, const unsigned char data[64] );

/**
 * \brief                         Output = SM3( input buffer )
 * 
 * \param input                   buffer holding the data
 * \param ilen                    length of the input data
 * \param output                  SM3 checksum result
 */
void sm3( const unsigned char *input, size_t ilen, unsigned char output[32] );

/**
 * \brief                         SM3 HMAC context setup
 *
 * \param key                     HMAC secret key
 * \param keylen                  length of the HMAC key
 */
void sm3_hmac_starts( sm3_context *ctx, const unsigned char *key,
                      size_t keylen );

/**
 * \brief                         SM3 HMAC process buffer
 *
 * \param ctx                     HMAC context
 * \param input                   buffer holding the data
 * \param ilen                    length of the input data
 */
void sm3_hmac_update( sm3_context *ctx, const unsigned char *input,
                      size_t ilen );

/**
 * \brief                         SM3 HMAC final digest
 *
 * \param ctx                     HMAC context
 * \param output                  SM3 HMAC checksum result
 */
void sm3_hmac_finish( sm3_context *ctx, unsigned char output[32] );

/**
 * \brief                         SM3 HMAC context reset
 *
 * \param ctx                     HMAC context to be reset
 */
void sm3_hmac_reset( sm3_context *ctx );

/**
 * \brief                         Output = HMAC-SM3( hmac key, input buffer )
 *
 * \param key                     HMAC secret key
 * \param keylen                  length of the HMAC secret key
 * \param input                   buffer holding the data
 * \param ilen                    length of the input data
 * \param output                  HMAC-SM3 result
 */
void sm3_hmac( const unsigned char *key, size_t keylen,
               const unsigned char *input, size_t ilen,
               unsigned char output[32] );

int sm3_self_test( int verbose );
}

#endif  /* sm3.h */
