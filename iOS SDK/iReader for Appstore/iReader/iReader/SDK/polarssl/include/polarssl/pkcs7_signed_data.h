/**
 * \file pkcs7_signed_data.h
 *
 * \brief pkcs7 signedData generic defines and structures. pkcs7 parse and verify
 */

#ifndef POLARSSL_PKCS7_SIGNED_DATA_H
#define POLARSSL_PKCS7_SIGNED_DATA_H

#if !defined(POLARSSL_CONFIG_FILE)
#include "config.h"
using namespace FT_POLARSSL;
#else
#include POLARSSL_CONFIG_FILE
#endif

#include "pkcs7.h"
#include "md.h"
#include "pk.h"
#include "x509_crt.h"

namespace FT_POLARSSL {

typedef enum{
    SIGNED_DATA_NONE = 0,
    SIGNED_DATA_ATTACHED,
    SIGNED_DATA_DETACHED,
} signed_data_content_type_t;

typedef struct _digest_algo_type_t
{
    md_type_t md_type;                /**< digest algorithm type */
    pk_type_t pk_type;                /**< public key algorithm type */
    struct _digest_algo_type_t *next; /**< next digest algo in the list  */
}
digest_algo_type_t;

typedef struct _signer_info
{
    pkcs7_buf raw;                  /**< raw SignerInfo buffer */
    int version;                    /**< version in signer info */
    digest_algo_type_t digest_algo; /**< hash/pk algorithm for signature  */
    x509_buf issuer_raw;            /**< issuer buffer */
    x509_name issuer;               /**< issuer of THIS signerinfo  */
    x509_buf serial;                /**< sierial number of THIS signer info  */

    pkcs7_buf sig;                  /**< encrypt digest, signature  */

    struct _signer_info *next;      /**< next signer info in the signed data  */
}
signer_info_t;

typedef struct _pkcs7_signed_data_context
{
    pkcs7_buf raw;                        /**< raw SignedData buffer */
    int version;                          /**< signedData version 1 = v1.5 */
    digest_algo_type_t  digest_algos;     /**< holding digestAlgorithms */
    pkcs7_context *content_info;          /**< content to be signed */
    x509_crt certs;                       /**< certs of signer  */
    x509_crl crls;                        /**< crls  */

    int signer_info_count;                /**< count of signer info in signed data */
    signer_info_t *signer_infos;          /**< signer info  */
}
pkcs7_signed_data_context;

/**
 * \brief                    Initialize signer info context
 *
 * \param signer_info        Signer info context
 */
void pkcs7_signer_info_init( signer_info_t *signer_info );

/**
 * \brief                    Parse signer info into signed data
 *
 * \param p                  Begin pointer of the buffer to parse
 * \param end                End of the buffer
 * \param signer_info        The context of signer info
 *
 * \return                   0 if successful, ohter failed
 */
int  pkcs7_signer_info_parse( unsigned char **p,
                              const unsigned char *end,
                              signer_info_t *signer_info);

/**
 * \brief                    Free signer info context
 *
 * \param signer_info        Signer info context
 */
void pkcs7_signer_info_free( signer_info_t *signer_info );

/**
 * \brief                    Initialize signed data context
 *
 * \param ctx                Signed data context
 */
void pkcs7_signed_data_init( pkcs7_signed_data_context *ctx );

/**
 * \brief                    Parse signed data struct, DER encoding
 *
 * \param p                  Begin pointer of the buffer to parse
 * \param end                End of the buffer
 * \param ctx                PKCS7 signed data context
 *
 * \return                   0 if successful, other failed
 */
int  pkcs7_signed_data_parse( unsigned char **p,
                              const unsigned char *end,
                              pkcs7_signed_data_context *ctx );

/**
 * \brief                    Free PKCS7 signed data context
 *
 * \param ctx                PKCS7 signed data context
 */
void pkcs7_signed_data_free( pkcs7_signed_data_context *ctx );

/**
 * \brief                    Get numbers of signer info in signed data
 *
 * \param ctx                PKCS7 context
 * \param count              Number of signer info
 *
 * \return                   0 if successful, ohter failed
 */
int pkcs7_get_singer_info_count( pkcs7_context *ctx, int *count );

/**
 * \brief                    Get content type of signed data.
 *
 * \param ctx                PKCS7 context
 *
 * \return                   SIGNED_DATA_ATTACHED if have content,
 *                           SIGNED_DATA_DETACHED if not have content,
 *                           SIGNED_DATA_NONE if ctx is not signed data type
 */
signed_data_content_type_t pkcs7_get_signed_data_content_type( pkcs7_context *ctx );

}

#endif  /* POLARSSL_PKCS7_SIGNED_DATA_H */
