#ifndef __FT_DUPTK_H__
#define __FT_DUPTK_H__

typedef unsigned char uint8_t; 
typedef unsigned int uint32_t; 
typedef uint8_t BYTE; 
typedef unsigned long ULONG; 
#define TRUE 1
#define FALSE 0


#define DUPTK_OK   0x00000000
#define DUPTK_ERR  0x80000000
#define DUPTK_PARAMETER_INVILD    0x80000001

//set enc mode

//bEncrypt	 1 encmode  0 noenc
#define ENCMODE   0x01
#define NOENC     0x00
//bEncFunc   1 3des_ecb  0 aes_ecb
#define TDES_ECB_FUNC   0x01
#define AES_ECB_FUNC    0x00
//bEncType 	 1 SINGLE_ENC(明文进 密文出)  0  DOUBLE_ENC (明文进 明文出) 
#define SINGLE_ENC    0x01
#define DOUBLE_ENC    0x00


#ifdef __cplusplus
extern "C"
{
#endif

void ft_derive_IPEK(BYTE *bdk, BYTE *ksn, BYTE *ipek);






//ULONG FtDukptInit(SCARDHANDLE hCard,unsigned char *encBuf,unsigned int nLen);
ULONG FtDukptSetEncMod(SCARDHANDLE hCard,/*unsigned int bEncrypt,unsigned int bEncFunc,*/unsigned int bEncType);
ULONG FtDukptGetKSN(SCARDHANDLE hCard, unsigned int * pnlength,unsigned char *buffer);
ULONG FtDukptWriteIPEK(SCARDHANDLE hCard,unsigned char *encBuf,unsigned int nLen);
ULONG FtDukptWriteKSN(SCARDHANDLE hCard,unsigned char *ksnBuf,unsigned int nLen);
void FtDECRYPT(BYTE *ipek, BYTE *ksn, BYTE *cryptogram, BYTE *out, uint32_t *cryptlen);
void FtENCRYPT(BYTE *ipek, BYTE *ksn, BYTE *cryptogram, BYTE *out, uint32_t *cryptlen);

#ifdef __cplusplus
}
#endif

#endif