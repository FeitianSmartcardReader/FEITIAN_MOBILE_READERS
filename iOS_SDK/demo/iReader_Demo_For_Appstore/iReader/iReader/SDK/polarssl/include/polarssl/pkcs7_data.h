/**
 * \file pkcs7_data.h
 *
 * \brief pkcs7 data generic defines and structures, pkcs7 data parse
 */

#ifndef POLARSSL_PKCS7_DATA_H
#define POLARSSL_PKCS7_DATA_H

#if !defined(POLARSSL_CONFIG_FILE)
#include "config.h"
using namespace FT_POLARSSL;
#else
#include POLARSSL_CONFIG_FILE
#endif

#include "asn1.h"
#include "pkcs7.h"

namespace FT_POLARSSL {

typedef struct
{
    pkcs7_buf raw;              /**< The raw DATA buffer */
    pkcs7_buf data;             /**< buffer hold DATA */
}
pkcs7_data_context;

/**
 * \brief                  Initialize PKCS7 data context
 *
 * \param ctx              PKCS7 data context
 */
void pkcs7_data_init( pkcs7_data_context *ctx );

/**
 * \brief                  Parser PKCS7 data struct, DER encoding
 *
 * \param p                Begin pointer of buffer
 * \param end              End of buffer
 * \param ctx              PKCS7 data context
 *
 * \return                 0 if successful, other faild
 */
int pkcs7_data_parse( unsigned char **p,
                      const unsigned char* end,
                      pkcs7_data_context *ctx );

/**
 * \brief                  Free PKCS7 data context
 *
 * \param ctx              PKCS7 data context
 */
void pkcs7_data_free( pkcs7_data_context *ctx );

}
#endif  /* POLARSSL_PKCS7_DATA_H */
