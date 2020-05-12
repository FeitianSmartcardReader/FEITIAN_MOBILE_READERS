#ifndef POLARSSL_PKCS7_SM2_CONFIG_H
#define POLARSSL_PKCS7_SM2_CONFIG_H

#if !defined(POLARSSL_CONFIG_FILE)
#include "config.h"
using namespace FT_POLARSSL;
#else
#include POLARSSL_CONFIG_FILE
#endif

namespace FT_POLARSSL {

#if defined(ABC_BANK_PKCS7)

/* SM2 签名值设置 */
/* 农行的格式 */
/*
 * encryptDigest ::= SEQUENCE{
 *  r INTEGER
 *  s INTEGER
 * }
 */
#define SIGNER_INFO_SM2_SIG_USE_SEQUENCE
#endif

/* 正常的格式 */
/*
 * encryptDigest ::= OCTET STRING
 * 在 OCTET STRING 里是 SEQUENCE {
 *      r INTEGER
 *      s INTEGER
 *   }
 */

/* 签名原文设置 */
#if defined(BOC_BANK_PKCS7)
/* 中行的p7必须是在DATA的ID之后没有数据 */
#define DATA_CONTENT_END_AFTER_IDENTIFIER
#endif

}

#endif  /* POLARSSL_PKCS7_SM2_CONFIG_H */
