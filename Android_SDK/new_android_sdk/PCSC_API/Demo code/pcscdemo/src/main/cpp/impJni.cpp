//
// Created by lichao on 2019/5/9.
//

#include <jni.h>
#include <cstring>
#include <android/log.h>
#include "winscard/winscard.h"
#include "winscard/wintypes.h"

JavaVM *g_vm = NULL;
SCARDCONTEXT g_context;
SCARDHANDLE g_cardHandle = 0;

//Recieve reader events.
void callback(int state){
    JNIEnv *env = NULL;
    if ((g_vm->GetEnv((void**) &env, JNI_VERSION_1_6)) != JNI_OK)
    {
        return;
    }
    jclass clazz = env->FindClass("com/ftsafe/pcscdemo/MainActivity");
    jmethodID mid = env->GetStaticMethodID(clazz, "showState", "(I)V");
    env->CallStaticVoidMethod(clazz, mid, state);
};

JNIEXPORT void JNICALL Init(JNIEnv *env, jobject obj) {
    FT_Init(g_vm, callback);
}

JNIEXPORT void JNICALL UnInit(JNIEnv *env, jobject obj) {
    FT_UnInit();
}

JNIEXPORT int JNICALL SCardEstablishContext(JNIEnv *env, jobject obj) {
    return FT_SCardEstablishContext(NULL, NULL, NULL, &g_context);
}

JNIEXPORT int JNICALL SCardReleaseContext(JNIEnv *env, jobject obj) {
    return FT_SCardReleaseContext(g_context);
}

JNIEXPORT int JNICALL SCardIsValidContext(JNIEnv *env, jobject obj) {
    return FT_SCardIsValidContext(g_context);
}

JNIEXPORT int JNICALL SCardListReaderGroups(JNIEnv *env, jobject obj) {
    return FT_SCardListReaderGroups(NULL, NULL, NULL);
}

JNIEXPORT int JNICALL SCardListReaders(JNIEnv *env, jobject obj, jbyteArray readerNames) {
    if(readerNames == NULL){
        return SCARD_E_INVALID_PARAMETER;
    }
    unsigned char* pReaderNames = (unsigned char*)env->GetByteArrayElements(readerNames, JNI_FALSE);
    DWORD readerNamesLen = 0;
    int ret = FT_SCardListReaders(g_context, NULL, (LPSTR)pReaderNames, &readerNamesLen);
    if(pReaderNames != NULL){
        env->ReleaseByteArrayElements(readerNames, (jbyte*)pReaderNames, JNI_FALSE);
    }
    return ret;
}

JNIEXPORT int JNICALL SCardConnect(JNIEnv *env, jobject obj, jbyteArray readerName) {
    if(readerName == NULL){
        return SCARD_E_INVALID_PARAMETER;
    }
    unsigned char* pReaderName = (unsigned char*)env->GetByteArrayElements(readerName, JNI_FALSE);
    int nameLen = env->GetArrayLength(readerName);

    unsigned char pName[128] = {0};
    memcpy(pName, pReaderName, nameLen);

    DWORD activeProtocol = 0;
    int ret = FT_SCardConnect(g_context, (LPCSTR)pName, SCARD_SHARE_SHARED, SCARD_PROTOCOL_T0, &g_cardHandle, &activeProtocol);
    if(pReaderName != NULL){
        env->ReleaseByteArrayElements(readerName, (jbyte*)pReaderName, JNI_FALSE);
    }
    return ret;
}

JNIEXPORT int JNICALL SCardDisconnect(JNIEnv *env, jobject obj) {
    return FT_SCardDisconnect(g_context, SCARD_RESET_CARD);
}

JNIEXPORT int JNICALL SCardBeginTransaction(JNIEnv *env, jobject obj) {
    return FT_SCardBeginTransaction(g_cardHandle);
}

JNIEXPORT int JNICALL SCardEndTransaction(JNIEnv *env, jobject obj) {
    return FT_SCardEndTransaction(g_cardHandle, SCARD_RESET_CARD);
}

