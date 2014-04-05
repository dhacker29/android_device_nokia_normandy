# Copyright 2011 The Android Open Source Project

ifneq ($(BUILD_TINY_ANDROID),true)

LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	charger.c \
    battery_ac.c

LOCAL_MODULE := nokia_charger
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)
LOCAL_REQUIRED_MODULES := nokia_charger_res_images
LOCAL_UNSTRIPPED_PATH := $(TARGET_ROOT_OUT_UNSTRIPPED)

LOCAL_C_INCLUDES := bootable/recovery
LOCAL_C_INCLUDES += system/core/libsuspend/include

LOCAL_STATIC_LIBRARIES := libminui libpixelflinger_static libpng
LOCAL_STATIC_LIBRARIES += libz libcutils libc
LOCAL_SHARED_LIBRARIES := libhardware_legacy libsuspend

include $(BUILD_EXECUTABLE)

define _nokia_add-charger-image
include $$(CLEAR_VARS)
LOCAL_MODULE := nokia_system_core_charger_$(notdir $(1))
LOCAL_MODULE_STEM := $(notdir $(1))
_nokia_img_modules += $$(LOCAL_MODULE)
LOCAL_SRC_FILES := $1
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $$(TARGET_ROOT_OUT)/res/images/charger
include $$(BUILD_PREBUILT)
endef

_img_modules :=
_images :=
$(foreach _img, $(call find-subdir-subdir-files, "images", "*.png"), \
  $(eval $(call _add-charger-image,$(_img))))

include $(CLEAR_VARS)
LOCAL_MODULE := nokia_charger_res_images
LOCAL_MODULE_TAGS := optional
LOCAL_REQUIRED_MODULES := $(_img_modules)
include $(BUILD_PHONY_PACKAGE)

_nokia_add-charger-image :=
_nokia_img_modules :=

endif
