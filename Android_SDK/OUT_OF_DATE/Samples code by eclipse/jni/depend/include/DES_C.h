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

#ifndef __DES_C_H__
#define __DES_C_H__

#define BOOL int
#define true 1
#define false 0
#define DES_ENCRYPT	1
#define DES_DECRYPT	0
// The following ifdef block is the standard way of creating macros which make exporting 
// from a DLL simpler. All files within this DLL are compiled with the DES_C_EXPORTS
// symbol defined on the command line. this symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see 
// DES_C_API functions as being imported from a DLL, wheras this DLL sees symbols
// defined with this macro as being exported.


//*****************************************************************************
//															parama length(BYTEs)
//function		  : Triple Des encrypt
//name            : DES_C_DDES
//parama		   
//	key		      : the input key                           8 or 16 
//	data		  : the input data block   					8 
//	encrypt	      : encrypt or decrypt flag  				true:  encrypt;
//															false: decrypt 
//author          : xiao wei
//last edit date  : 2003.4.11 
//last edit time  : 15:14
//*****************************************************************************
void DES_C_DDES(
    unsigned char *key,
	unsigned char *data,
	BOOL encrypt
);

//*****************************************************************************
//															parama length(BYTEs)
//function		  : Des encrypt
//name            : DES_C_DES
//parama		   
//	key		      : the input key                           8 
//	data		  : the input data block   					8 
//	doEncrypt	  : encrypt or decrypt flag  				0:encrypt;
//															1:decrypt 
//author          : xiao wei
//last edit date  : 2003.4.11 
//last edit time  : 15:14
//*****************************************************************************
void DES_C_DES(
    unsigned char *key,
	unsigned char *data,
	BOOL doEncrypt
);


//void pbocdes( unsigned char *key, unsigned char *data, int len, OUT unsigned char *mac );
void pboc3des( unsigned char *key, unsigned char *data, int len );
void pbocdes( unsigned char *key, unsigned char *data, int len );
#endif
