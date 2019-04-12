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

#ifndef __AES_H__
#define __AES_H__


#define AES_BLOCK_SIZE              16
#define AES_KEY_SIZE_128            16
#define AES_KEY_SIZE_192            24
#define AES_KEY_SIZE_256            32

#define MODE_ENCRYPT                1
#define MODE_DECRYPT                0

typedef struct st_aes_cfb_context
{
    unsigned char    inter_in[AES_BLOCK_SIZE+1];
    unsigned char    inter_out[AES_BLOCK_SIZE+1];
    int   szBlock;
    int   k;
} AES_CFB_CONTEXT, AES_CFB_CTX;

typedef struct st_aes_ofb_context
{
    unsigned char    interBlk[AES_BLOCK_SIZE];
    int   szBlock;
} AES_OFB_CONTEXT, AES_OFB_CTX;


typedef struct st_aes_ctr_context
{
    unsigned char    interBlk[AES_BLOCK_SIZE];
    int   szBlock;
} AES_CTR_CONTEXT, AES_CTR_CTX;


#ifdef  __cplusplus
extern "C"{
#endif
    
/*****************************************************************************
 Prototype    : AES_encrypt
 Description  : AES encryption
 Param        : unsigned char* plaintext   [in ] the password in plain text£¨buffer size is 16 bytes
 Param        : unsigned char* ciphertext  [out] Password ciphertext output£¨buffer size is 16 bytes
 Param        : unsigned char* key         [in ] key £¨buffer size is keyLen bytes
 Param        : int szKey                  [in ] size of key,16/24/32
 Return Value : none
 *****************************************************************************/
extern void Ft_iR301U_AES_encrypt( unsigned char * plaintext, unsigned char * ciphertext, unsigned char * key, int szKey);

/*****************************************************************************
 Prototype    : AES_decrypt
 Description  : AES decryption
 Param        : unsigned char* plaintext   [in ] the password in plain text£¨buffer size is 16 bytes
 Param        : unsigned char* ciphertext  [out] Password ciphertext output£¨buffer size is 16 bytes
 Param        : unsigned char* key         [in ] key £¨buffer size is keyLen bytes
 Param        : int szKey                  [in ] size of key,16/24/32
 Return Value : none
 *****************************************************************************/
extern void Ft_iR301U_AES_decrypt( unsigned char * ciphertext, unsigned char * plaintext, unsigned char * key, int szKey);


#ifdef  __cplusplus
}
#endif


#endif
