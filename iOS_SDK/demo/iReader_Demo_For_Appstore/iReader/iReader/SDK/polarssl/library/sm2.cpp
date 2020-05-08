/*
 * Reference:
 *
 * http://www.oscca.gov.cn/UpFile/2010122214822692.pdf
 */
#if !defined(POLARSSL_CONFIG_FILE)
#include "polarssl/config.h"
#else
#include POLARSSL_CONFIG_FILE
#endif

#if defined(POLARSSL_ECP_SM2_ENABLED)
#define POLARSSL_SM2_C
#endif

#if defined(POLARSSL_SM2_C)

#include <string.h>
#include "polarssl/sm2.h"
#include "polarssl/pk.h"
#include "polarssl/md.h"
#include "polarssl/entropy.h"
#include "polarssl/ctr_drbg.h"

#if defined (POLARSSL_PLATFORM_C)
#include "polarssl/platform.h"
#else
#define polarssl_printf    printf
#define polarssl_malloc    malloc
#define polarssl_free      free
#endif

namespace FT_POLARSSL {

int sm2_pubkey_read_binary( sm2_context *ctx, const unsigned char *x,
                            const unsigned char *y )
{
    int ret;

    if( ctx == NULL || x == NULL || y == NULL )
        return( POLARSSL_ERR_ECP_BAD_INPUT_DATA );

    if( ctx->grp.id != POLARSSL_ECP_SM2 )
        return( POLARSSL_ERR_ECP_INVALID_KEY );

    MPI_CHK( mpi_read_binary( &ctx->Q.X, x, 32 ) );
    MPI_CHK( mpi_read_binary( &ctx->Q.Y, y, 32 ) );
    MPI_CHK( mpi_lset( &ctx->Q.Z, 1) );

    ret = ecp_check_pubkey( &ctx->grp, &ctx->Q );
cleanup:
    return( ret );
}

/*
 * Verify SM2 signature of hashed message ()
 */
int sm2_verify_core( ecp_group *grp,
                const unsigned char *buf, size_t blen,
                const ecp_point *Q, const mpi *r, const mpi *s)
{
    int ret;
    mpi e, t;
    ecp_point R, P;

    ecp_point_init( &R ); ecp_point_init( &P );
    mpi_init( &e ); mpi_init( &t );

    if( grp->id != POLARSSL_ECP_SM2 )
        return( POLARSSL_ERR_ECP_INVALID_KEY );

    /*
     * Step 1 2: make sure r and s are in range 1..n-1
     */
    if( mpi_cmp_int( r, 1 ) < 0 || mpi_cmp_mpi( r, &grp->N ) >= 0 ||
        mpi_cmp_int( s, 1 ) < 0 || mpi_cmp_mpi( s, &grp->N ) >= 0 )
    {
        ret = POLARSSL_ERR_ECP_VERIFY_FAILED;
        goto cleanup;
    }

    /*
     * Additional precaution: make sure Q is valid
     */
    MPI_CHK( ecp_check_pubkey( grp, Q ) );

    /*
     * Step 4: derive MPI from hashed message
     * Only SM3?
     */
    MPI_CHK( mpi_read_binary( &e, buf, blen ) );

    /*
     * Step 5: t = (r + s)mod n
     */
    MPI_CHK( mpi_add_mpi( &t, r, s) );
    MPI_CHK( mpi_mod_mpi( &t, &t, &grp->N ) );

    /* t = 0 ? */
    if( mpi_cmp_int( &t, 0 ) == 0 )
    {
        ret = POLARSSL_ERR_ECP_VERIFY_FAILED;
        goto cleanup;
    }

    /*
     * Setp 6: P = s G + t Pa
     */
    MPI_CHK( ecp_mul( grp, &R, s, &grp->G, NULL, NULL ) );
    MPI_CHK( ecp_mul( grp, &P, &t, Q, NULL, NULL ) );
    MPI_CHK( ecp_add( grp, &P, &R, &P ) );

    if( ecp_is_zero( &P ) )
    {
        ret = POLARSSL_ERR_ECP_VERIFY_FAILED;
        goto cleanup;
    }

    /*
     * Set 7: R = (e + x1)mod n
     * x1 = P.x;
     */
    MPI_CHK( mpi_add_mpi( &R.X, &e, &P.X ) );
    MPI_CHK( mpi_mod_mpi( &R.X, &R.X, &grp->N ) );

    /*
     * check if R (that is, R.X) is equal to r
     */
    if( mpi_cmp_mpi( &R.X, r ) != 0 )
    {
        ret = POLARSSL_ERR_ECP_VERIFY_FAILED;
        goto cleanup;
    }

cleanup:
    ecp_point_free( &R ); ecp_point_free( &P );
    mpi_free( &e ); mpi_free( &t );

    return( ret );
}
int sm2_verify( sm2_context *ctx,
                const unsigned char *hash_, size_t hlen,
                const unsigned char *r,
                const unsigned char *s )
{
    int ret;
    mpi R, S;
    mpi_init( &R ); mpi_init( &S );
    if( ctx->grp.id != POLARSSL_ECP_SM2 )
    {
        return( POLARSSL_ERR_ECP_INVALID_KEY );
    }

    MPI_CHK( mpi_read_binary( &R, r, 32) );
    MPI_CHK( mpi_read_binary( &S, s, 32) );

    ret = sm2_verify_core( &ctx->grp, hash_, hlen,
                      &ctx->Q, &R, &S );
cleanup:
    mpi_free( &R ); mpi_free( &S );
    return( ret );
}


int sm2_init( sm2_context *ctx )
{
    ecdsa_init( ctx );

    return( ecp_use_known_dp( &ctx->grp, POLARSSL_ECP_SM2 ) );
}

void sm2_free( sm2_context *ctx )
{
    ecdsa_free( ctx );
}

int sm2_gen_keypair( ecp_group *grp, mpi *d, ecp_point *P )
{
    int ret, key_tries;
    mpi n;
    unsigned char rnd[POLARSSL_ECP_MAX_BYTES];
    size_t n_size = ( grp->nbits + 7 ) / 8;
    entropy_context entropy;
    ctr_drbg_context drbg;
    unsigned char pers[] = "sm2_gen_keypair";

    ret = 0;
    mpi_init( &n );

    MPI_CHK( mpi_sub_int( &n, &grp->N, 2 ) );

    /* prepare random */
    entropy_init( &entropy );

    if( ( ret = ctr_drbg_init( &drbg, entropy_func, &entropy, pers, sizeof(pers)) ) != 0 )
    {
        ret = POLARSSL_ERR_ECP_RANDOM_FAILED;
        goto cleanup;
    }

    ctr_drbg_set_prediction_resistance( &drbg, CTR_DRBG_PR_ON);

    /* generate d: 1 <= d <= N-2 */
    key_tries = 0;
    do
    {
        if( ++key_tries > 30 )
        {
            ret = POLARSSL_ERR_ECP_RANDOM_FAILED;
            break;
        }
        
        MPI_CHK( ctr_drbg_random( &drbg, rnd, n_size ) );
        MPI_CHK( mpi_read_binary( d, rnd, n_size ) );

        /* k = 6CB28D99385C175C94F94E934817663FC176D925DD72B727260DBAAE1FB2F96F
         * for test
         */
        /* MPI_CHK( mpi_read_string( d, 16, "6CB28D99385C175C94F94E934817663FC176D925DD72B727260DBAAE1FB2F96F")); */
    }while( mpi_cmp_int( d, 1 ) < 0 ||
            mpi_cmp_mpi( d, &n ) > 0 );

    if( ret != 0 )
        goto cleanup;

    ret = ecp_mul( grp, P, d, &grp->G, NULL, NULL );

cleanup:
    mpi_free( &n );
    ctr_drbg_free( &drbg ) ;
    entropy_free( &entropy );
    return( ret );
}

int sm2_genkey( sm2_context *ctx )
{
    return ( sm2_gen_keypair( &ctx->grp, &ctx->d, &ctx->Q ) );
}

/*
 * Verify SM2 signature of hashed message ()
 */
int sm2_verify( ecp_group *grp,
                const unsigned char *buf, size_t blen,
                const ecp_point *Q, const mpi *r, const mpi *s)
{
    int ret;
    mpi e, t;
    ecp_point R, P;

    ecp_point_init( &R ); ecp_point_init( &P );
    mpi_init( &e ); mpi_init( &t );

    if( grp->id != POLARSSL_ECP_SM2 )
        return( POLARSSL_ERR_PK_INVALID_ALG );

    /*
     * Step 1 2: make sure r and s are in range 1..n-1
     */
    if( mpi_cmp_int( r, 1 ) < 0 || mpi_cmp_mpi( r, &grp->N ) >= 0 ||
        mpi_cmp_int( s, 1 ) < 0 || mpi_cmp_mpi( s, &grp->N ) >= 0 )
    {
        ret = POLARSSL_ERR_ECP_VERIFY_FAILED;
        goto cleanup;
    }

    /*
     * Additional precaution: make sure Q is valid
     */
    MPI_CHK( ecp_check_pubkey( grp, Q ) );

    /*
     * Step 4: derive MPI from hashed message
     * Only SM3?
     */
    MPI_CHK( mpi_read_binary( &e, buf, blen ) );

    /*
     * Step 5: t = (r + s)mod n
     */
    MPI_CHK( mpi_add_mpi( &t, r, s) );
    MPI_CHK( mpi_mod_mpi( &t, &t, &grp->N ) );

    /* t = 0 ? */
    if( mpi_cmp_int( &t, 0 ) == 0 )
    {
        ret = POLARSSL_ERR_ECP_VERIFY_FAILED;
        goto cleanup;
    }

    /*
     * Setp 6: P = s G + t Pa
     */
    MPI_CHK( ecp_mul( grp, &R, s, &grp->G, NULL, NULL ) );
    MPI_CHK( ecp_mul( grp, &P, &t, Q, NULL, NULL ) );
    MPI_CHK( ecp_add( grp, &P, &R, &P ) );

    if( ecp_is_zero( &P ) )
    {
        ret = POLARSSL_ERR_ECP_VERIFY_FAILED;
        goto cleanup;
    }

    /*
     * Set 7: R = (e + x1)mod n
     * x1 = P.x;
     */
    MPI_CHK( mpi_add_mpi( &R.X, &e, &P.X ) );
    MPI_CHK( mpi_mod_mpi( &R.X, &R.X, &grp->N ) );

    /*
     * check if R (that is, R.X) is equal to r
     */
    if( mpi_cmp_mpi( &R.X, r ) != 0 )
    {
        ret = POLARSSL_ERR_ECP_VERIFY_FAILED;
        goto cleanup;
    }

cleanup:
    ecp_point_free( &R ); ecp_point_free( &P );
    mpi_free( &e ); mpi_free( &t );

    return( ret );
}

int sm2_verify_signature( sm2_keypair *key,
                          const unsigned char *hash, size_t hlen,
                          const unsigned char *r,
                          const unsigned char *s )
{
    int ret;
    mpi R, S;
    mpi_init( &R ); mpi_init( &S );
    if( key->grp.id != POLARSSL_ECP_SM2 )
    {
        return( POLARSSL_ERR_PK_INVALID_ALG );
    }

    MPI_CHK( mpi_read_binary( &R, r, 32) );
    MPI_CHK( mpi_read_binary( &S, s, 32) );

    ret = sm2_verify( &key->grp, hash, hlen,
                      &key->Q, &R, &S );
cleanup:
    mpi_free( &R ); mpi_free( &S );
    return( ret );
}

int sm2_sign( ecp_group *grp, mpi *r, mpi *s,
              const mpi *d, const unsigned char *hash, size_t hlen,
              int (*f_rng)(void *, unsigned char *, size_t), void *p_rng )
{
    int ret, key_tries, sign_tries;
    mpi k, e, t;
    ecp_point P;

    ((void) f_rng);
    ((void) p_rng);

    if( hash == NULL || hlen == 0 )
    {
        return( POLARSSL_ERR_ECP_BAD_INPUT_DATA );
    }

    mpi_init( &k ); mpi_init( &e ); mpi_init( &t );

    ecp_point_init( &P );

    MPI_CHK( mpi_read_binary( &e, hash, hlen ) );

    sign_tries = 0;
    do
    {
        if( sign_tries++ > 10 )
        {
            ret = POLARSSL_ERR_ECP_RANDOM_FAILED;
            goto cleanup;
        }
        
        key_tries = 0;
        do
        {
            if( key_tries++ > 10 )
            {
                ret = POLARSSL_ERR_ECP_RANDOM_FAILED;
                goto cleanup;
            }

            /* 1 <= k <= n-1, but use gen_keypair 1 <= k <= n-2 ^_^ */
            MPI_CHK( sm2_gen_keypair( grp,  &k, &P) );

            mpi_lset( &t, 0 );
            /* r =  (e + x1)/mod n*/
            MPI_CHK( mpi_add_mpi( r, &e, &P.X ) );
            MPI_CHK( mpi_mod_mpi( r, r, &grp->N ) );
            MPI_CHK( mpi_add_mpi( &t, &k, r ) );

        }while( mpi_cmp_int( r, 0 ) == 0 ||
                mpi_cmp_mpi( &t, &grp->N ) == 0 );

        /* s = ((1 + dA)^−1 · (k − r · dA)) modn */

        /* s = 1 + dA */
        MPI_CHK( mpi_add_int( s, d, 1) );
        /* s = s^-1 mod n */
        MPI_CHK( mpi_inv_mod( s, s, &grp->N ) );

        /* t = r*dA */
        MPI_CHK( mpi_mul_mpi( &t, r, d ) );
        /* t = k - t */
        MPI_CHK( mpi_sub_mpi( &t, &k, &t) );
        /* t = t mod n */
        MPI_CHK( mpi_mod_mpi( &t, &t, &grp->N ) );

        MPI_CHK( mpi_mul_mpi( s, s, &t ) );
        MPI_CHK( mpi_mod_mpi( s, s, &grp->N ) );
    }
    while( mpi_cmp_int( s, 0 ) == 0 );

cleanup:
    mpi_free( &k ); mpi_free( &e ); mpi_free( &t );
    ecp_point_free( &P );
    return( ret );
}


int sm2_write_signature( sm2_keypair *key,
                         const unsigned char *hash, size_t hlen,
                         unsigned char *r, unsigned char *s,
                         int (*f_rng)(void *, unsigned char *, size_t),
                         void *p_rng )
{
    int ret;
    mpi R, S;
    mpi_init( &R ); mpi_init( &S );

    if( ( ret = sm2_sign( &key->grp, &R, &S,
                          &key->d, hash, hlen,
                          f_rng, p_rng ) ) != 0 )
    {
        goto cleanup;
    }

    MPI_CHK( mpi_write_binary( &R, r, 32 ) );
    MPI_CHK( mpi_write_binary( &S, s, 32 ) );

cleanup:
    mpi_free( &R ); mpi_free( &S );
    return( ret );
}
    
int sm2_getZ( const sm2_keypair *key, const md_info_t *md,
              const unsigned char *user_id, size_t user_id_len,
              unsigned char* output )
{
    int ret = 0;
    unsigned char entl[2];
    unsigned char M[POLARSSL_MD_MAX_SIZE];
    md_context_t md_ctx;
    size_t m_len;
    
    if( md == NULL )
    {
        return( POLARSSL_ERR_MD_FEATURE_UNAVAILABLE );
    }
    
    if( md_get_type( md ) != POLARSSL_MD_SM3 )
    {
        return( POLARSSL_ERR_MD_FEATURE_UNAVAILABLE );
    }
    
    md_init( &md_ctx );
    if( ( ret = md_init_ctx( &md_ctx, md ) ) != 0)
    {
        goto cleanup;
    }
    
    ret = 0;
    
    md_starts( &md_ctx );
    
    /* ENTLa */
    /* bits length */
    entl[0] = ( (user_id_len*8) >> 8)&0xff;
    entl[1] = (user_id_len*8) & 0xff;
    md_update( &md_ctx, entl, sizeof( entl ) );
    
    /* user_id */
    md_update( &md_ctx, user_id, user_id_len );
    
    m_len = (key->grp.nbits + 7)/8;
    
    /* a */
    MPI_CHK( mpi_write_binary( &key->grp.A, M, m_len ) );
    md_update( &md_ctx, M, m_len );
    
    /* b */
    MPI_CHK( mpi_write_binary( &key->grp.B, M, m_len ) );
    md_update( &md_ctx, M, m_len );
    
    /* Gx */
    MPI_CHK( mpi_write_binary( &key->grp.G.X, M, m_len ) );
    md_update( &md_ctx, M, m_len );
    
    /* Gy */
    MPI_CHK( mpi_write_binary( &key->grp.G.Y, M, m_len ) );
    md_update( &md_ctx, M, m_len );
    
    /* Ax */
    MPI_CHK( mpi_write_binary( &key->Q.X, M, m_len ) );
    md_update( &md_ctx, M, m_len );
    
    /* Ay */
    MPI_CHK( mpi_write_binary( &key->Q.Y, M, m_len ) );
    md_update( &md_ctx, M, m_len );
    
    md_finish( &md_ctx, output );
    
cleanup:
    md_free( &md_ctx );
    return( ret );
}

int hash_msg_with_user_id( const sm2_keypair *key, const md_info_t *md,
                           const unsigned char *buf, size_t buf_len,
                           const unsigned char *user_id, size_t user_id_len,
                           unsigned char* output )
{
    md_context_t md_ctx;

    int ret;

    if( key->grp.id != POLARSSL_ECP_SM2 )
    {
        return( POLARSSL_ERR_PK_INVALID_ALG );
    }

    if( md == NULL )
    {
        return( POLARSSL_ERR_MD_FEATURE_UNAVAILABLE );
    }
    if( md_get_type( md ) != POLARSSL_MD_SM3 )
    {
        return( POLARSSL_ERR_MD_FEATURE_UNAVAILABLE );
    }

    if( user_id_len*8 > 0xffff || user_id_len < 1 )
    {
        return( POLARSSL_ERR_MD_BAD_INPUT_DATA );
    }

    /*
     * h = H(Za||M)
     * Za = (ENTLa || user_id || a || b || Gx || Gy || Ax || Ay)
     *
     */

    md_init( &md_ctx );
    if( ( ret = md_init_ctx( &md_ctx, md ) ) != 0)
    {
        goto cleanup;
    }

    ret = 0;

    sm2_getZ(key, md, user_id, user_id_len, output);

    md_starts( &md_ctx );
    md_update( &md_ctx, output, md_get_size( md ) );
    md_update( &md_ctx, buf, buf_len );
    md_finish( &md_ctx, output );

cleanup:
    md_free( &md_ctx );
    return( ret );
}

#if defined(POLARSSL_SELF_TEST)
int sm2_self_test( int verbose )
{
    int ret ;
    char *exponents[] =
    {
        (char*)"8542D69E4C044F18E8B92435BF6FF7DE457283915C45517D722EDB8B08F1DFC3", /* p */
        (char*)"787968B4FA32C3FD2417842E73BBFEFF2F3C848B6831D7E0EC65228B3937E498", /* a */
        (char*)"63E4C6D3B23B0C849CF84241484BFE48F61D59A5B16BA06E6E12D1DA27C5249A", /* b */
        (char*)"421DEBD61B62EAB6746434EBC3CC315E32220B3BADD50BDC4C4E6C147FEDD43D", /* gx */
        (char*)"0680512BCBB42C07D47349D2153B70C4E5D7FDFCBFA36EA1A85841B9E46E09A2", /* gy */
        (char*)"8542D69E4C044F18E8B92435BF6FF7DD297720630485628D5AE74EE7C32E79B7", /* n */
        (char*)"128B2FA8BD433C6C068C8D803DFF79792A519A55171B1B650C23661D15897263", /* d */
        (char*)"0AE4C7798AA0F119471BEE11825BE46202BB79E2A5844495E97C04FF4DF2548A", /* px */
        (char*)"7C0240F88F1CD4E16352A73C17B7F16F07353E53A176D684A9FE0C6BB798E857", /* py */
        //"B524F552CD82B8B028476E005C377FB19A87E6FC682D48BB5D42E3D9B9EFFE76", /* e */
        //"6CB28D99385C175C94F94E934817663FC176D925DD72B727260DBAAE1FB2F96F", /* k */
        //"40F1EC59F793D9F49E09DCEF49130D4194F79FB1EED2CAA55BACDB49C4E755D1", /* r */
        //"6FC6DAC32C5D5CF10C77DFB20F7C2EB667A457872FB09EC56327A67EC7DEEBE7", /* s */
    };
    unsigned char result[][32] =
        {
            /* e */
            {
                0xB5, 0x24, 0xF5, 0x52, 0xCD, 0x82, 0xB8, 0xB0,
                0x28, 0x47, 0x6E, 0x00, 0x5C, 0x37, 0x7F, 0xB1,
                0x9A, 0x87, 0xE6, 0xFC, 0x68, 0x2D, 0x48, 0xBB,
                0x5D, 0x42, 0xE3, 0xD9, 0xB9, 0xEF, 0xFE, 0x76,
            },
            /* r */
            {
                0x40, 0xF1, 0xEC, 0x59, 0xF7, 0x93, 0xD9, 0xF4,
                0x9E, 0x09, 0xDC, 0xEF, 0x49, 0x13, 0x0D, 0x41,
                0x94, 0xF7, 0x9F, 0xB1, 0xEE, 0xD2, 0xCA, 0xA5,
                0x5B, 0xAC, 0xDB, 0x49, 0xC4, 0xE7, 0x55, 0xD1,
            },
            /* s */
            {
                0x6F, 0xC6, 0xDA, 0xC3, 0x2C, 0x5D, 0x5C, 0xF1,
                0x0C, 0x77, 0xDF, 0xB2, 0x0F, 0x7C, 0x2E, 0xB6,
                0x67, 0xA4, 0x57, 0x87, 0x2F, 0xB0, 0x9E, 0xC5,
                0x63, 0x27, 0xA6, 0x7E, 0xC7, 0xDE, 0xEB, 0xE7,
            },
        };
    char *p = *exponents;
    unsigned char *b = *result;
    unsigned char user_id[] = "ALICE123@YAHOO.COM";
    unsigned char msg[] = "message digest";
    unsigned char output[32], r[32], s[32];
    size_t user_id_len = sizeof( user_id ) - 1;
    size_t msg_len = sizeof( msg ) - 1;
    sm2_context ctx;

    //do not use sm2_init.
    ecdsa_init( &ctx );

    mpi_read_string( &ctx.grp.P, 16, p );
    p += 65;
    mpi_read_string( &ctx.grp.A, 16, p );
    p += 65;
    mpi_read_string( &ctx.grp.B, 16, p );
    p += 65;
    mpi_read_string( &ctx.grp.G.X, 16, p );
    p += 65;
    mpi_read_string( &ctx.grp.G.Y, 16, p );
    p += 65;
    mpi_read_string( &ctx.grp.N, 16, p );
    p += 65;
    mpi_read_string( &ctx.d, 16, p );
    p += 65;
    mpi_read_string( &ctx.Q.X, 16, p );
    p += 65;
    mpi_read_string( &ctx.Q.Y, 16, p );
    ctx.grp.nbits = mpi_msb( &ctx.grp.N );
    ctx.grp.pbits = mpi_msb( &ctx.grp.P );
    ctx.grp.id = POLARSSL_ECP_SM2;
    ctx.grp.h = 0;
    mpi_lset(&ctx.grp.G.Z, 1);
    ret = hash_msg_with_user_id( (sm2_keypair *) &ctx,
                                 md_info_from_type( POLARSSL_MD_SM3),
                                 msg, msg_len,
                                 user_id, user_id_len,
                                 output);

    polarssl_printf( "compute e: \n" );
    if( ret !=  0 )
    {
        polarssl_printf( "compute failed \n" );
        goto cleanup;
    }

    if( memcmp( output, b, 32 ) == 0 )
    {
        polarssl_printf( "compute e pass\n");
    }
    else
    {
        polarssl_printf( "compute e not passed\n");
        ret = 1;
        goto cleanup;
    }

    polarssl_printf( " sm2 sign operation\n" );
    ret = sm2_write_signature( (sm2_keypair *) &ctx, output, 32, r, s, NULL, NULL );

    if( ret != 0 )
    {
        polarssl_printf( "sm2 sign operation failed\n");
        goto cleanup;
    }

    b += 32;
    if( memcmp( r, b, 32 ) != 0 || memcmp( s, b + 32, 32 ) != 0 )
    {
        polarssl_printf( "sm2 sign operation not passed\n ");
        ret = 1;
    }
    else
    {
        polarssl_printf( "sm2 sign operation passed\n");
    }
cleanup:
    sm2_free( &ctx );
    return( ret );
}
#endif  /* POLARSSL_SELF_TEST */
}

#endif  /* POLARSSL_SM2_C */
