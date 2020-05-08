#ifndef __Tiny_midware__src__des_h__
#define __Tiny_midware__src__des_h__

namespace FT_DES {

int pad80(unsigned char *DataIn,
          int           *iDataLen);

int TripleDesEnc(unsigned char       *outdata,
                 const unsigned char *inData,
                 const int           datalen,
                 const unsigned char *key);

int TripleDesDec(unsigned char       *outdata,
                 const unsigned char *inData,
                 const int           datalen,
                 const unsigned char *key);

void DesEnc(unsigned char       *outdata,
           const unsigned char *inData,
           const int           datalen,
           const unsigned char *key);

void DesDec(unsigned char       *outdata,
           const unsigned char *inData,
           const int           datalen,
           const unsigned char *key);

bool mac_des(const unsigned char *byKey,
             const unsigned char *initvalue,
             const unsigned char *dataIn,
             unsigned char       *MAC,
             int                 byLen);

bool mac_3des(const unsigned char *byKey,
              const unsigned char *initvalue,
              const unsigned char *dataIn,
              unsigned char       *MAC,
              int                 byLen);

}

#endif /* defined(__Tiny_midware__src__des_h__) */
