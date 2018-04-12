#ifndef __FT_TOOLS_H__
#define __FT_TOOLS_H__


#ifdef __cplusplus
extern "C"
{
#endif


int strToHex(char* str,unsigned char* hex,unsigned int* hexLen);
int hexToStr(char* str,int* strLen,unsigned char* hex,int hexLen);

#ifdef __cplusplus
}
#endif


#define MODE_PA		1
#define MODE_AA		2



#if MODE == MODE_AA

#include <android/log.h>

#define LOG		"libFTReaderTest"
#define LOGV(...) __android_log_print(ANDROID_LOG_VERBOSE, LOG, __VA_ARGS__)
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG , LOG, __VA_ARGS__)
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO  , LOG, __VA_ARGS__)
#define LOGW(...) __android_log_print(ANDROID_LOG_WARN  , LOG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR  , LOG, __VA_ARGS__)

#define printLog(...)	LOGD(__VA_ARGS__);
#define dprintf	printLog

#define printf printLog

#endif





#endif
