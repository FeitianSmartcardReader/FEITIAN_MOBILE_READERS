/**
 * \file pkcs7.h
 *
 * \brief pkcs7 generic defines and structures
 *
 */

#ifndef POLARSSL_PKCS7_H
#define POLARSSL_PKCS7_H

#if !defined(POLARSSL_CONFIG_FILE)
#include "config.h"
using namespace FT_POLARSSL;
#else
#include POLARSSL_CONFIG_FILE
#endif

#include "asn1.h"
#include "md.h"

namespace FT_POLARSSL {

/**
 * \name pkcs7 Error codes (reused with ssl error codes)
 */
#define POLARSSL_ERR_PKCS7_FEATURE_UNAVAILABLE          -0x2080
#define POLARSSL_ERR_PKCS7_UNKNOWN_OID                  -0x2100
#define POLARSSL_ERR_PKCS7_INVALID_FORMAT               -0x2180
#define POLARSSL_ERR_PKCS7_INVALID_VERSION              -0x2200
#define POLARSSL_ERR_PKCS7_INVALID_SERIAL               -0x2280
#define POLARSSL_ERR_PKCS7_INVALID_ALG                  -0x2300
#define POLARSSL_ERR_PKCS7_INVALID_NAME                 -0x2380
#define POLARSSL_ERR_PKCS7_INVALID_SIGNATURE            -0x2400
#define POLARSSL_ERR_PKCS7_INVALID_CERT                 -0x2480
#define POLARSSL_ERR_PKCS7_VERIFY_FAILED                -0x2500
#define POLARSSL_ERR_PKCS7_BAD_INPUT_DATA               -0x2580
#define POLARSSL_ERR_PKCS7_MALLOC_FAILED                -0x2600

typedef enum {
    POLARSSL_P7_NONE = 0,
    POLARSSL_P7_DATA,
    POLARSSL_P7_SIGNED_DATA,
    POLARSSL_P7_ENVELOPED_DATA,
    POLARSSL_P7_SIGNED_ENVELOPED_DATA,
    POLARSSL_P7_DIGESTED_DATA,
    POLARSSL_P7_ENCRYPTED_DATA,
    POLARSSL_P7_UNSUPPORTED_TYPE,
} pkcs7_type_t;

typedef asn1_buf pkcs7_buf;
struct _pkcs7_signed_data_context;
struct _pkcs7_data_context;

typedef struct _pkcs7_context
{
    pkcs7_buf raw;             /**< The raw pkcs7 data (DER) */
    pkcs7_type_t type;         /**< pkcs7 type, one of pkcs7_type_t */
    void *content;             /**< specific type ctx. */
}
pkcs7_context;

#define p7_data( p7 )            ( (pkcs7_data_context *) (p7)->content )
#define p7_signed_data( p7)      ( (pkcs7_signed_data_context *) (p7)->content )

/**
 * \brief        Initialize pkcs7_context
 *
 * \param ctx    PKCS7 context
 */

void pkcs7_init( pkcs7_context *ctx );

/**
 * \brief        Parse PKCS7 formated data
 *
 * \param ctx    PKCS7 context
 * \param input  Data buffer to parse
 * \param ilen   Data buffer len
 *
 * \return       0 successful, other error
 */

int pkcs7_parse( pkcs7_context *ctx, const unsigned char *input, size_t ilen);


/**
 * \brief        Get pkcs7 type, defined in pkcs7_type_t
 *
 * \param ctx    PKCS7 context
 *
 * \return       type of this ctx
 */

pkcs7_type_t  pkcs7_get_type( pkcs7_context* ctx );

/**
 * \brief        Free context
 *
 * \param ctx    PKCS7 context
 */
void pkcs7_free( pkcs7_context *ctx );

/**
 * \brief        Verfiy attached singedData
 *
 * \param ctx    PKCS7<signedData> context
 *
 * \return       0 successful, othre error
 */
int pkcs7_verify_signed_data( pkcs7_context *ctx );

/**
 * \brief        Verify detached signedData
 *
 * \param ctx    PKCS7<undetached signedData> context
 * \param input  external data, to be verify
 * \param ilen   length of input
 */
int pkcs7_verify_signed_data_detached( pkcs7_context *ctx,
                                       const unsigned char *input,
                                       size_t ilen );

}

#endif  /* POLARSSL_PKCS7_H */
