LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := FTReaderStandard
LOCAL_SRC_FILES := FTReaderStandard.cpp
LOCAL_CFLAGS	:=	-I./depend/include
LOCAL_LDLIBS	:= -L./depend -lftpcsc_arm_0.2.01 -llog
								
include $(BUILD_SHARED_LIBRARY)
