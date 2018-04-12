LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := FTReaderTest
LOCAL_SRC_FILES := FTReaderTest.cpp
LOCAL_CFLAGS	:=	-I./depend
LOCAL_LDLIBS	:= -L./depend -lftpcsc_arm_0.1 -llog

include $(BUILD_SHARED_LIBRARY)