JNIEXPORT int JNICALL SCardStatus(JNIEnv *env, jobject obj, jintArray cardState, jintArray protocol,
        jbyteArray atr, jintArray atrLen) {
    if(cardState == NULL || protocol == NULL || atr == NULL || atrLen == NULL){
        return SCARD_E_INVALID_PARAMETER;
    }
    LPDWORD pCardState = (LPDWORD)env->GetIntArrayElements(cardState, JNI_FALSE);
    LPDWORD pProtocol = (LPDWORD)env->GetIntArrayElements(protocol, JNI_FALSE);
    LPBYTE pAtr = (LPBYTE)env->GetByteArrayElements(atr, JNI_FALSE);
    LPDWORD pAtrLen = (LPDWORD)env->GetIntArrayElements(atrLen, JNI_FALSE);

    int ret = FT_SCardStatus(g_cardHandle, NULL, NULL, pCardState, pProtocol, pAtr, pAtrLen);

    env->ReleaseIntArrayElements(cardState, (jint*)pCardState, JNI_FALSE);
    env->ReleaseIntArrayElements(protocol, (jint*)pProtocol, JNI_FALSE);
    env->ReleaseByteArrayElements(atr, (jbyte*)pAtr, JNI_FALSE);
    env->ReleaseIntArrayElements(atrLen, (jint*)pAtrLen, JNI_FALSE);
    return ret;
}

JNIEXPORT int JNICALL SCardGetStatusChange(JNIEnv *env, jobject obj, jintArray cardState,
                                            jbyteArray atr, jintArray atrLen) {
    if(cardState == NULL || atr == NULL || atrLen == NULL){
        return SCARD_E_INVALID_PARAMETER;
    }
    LPDWORD pCardState = (LPDWORD)env->GetIntArrayElements(cardState, JNI_FALSE);
    LPBYTE pAtr = (LPBYTE)env->GetByteArrayElements(atr, JNI_FALSE);
    LPDWORD pAtrLen = (LPDWORD)env->GetIntArrayElements(atrLen, JNI_FALSE);

    SCARD_READERSTATE readerstate = {0};
    int ret = FT_SCardGetStatusChange(g_context, 0, &readerstate, 0);

    if(ret == 0) {
        *pCardState = readerstate.dwEventState;
        *pAtrLen = readerstate.cbAtr;
        memcpy(pAtr, readerstate.rgbAtr, readerstate.cbAtr);
    }

    env->ReleaseIntArrayElements(cardState, (jint*)pCardState, JNI_FALSE);
    env->ReleaseByteArrayElements(atr, (jbyte*)pAtr, JNI_FALSE);
    env->ReleaseIntArrayElements(atrLen, (jint*)pAtrLen, JNI_FALSE);
    return ret;
}

//Give the reader instructions.
JNIEXPORT int JNICALL SCardControl(JNIEnv *env, jobject obj, jbyteArray send, jbyteArray recv, jintArray recvLen) {
    if(send == NULL || recv == NULL || recvLen == NULL){
        return SCARD_E_INVALID_PARAMETER;
    }

    LPCVOID pSend = (LPCVOID)env->GetByteArrayElements(send, JNI_FALSE);
    LPVOID pRecv = (LPVOID)env->GetByteArrayElements(recv, JNI_FALSE);
    LPDWORD pRecvLen = (LPDWORD)env->GetIntArrayElements(recvLen, JNI_FALSE);
    DWORD sendLen = env->GetArrayLength(send);

    int ret = FT_SCardControl(g_cardHandle, 0xddd, pSend, sendLen, pRecv, *pRecvLen, pRecvLen);

    env->ReleaseByteArrayElements(send, (jbyte*)pSend, JNI_FALSE);
    env->ReleaseByteArrayElements(recv, (jbyte*)pRecv, JNI_FALSE);
    env->ReleaseIntArrayElements(recvLen, (jint*)pRecvLen, JNI_FALSE);

    return ret;
}

//Give the card instructions.
JNIEXPORT int JNICALL SCardTransmit(JNIEnv *env, jobject obj, jbyteArray send, jbyteArray recv, jintArray recvLen) {
    if(send == NULL || recv == NULL || recvLen == NULL){
        return SCARD_E_INVALID_PARAMETER;
    }

    LPCBYTE pSend = (LPCBYTE)env->GetByteArrayElements(send, JNI_FALSE);
    LPBYTE pRecv = (LPBYTE)env->GetByteArrayElements(recv, JNI_FALSE);
    LPDWORD pRecvLen = (LPDWORD)env->GetIntArrayElements(recvLen, JNI_FALSE);
    DWORD sendLen = env->GetArrayLength(send);

    SCARD_IO_REQUEST pci = {0};

    int ret = FT_SCardTransmit(g_cardHandle, &pci, pSend, sendLen, NULL, pRecv, pRecvLen);

    env->ReleaseByteArrayElements(send, (jbyte*)pSend, JNI_FALSE);
    env->ReleaseByteArrayElements(recv, (jbyte*)pRecv, JNI_FALSE);
    env->ReleaseIntArrayElements(recvLen, (jint*)pRecvLen, JNI_FALSE);

    return ret;
}

