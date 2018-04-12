#include <jni.h>
#include <android/log.h>
#include "ft_pcsc.h"
#include <stdio.h>
#include "ft_tools.h"
#include <string.h>

#include "com_example_ftreadertest_Tpcsc.h"




#define LOG		"libFTReaderTest"
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



void A(){
	ULONG ret;
	ret = SCardEstablishContext(0,NULL,NULL,&g_hContext);
	if(ret != 0){
		printf("SCardEstablishContext error %08lx\n",ret);
	}
}

void C(){
	ULONG ret;
	int i,index;

	LPSTR mszReaders = NULL;
	DWORD pcchReaders = SCARD_AUTOALLOCATE;

	ret = SCardListReaders(g_hContext,NULL,&mszReaders,&pcchReaders);
	if(ret != 0){
		printf("SCardListReaders2 error %08lx\n",ret);
		return;
	}

	for(i=0,index=0;i<pcchReaders;i++){
		strcpy(readerList[index++],mszReaders+i);
		i+=strlen(mszReaders);
	}
	for(i=0;i<index;i++){
		printf("%d : %s\n",i,readerList[i]);
	}



}

void D(int a){
	ULONG ret;
	ret = SCardConnect(g_hContext,readerList[a],0,0,&g_hCard,NULL);
	if(ret != 0){
		printf("SCardConnect error %08lx\n",ret);
		return;
	}
	printf("g_hCard(slot index) = %d\n",g_hCard);
}

void E(){
	ULONG ret;
	int state;
	unsigned char atr[50]={0};
	int atrLen = sizeof(atr);
	int i;

	ret = SCardStatus(g_hCard,NULL,NULL,(unsigned long int*)&state,NULL,atr,(unsigned long int*)&atrLen);
	if(ret != 0){
		printf("SCardStatus error %08lx\n",ret);
		return;
	}
	printf("state===%d\n",state);
	printf("ATR:");
	for(i=0;i<atrLen;i++){
		printf("%02x ",atr[i]&0xff);
	}
	printf("\n");
}

void F(char* sendStr){
	ULONG ret;

	unsigned char sendBuf[1024]={0};
	int sendLen = sizeof(sendBuf);
	unsigned char recvBuf[1024]={0};
	int recvLen = sizeof(recvBuf);

	strToHex(sendStr,sendBuf,(unsigned int*)&sendLen);

	printf("send:%s\n",sendStr);
	ret = SCardTransmit(g_hCard,NULL,(const unsigned char*)sendBuf,(unsigned long int)sendLen,NULL,recvBuf,(unsigned long int*)&recvLen);
	if(ret != 0){
		printf("SCardTransmit error %08lx\n",ret);
		return;
	}

	memset(sendBuf,0,sizeof(sendBuf));
	sendLen = sizeof(sendBuf);
	hexToStr((char*)sendBuf,&sendLen,recvBuf,recvLen);
	printf("recv:%s\n",sendBuf);
}

void B(){
	SCardReleaseContext(g_hContext);
}

void G(){
	ULONG ret;
	ret = SCardDisconnect(g_hCard,0);
	if(ret != 0){
		printf("SCardDisconnect error %08lx\n",ret);
		return;
	}
}
JNIEXPORT void JNICALL Java_com_example_ftreadertest_Tpcsc_testA
  (JNIEnv *env, jobject obj, jint port){

	FT_Init(port);

	A();

	C();

	D(0);

	E();

	F("0084000008");

	G();

	B();

}







