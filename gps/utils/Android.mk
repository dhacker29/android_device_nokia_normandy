LOCAL_PATH := $(call my-dir)

ifneq ($(BUILD_TINY_ANDROID),true)

#Compile this library only for builds with the latest modem image
include $(CLEAR_VARS)

## Libs
LOCAL_SHARED_LIBRARIES := \
    libutils \
    libcutils \
    libssl \
    libcrypto \

LOCAL_SRC_FILES += \
    loc_log.cpp \
    loc_cfg.cpp \
    msg_q.c \
    linked_list.c \
    loc_target.cpp \
    der2pem.c \

LOCAL_CFLAGS += \
     -fno-short-enums \
     -D_ANDROID_

LOCAL_LDFLAGS += -Wl,--export-dynamic

## Includes
LOCAL_C_INCLUDES := \
  external/openssl/include \

LOCAL_COPY_HEADERS_TO:= gps.utils/
LOCAL_COPY_HEADERS:= \
   loc_log.h \
   loc_cfg.h \
   log_util.h \
   linked_list.h \
   msg_q.h \
   loc_target.h \
   der2pem.h \

LOCAL_MODULE := libgps.utils
LOCAL_MODULE_TAGS := optional
LOCAL_PRELINK_MODULE := false

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)
include $(BUILD_SHARED_LIBRARY)
endif # not BUILD_TINY_ANDROID

include $(CLEAR_VARS)
LOCAL_MODULE      := der2pem.host
LOCAL_MODULE_STEM := der2pem
LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS := -Wall -Werror
LOCAL_SRC_FILES   := \
  der2pem.c \
  der2pem_main.c \

LOCAL_SHARED_LIBRARIES := \
  libssl \

LOCAL_C_INCLUDES := \
  external/openssl/include \

include $(BUILD_HOST_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE      := der2pem.target
LOCAL_MODULE_STEM := der2pem
LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS := -Wall -Werror
LOCAL_SRC_FILES   := \
  der2pem.c \
  der2pem_main.c \

LOCAL_SHARED_LIBRARIES := \
  libssl \
  libcrypto \

LOCAL_C_INCLUDES := \
  external/openssl/include \

include $(BUILD_EXECUTABLE)

