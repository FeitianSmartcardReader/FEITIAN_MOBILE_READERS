/*
 * Support for bR301(Bluetooth) smart card reader
 *
 * Copyright (C) Feitian 2014, Ben <ben@ftsafe.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */


#ifndef __CRYPTO_H__
#define __CRYPTO_H__

#include "DES_C.h"
#include "aes.h"


#define MODE_ENCRYPT                1
#define MODE_DECRYPT                0


#ifdef __cplusplus
extern "C"{
#endif /* __cplusplus */

//*****************************************************************************
//															
//function		  : Universal PKCS7 padding
//name            : PKCS7_Padding
//parama		   
//	unsigned char *pbMsg:	in&out buffer
//	int nMsgLen         :	Data byte length
//  int szblk			:	Encryption block length in bytes (DES-8,AES-16)
//
//author          : 
//last edit date  : 
//last edit time  : 
//
//*****************************************************************************
extern int  PKCS7_Padding(unsigned char *pbMsg, int nMsgLen, int szblk);

//*****************************************************************************
//															
//function			  : Detect compliance PKCS#7 padding
//name                : PKCS7_Padding_Check
//parama		   
//	unsigned char *pbMsg:	in&out buffer
//	int nMsgLen         :	Data byte length
//  int szblk			:	Encryption block length in bytes (DES-8,AES-16)
//
//author          : 
//last edit date  : 
//last edit time  : 
//
//*****************************************************************************
extern int  PKCS7_Padding_Check(unsigned char *pbMsg, int nMsgLen, int szblk);

//*****************************************************************************
//															
//function		  : TDES ECB Operation Mode and PKCS#7 padding
//name            : TDES_ECB_PKCS7
//parama		   
//	unsigned char *inBlk:	in buffer
//	int len				:	data byte length
//  unsigned char *outBlk: out buffer
//	unsigned int *outLen: data byte length
//	unsigned char *key: key
//	int keyLen          : key length (16,24,32)
//	int mode			: encryption and decryption mode (MODE_ENCRYPT/MODE_DECRYPT)
//
//author          : 
//last edit date  : 
//last edit time  : 
//
//*****************************************************************************
extern int 	TDES_ECB_PKCS7(unsigned char *inBuf, unsigned int inLen, unsigned char *outBuf, unsigned  int *outLen, unsigned char *key, unsigned int keyLen, int mode);

//*****************************************************************************
//															
//function        : AES ECB Operation Mode and PKCS#7 padding
//name            : AES_ECB_PKCS7
//parama		   
//	unsigned char *inBlk:	in buffer
//	int len				:	data byte length
//  unsigned char *outBlk: out buffer
//	unsigned int *outLen: data byte length
//	unsigned char *key  : key
//	int keyLen          : key length (16,24,32)
//	int mode			: encryption and decryption mode (MODE_ENCRYPT/MODE_DECRYPT)
//
//author          : 
//last edit date  : 
//last edit time  : 
//
//*****************************************************************************
extern int  AES_ECB_PKCS7(unsigned char *inBuf, unsigned int inLen, unsigned char *outBuf, unsigned  int *outLen, unsigned char *key, unsigned int keyLen, int mode);


extern void TDES(unsigned char * inBlk, unsigned char * outBlk,  unsigned char *key, int keyLen,  int mode);

//*****************************************************************************
//															
//function         : TDES ECB Operation Mode
//name             : TDES_ECB
//parama		   
//	unsigned char *inBlk:	in buffer
//	int len				:	data byte length
//  unsigned char *outBlk: out buffer
//	unsigned char *key  : key
//	int keyLen          : key length (16,24,32)
//	int mode			: encryption and decryption mode (MODE_ENCRYPT/MODE_DECRYPT)
//
//author          : 
//last edit date  : 
//last edit time  : 
//
//*****************************************************************************
extern void TDES_ECB(unsigned char *inBlk, int len, unsigned char *outBlk,  unsigned char *key, int keyLen, int mode);

//*****************************************************************************
//															
//function		  : AES ECB Operation Mode
//name            : AES_ECB
//parama		   
//	unsigned char *inBlk:	in buffer
//	int len				:	data byte length
//  unsigned char *outBlk: out buffer
//	unsigned char *key  : key
//	int keyLen          : key length (16,24,32)
//	int mode			: encryption and decryption mode (MODE_ENCRYPT/MODE_DECRYPT)
//
//author          : 
//last edit date  : 
//last edit time  : 
//
//*****************************************************************************
extern void AES_ECB(unsigned char *inBlk, int len, unsigned char *outBlk,  unsigned char *key, int keyLen, int mode);

#ifdef __cplusplus
}
#endif /* __cplusplus */


#endif /* __CRYPTO_H__ */

