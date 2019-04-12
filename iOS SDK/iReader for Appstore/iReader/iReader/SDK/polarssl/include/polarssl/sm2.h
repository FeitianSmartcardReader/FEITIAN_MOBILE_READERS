#ifndef POLARSSL_SM2_H
#define POLARSSL_SM2_H

#include "ecp.h"
#include "ecdsa.h"
#include "pk.h"

namespace FT_POLARSSL {

// typedef struct
// {
//     ecp_group grp;      /*!<  elliptic curve used           */
//     mpi d;              /*!<  secret signature key          */
//     ecp_point Q;        /*!<  public signature key          */
//     mpi r;              /*!<  first integer from signature  */
//     mpi s;              /*!<  second integer from signature */
// }
// ecdsa_context;

typedef ecdsa_context sm2_context;

//typedef struct
//{
//    ecp_group grp;      /*!<  Elliptic curve and base point     */
//    mpi d;              /*!<  our secret value                  */
//    ecp_point Q;        /*!<  our public value                  */
//}
//ecp_keypair;

typedef ecp_keypair sm2_keypair;

/**
 * \brief           Initialize SM2 context
 *
 * \param ctx       Context to initialize
 */
int sm2_init( sm2_context *ctx );

/**
 * \brief           Free SM2 context
 *
 * \param ctx       Context to free
 */
void sm2_free( sm2_context *ctx );

/**
 * \brief           Generate an SM2 keypair
 *
 * \param ctx       SM2 context in which the keypair should be stroed
 *
 * \return          0 success, or an POLARSSL_ERR_ECP code.
 */
int sm2_genkey( sm2_context *ctx );

/**
 * \brief           Read SM2 public key from buffer (x, y)
 *
 * \param ctx       SM2 context
 * \param x         X
 * \param y         Y
 *
 * \return          0 success, or an POLARSSL_ERR_ECP code
 */
int sm2_pubkey_read_binary( sm2_context *ctx, const unsigned char *x,
                            const unsigned char *y );
// * \param blen      Length of buf
// * \param Q         Public key to use for verification
// * \param r         First integer of the signature
// * \param s         Second integer of the signature
// *
// * \return          0 if successful,
// *                  POLARSSL_ERR_ECP_BAD_INPUT_DATA if signature is invalid
// *                  or a POLARSSL_ERR_ECP_XXX or POLARSSL_MPI_XXX error code
// */
int sm2_verify( ecp_group *grp,
                const unsigned char *buf, size_t blen,
                const ecp_point *Q, const mpi *r, const mpi *s);


int sm2_verify( sm2_context *ctx,
                const unsigned char *hash_, size_t hlen,
                const unsigned char *r,
                const unsigned char *s );

/**
 * \brief           Verify an SM2 signature, signatrue is in buffers
 *
 * \param ctx       SM2 key pair context
 * \param hash      Message hash
 * \param hlen      Size of hash
 * \param r         First part of signature
 * \param s         Second part of signature
 *
 * \return          0 if successful,
 *                  POLARSSL_ERR_ECP_BAD_INPUT_DATA if signature is invalid,
 *                  POLARSSL_ERR_ECP_SIG_LEN_MISTMATCH if the signature is
 *                  valid but its actual length is less than siglen,
 *                  or a POLARSSL_ERR_ECP or POLARSSL_ERR_MPI error code
 */
int sm2_verify_signature( sm2_keypair *key,
                          const unsigned char *hash, size_t hlen,
                          const unsigned char *r,
                          const unsigned char *s );
/**
 * \brief           Compute SM2 signature of a previously hashed message
 *
 * \param grp       ECP group
 * \param r         First output integer
 * \param s         Second output integer
 * \param d         Private signing key
 * \param hash      Message hash
 * \param hlen      Length of buf
 * \param f_rng     RNG function, NOT used
 * \param p_rng     RNG parameter, NOT used
 *
 * \return          0 if successful,
 *                  or a POLARSSL_ERR_ECP_XXX or POLARSSL_MPI_XXX error code
 */
int sm2_sign( ecp_group *grp, mpi *r, mpi *s,
                const mpi *d, const unsigned char *hash, size_t hlen,
                int (*f_rng)(void *, unsigned char *, size_t), void *p_rng );


/**
 * \brief           Compute SM2 signature and write it to buffer,
 *
 * \param key       sm2 keypair context
 * \param hash      Message hash
 * \param hlen      Length of hash
 * \param r         Buffer that hold first part of signature
 * \param s         Buffer that hold second part of signature
 * \param f_rng     RNG function, NOT used
 * \param p_rng     RNG parameter, NOT used
 *
 * \note            r s buffer must be at least as large as the size of 32Bytes
 * \return          0 if successful,
 *                  or a POLARSSL_ERR_ECP, POLARSSL_ERR_MPI or
 *                  POLARSSL_ERR_ASN1 error code
 */
int sm2_write_signature( sm2_keypair *key,
                         const unsigned char *hash, size_t hlen,
                         unsigned char *r, unsigned char *s,
                         int (*f_rng)(void *, unsigned char *, size_t),
                         void *p_rng );

int sm2_getZ( const sm2_keypair *key, const md_info_t *md,
              const unsigned char *user_id, size_t user_id_len,
              unsigned char* output );
    
/**
 * \brief              Hash message. sign step:1 2; verify step:3 4
 *
 * \param ctx          SM2 context
 * \param md           Message digest info context.SM3 algorithm context
 * \param buf          Message to hash
 * \param buf_len      Length of message
 * \param user_id      User ID.
 * \param user_id_len  Length of user_id
 * \param output       Output buffer which lenght is equal to length of SM3 result
 *
 * \return             0 if successful, otherwish faild.
 */
int hash_msg_with_user_id( const sm2_keypair *key, const md_info_t *md,
                           const unsigned char *buf, size_t buf_len,
                           const unsigned char *user_id, size_t user_id_len,
                           unsigned char* output );

#if defined(POLARSSL_SELF_TEST)
int sm2_self_test( int );
#endif
}

#endif  /* POLARSSL_SM2_H */
