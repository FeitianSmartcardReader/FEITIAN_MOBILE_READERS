#ifndef POLARSSL_OID_ZH_CN_H
#define POLARSSL_OID_ZH_CN_H

/* GM/T 0006-2012 《密码应用标识规范》
 * www.oscca.gov.cn
 */

namespace FT_POLARSSL {

#ifndef OID_ISO_MEMBER_BODIES
#define OID_ISO_MEMBER_BODIES           "\x2a"          /* {iso(1) member-body(2)} */
#endif

/* 通用对象标志符 */
#define OID_COUNTRY_CHINA               "\x81\x1c"      /* {china(156)} */
#define OID_CHINA_OSCCA                 "\x81\x45"      /* {国家密码管理局 (197)} */
#define OID_CHINA_NCISTC                "\xcf\x55"      /* {国家密码行业标准化技术委员会 (10197) } */
#define OID_CHINA_ALG               OID_ISO_MEMBER_BODIES OID_COUNTRY_CHINA \
                                    OID_CHINA_NCISTC "\x01" /* 1.2.156.10197.1 */

/* 分组密码算法对象标识符 */
#define OID_CHINA_BLOCK_CIPHER      OID_CHINA_ALG "\x64" /* 1.2.156.10197.1.100 */
/* block cipher algorithms */
#define OID_SM1                     OID_CHINA_ALG "\x66"  /* 1.2.156.10197.1.102 */
#define OID_SSF33                   OID_CHINA_ALG "\x67"  /* 1.2.156.10197.1.103 */
#define OID_SM4                     OID_CHINA_ALG "\x68"  /* 1.2.156.10197.1.104 */

/* 公钥密码算法对象标识符 */
#define OID_CHINA_PUBLIC_ALG        OID_CHINA_ALG "\x82\x2c" /* 1.2.156.10197.1.300 */
#define OID_SM2                     OID_CHINA_ALG "\x82\x2d" /* 1.2.156.10197.1.301 */
#define OID_SM2_SIGN                OID_SM2 "\x01"            /* 1.2.156.10197.1.301.1 */
#define OID_SM2_KEY_EXCHANGE        OID_SM2 "\x02"            /* 1.2.156.10197.1.301.2 */
#define OID_SM2_ENCRYPT             OID_SM2 "\x03"            /* 1.2.156.10197.1.302.3 */

/* 杂凑算法 */
#define OID_CHINA_DIGEST_ALG        OID_CHINA_ALG "\x83\x10" /* 1.2.156.10197.1.400 */
#define OID_DIGEST_ALG_SM3          OID_CHINA_ALG "\x83\x11" /* 1.2.156.10197.1.401 */
#define OID_SM3_NULL                OID_DIGEST_ALG_SM3 "\x01" /* 1.2.156.10197.1.401.1 */
#define OID_SM3_HMAC                OID_DIGEST_ALG_SM3 "\x02" /* 1.2.156.10197.1.402.2 */

/* 组合运算算法对象标识符 */
#define OID_SM3_WITH_SM2            OID_CHINA_ALG "\x83\x75" /* 1.2.156.10197.1.501 */
#define OID_SM3_WITH_RSA            OID_CHINA_ALG "\x83\x78" /* 1.2.156.10197.1.508 */

/* 标准体系对象标识符 */
#define OID_CHINA_STD               OID_ISO_MEMBER_BODIES OID_COUNTRY_CHINA \
                                    OID_CHINA_NCISTC "\x06" /* 标准体系 1.2.156.10197.6 */
#define OID_CHINA_BASE              OID_CHINA_STD "\x01"    /* 基础类   1.2.156.10197.6.1 */

#define OID_CHINA_ALG_ID            OID_CHINA_BASE "\x01"   /* 算法类   1.2.156.10197.6.1.1*/
#define OID_SM4_ALG_ID              OID_CHINA_ALG_ID "\x02" /* 《SM4分组密码算法》 1.2.156.10197.6.1.1.2 */
#define OID_SM2_ALG_ID              OID_CHINA_ALG_ID "\x03" /* 《SM2椭圆曲线公钥密码算法》 1.2.156.10197.6.1.1.3 */
#define OID_SM3_ALG_ID              OID_CHINA_ALG_ID "\x04" /* 《SM3密码杂凑算法》 1.2.156.10197.6.1.1.4 */

/* 安全机制 */
#define OID_CHINA_MEC               OID_CHINA_BASE "\x04" /* 1.2.156.10197.6.1.4 */

/* 《SM2加密签名消息语法规范》 定义了类似P7的数据格式 */
#define OID_P7_ZH                       OID_CHINA_MEC "\x02" /* 1.2.156.10197.6.1.4.2 */
#define OID_P7_DATA_ZH                  OID_P7_ZH "\x01"     /* 1.2.156.10197.6.1.4.2.1 */
#define OID_P7_SIGNED_DATA_ZH           OID_P7_ZH "\x02"     /* 1.2.156.10197.6.1.4.2.2 */
#define OID_P7_ENVELOPED_DATA_ZH        OID_P7_ZH "\x03"     /* 1.2.156.10197.6.1.4.2.3 */
#define OID_P7_SIGNED_ENVELOPED_DATA_ZH OID_P7_ZH "\x04"     /* 1.2.156.10197.6.1.4.2.4 */
#define OID_P7_ENCRYPT_DATA_ZH          OID_P7_ZH "\x05"     /* 1.2.156.10197.6.1.4.2.5 */
#define OID_P7_KEY_EXCHANGE_ZH          OID_P7_ZH "\x06"     /* 1.2.156.10197.6.1.4.2.6 */

}

#endif  /* POLARSSL_OID_ZH_CN_H */
