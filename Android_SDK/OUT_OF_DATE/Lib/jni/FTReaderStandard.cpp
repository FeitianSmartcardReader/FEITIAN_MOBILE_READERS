#include <jni.h>
#include <android/log.h>
#include "ft_pcsc.h"
#include <stdio.h>
#include "ft_tools.h"
#include "ft_dukpt.h"
#include "crypto.h"
#include <string.h>
#include "com_example_ftReaderStandard_Tpcsc.h"




#define LOG		"libFTReaderStandard"
#define LOGV(...) __android_log_print(ANDROID_LOG_VERBOSE, LOG, __VA_ARGS__)
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG , LOG, __VA_ARGS__)
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO  , LOG, __VA_ARGS__)
#define LOGW(...) __android_log_print(ANDROID_LOG_WARN  , LOG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR  , LOG, __VA_ARGS__)

#define printLog(...)	LOGD(__VA_ARGS__);
#define dprintf	printLog
#define printf printLog

SCARDCONTEXT g_hContext;
char readerList[10][100];
SCARDHANDLE g_hCard;


JNIEXPORT void JNICALL Java_com_example_ftReaderStandard_Tpcsc_init
  (JNIEnv *env, jobject obj, jint port){
	FT_Init(port);
  }
  
 JNIEXPORT jint JNICALL Java_com_example_ftReaderStandard_Tpcsc_SCardEstablishContext
  (JNIEnv *env, jobject obj){
	ULONG ret;
	ret = SCardEstablishContext(0,NULL,NULL,&g_hContext);
	if(ret != 0){
		printf("SCardEstablishContext error %08lx\n",ret);
		return -1;
	}else{
		printf("SCardEstablishContext ok\n");
		return 0;
	}
  }
  
  
  JNIEXPORT jstring JNICALL Java_com_example_ftReaderStandard_Tpcsc_SCardListReaders
  (JNIEnv *env, jobject obj){
	ULONG ret;
	int i,index,j;
	char readrs[128] = {0x00}; 
	LPSTR mszReaders = NULL;
	DWORD pcchReaders = SCARD_AUTOALLOCATE;

	
	ret = SCardListReaders(g_hContext,NULL,(LPSTR)&mszReaders,&pcchReaders);
	if(ret != 0){
		printf("SCardListReaders2 error %08lx\n",ret);
		return env->NewStringUTF("");  
	}
	printf("mszReaders===%s\n",mszReaders);
	for(i=0,index=0;i<pcchReaders;i++){
		strcpy(readerList[index++],mszReaders+i);
		i+=strlen(mszReaders+i);
	}
	
	for(i=0,j=0;i<index;i++,j++){
		printf("%d : %s\n",i,readerList[i]);
		memcpy(readrs+j,readerList[i],strlen(readerList[i]));
		j+=strlen(readerList[i]);
		memcpy(readrs+j,":",1);
	}
	
	return env->NewStringUTF(readrs);  
  }
  
  
  JNIEXPORT jint JNICALL Java_com_example_ftReaderStandard_Tpcsc_SCardConnect
  (JNIEnv *env, jobject obj, jint index){
	 
	ULONG ret;
	ret = SCardConnect(g_hContext,readerList[index],0,0,&g_hCard,NULL);
	if(ret != 0){
		printf("SCardConnect error %08lx\n",ret);
		if(ret == 0x80100010){
			return 1;
		}else{
			return -1;
		}
	}else{
		printf("g_hCard(slot index) = %d\n",g_hCard);
		return 0;
	}
  }
  
  JNIEXPORT jbyteArray JNICALL Java_com_example_ftReaderStandard_Tpcsc_SCardStatus
  (JNIEnv *env, jobject obj){
	  
	ULONG ret;
	int state;
	char atr[50]={0};
	int atrLen = sizeof(atr);
	int i;

	
	
	ret = SCardStatus(g_hCard,NULL,NULL,(unsigned long int*)&state,NULL,(unsigned char*)atr,(unsigned long int*)&atrLen);
	if(ret != 0){
		printf("SCardStatus error %08lx\n",ret);
		jbyteArray array = env->NewByteArray(0);
		env->SetByteArrayRegion(array,0,0,(const signed char*)atr);
		return array;
	}
	printf("SCardStatus %x",state);
	jbyteArray array = env->NewByteArray(atrLen);
	env->SetByteArrayRegion(array,0,atrLen,(const signed char*)atr);
	return array;
  }
  
  
  
  
  JNIEXPORT jint JNICALL Java_com_example_ftReaderStandard_Tpcsc_SCardDisconnect
  (JNIEnv *env, jobject obj){
	ULONG ret;
	ret = SCardDisconnect(g_hCard,0);
	if(ret != 0){
		printf("SCardDisconnect error %08lx\n",ret);
		return -1;
	}else{
		printf("SCardDisconnect ok\n");
		return 0;
	} 
  }
  
  
  JNIEXPORT jint JNICALL Java_com_example_ftReaderStandard_Tpcsc_SCardReleaseContext
  (JNIEnv *env, jobject obj){
	 ULONG ret;
	 ret = SCardReleaseContext(g_hContext); 
	 if(ret != 0){
		printf("SCardReleaseContext error %08lx\n",ret);
		return -1;
	}else{
		printf("SCardReleaseContext ok");
		return 0;
	} 
  }
  
  
 JNIEXPORT jbyteArray JNICALL Java_com_example_ftReaderStandard_Tpcsc_SCardTransmit
  (JNIEnv *env, jobject obj,jbyteArray apdu, jint apdulen){
	
	unsigned char resp[51200];
    unsigned int resplen = sizeof(resp);
	ULONG iRet = 0;

	char *apdubuf = (char *)malloc(apdulen);
	memset(apdubuf,0x00,apdulen);
	env->GetByteArrayRegion(apdu,0,apdulen,(signed char *)apdubuf);
	
	iRet=SCardTransmit(g_hCard,NULL, (unsigned char *)apdubuf, apdulen,NULL,resp, (unsigned long *)&resplen);
	free(apdubuf);
    if (iRet != SCARD_S_SUCCESS) {
		printf("SCardTransmit error %08lx\n",iRet);
		jbyteArray array = env->NewByteArray(0);
		env->SetByteArrayRegion(array,0,0,NULL);
		return array;
	}else{
		jbyteArray array = env->NewByteArray(resplen);
		env->SetByteArrayRegion(array,0,resplen,(const signed char*)resp);
		return array;
	}			
  }

 JNIEXPORT jbyteArray JNICALL Java_com_example_ftReaderStandard_Tpcsc_SCardControl
   (JNIEnv *env, jobject obj, jbyteArray apdu, jint apdulen){

	unsigned char resp[51200];
	unsigned int resplen = sizeof(resp);
	ULONG iRet = 0;

	char *apdubuf = (char *)malloc(apdulen);
	memset(apdubuf,0x00,apdulen);
	env->GetByteArrayRegion(apdu,0,apdulen,(signed char *)apdubuf);
	iRet=SCardControl(g_hCard,0,(unsigned char*)apdubuf,(unsigned long int)apdulen,(unsigned char*)resp,sizeof(resp),(unsigned long int*)&resplen);
	free(apdubuf);
	if (iRet != SCARD_S_SUCCESS) {
		printf("SCardTransmit error %08lx\n",iRet);
		jbyteArray array = env->NewByteArray(0);
		env->SetByteArrayRegion(array,0,0,NULL);
		return array;
	}else{
		jbyteArray array = env->NewByteArray(resplen);
		env->SetByteArrayRegion(array,0,resplen,(const signed char*)resp);
		return array;
	}

 }


 JNIEXPORT jint JNICALL Java_com_example_ftReaderStandard_Tpcsc_SCardIsValidContext
   (JNIEnv *env, jobject obj){
	ULONG ret;
	ret = SCardIsValidContext(g_hContext);
	if(ret != 0){
		printf("SCardIsValidContext error %08lx\n",ret);
		return -1;
	}else{
		printf("SCardIsValidContext ok\n");
		return 0;
	}
 }

 JNIEXPORT jint JNICALL Java_com_example_ftReaderStandard_Tpcsc_SCardGetStatusChange
   (JNIEnv *env, jobject obj, jint index){
	ULONG ret;
	int state;
	char atr[50]={0};
	int atrLen = sizeof(atr);
	int i;

	SCARD_READERSTATE readerState[1];
	memset(readerState,0,sizeof(readerState));

	readerState[0].szReader = readerList[index];

	ret = SCardGetStatusChange(g_hContext,0,readerState,1);
	if(ret != 0){
		printf("SCardGetStatusChange error %08lx\n",ret);
		return -1;
	}else{
		printf("SCardGetStatusChange %x\n",readerState[0].dwCurrentState);
	}
	return readerState[0].dwCurrentState;
}

 JNIEXPORT jstring JNICALL Java_com_example_ftReaderStandard_Tpcsc_SCardGetLastError
   (JNIEnv *env, jobject obj){

	 char lastError[1024]={0};
	 int lastErrorLen = sizeof(lastError);

	 int ret = FT_SCardGetLastError(lastError,&lastErrorLen);
	 if(ret != 0){
		 printf("SCardGetLastError error %08lx\n",ret);
		 return env->NewStringUTF("");
	 }
	 return env->NewStringUTF(lastError);
 }