JNIEXPORT int JNICALL SCardCancel(JNIEnv *env, jobject obj) {
    return FT_SCardCancel(NULL);
}

JNIEXPORT int JNICALL SCardReconnect(JNIEnv *env, jobject obj) {
    DWORD activeProtocol = 0;
    return FT_SCardReconnect(g_cardHandle, SCARD_SHARE_SHARED, SCARD_PROTOCOL_T0, SCARD_RESET_CARD, &activeProtocol);
}

JNIEXPORT int JNICALL SCardGetAttrib(JNIEnv *env, jobject obj, jbyteArray atr, jintArray atrLen) {
    if(atr == NULL || atrLen == NULL){
        return SCARD_E_INVALID_PARAMETER;
    }
    LPBYTE pAtr = (LPBYTE)env->GetByteArrayElements(atr, JNI_FALSE);
    LPDWORD pAtrLen = (LPDWORD)env->GetIntArrayElements(atrLen, JNI_FALSE);

    int ret = FT_SCardGetAttrib(g_cardHandle, NULL, pAtr, pAtrLen);

    env->ReleaseByteArrayElements(atr, (jbyte*)pAtr, JNI_FALSE);
    env->ReleaseIntArrayElements(atrLen, (jint*)pAtrLen, JNI_FALSE);

    return ret;
}

static JNINativeMethod gMethods[] = {
        {
                "FT_Init",
                "()V",
                (void*)Init
        },
        {
                "FT_UnInit",
                "()V",
                (void*)UnInit
        },
        {
                "SCardEstablishContext",
                "()I",
                (void*)SCardEstablishContext
        },
        {
                "SCardReleaseContext",
                "()I",
                (void*)SCardReleaseContext
        },
        {
                "SCardIsValidContext",
                "()I",
                (void*)SCardIsValidContext
        },
        {
                "SCardListReaderGroups",
                "()I",
                (void*)SCardListReaderGroups
        },
        {
                "SCardListReaders",
                "([B)I",
                (void*)SCardListReaders
        },
        {
                "SCardConnect",
                "([B)I",
                (void*)SCardConnect
        },
        {
                "SCardDisconnect",
                "()I",
                (void*)SCardDisconnect
        },
        {
                "SCardBeginTransaction",
                "()I",
                (void*)SCardBeginTransaction
        },
        {
                "SCardEndTransaction",
                "()I",
                (void*)SCardEndTransaction
        },
        {
                "SCardStatus",
                "([I[I[B[I)I",
                (void*)SCardStatus
        },
        {
                "SCardGetStatusChange",
                "([I[B[I)I",
                (void*)SCardGetStatusChange
        },
        {
                "SCardControl",
                "([B[B[I)I",
                (void*)SCardControl
        },
        {
                "SCardTransmit",
                "([B[B[I)I",
                (void*)SCardTransmit
        },
        {
                "SCardCancel",
                "()I",
                (void*)SCardCancel
        },
        {
                "SCardReconnect",
                "()I",
                (void*)SCardReconnect
        },
        {
                "SCardGetAttrib",
                "([B[I)I",
                (void*)SCardGetAttrib
        }
};

int registerFtNatives(JNIEnv *env) {
    jclass cls = env->FindClass("com/ftsafe/pcscdemo/PCSCNative");
    if (NULL == cls) {
        return JNI_FALSE;
    }
    if (env->RegisterNatives(cls, gMethods, sizeof(gMethods) / sizeof(gMethods[0])) < 0) {
        return JNI_FALSE;
    }
    return JNI_TRUE;
}

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void* reserved){
    JNIEnv* env = NULL;
    if (vm->GetEnv((void**) &env, JNI_VERSION_1_6) != JNI_OK){
        return JNI_FALSE;
    }

    env->GetJavaVM(&g_vm);

    if(registerFtNatives(env) == JNI_FALSE){
        return JNI_FALSE;
    }

    return JNI_VERSION_1_6;
}