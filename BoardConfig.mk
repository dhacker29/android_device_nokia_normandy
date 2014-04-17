#
# Copyright (C) 2014 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# This file sets variables that control the way modules are built
# thorughout the system. It should not be used to conditionally
# disable makefiles (the proper mechanism to control what gets
# included in a build is to use PRODUCT_PACKAGES in a product
# definition file).
#

# inherit from the proprietary version
-include vendor/nokia/normandy/BoardConfigVendor.mk

TARGET_SPECIFIC_HEADER_PATH := device/nokia/normandy/include

BOARD_USES_GENERIC_AUDIO := true
USE_CAMERA_STUB := true

TARGET_GLOBAL_CFLAGS += -mfpu=neon -mfloat-abi=softfp
TARGET_GLOBAL_CPPFLAGS += -mfpu=neon -mfloat-abi=softfp

TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true
# Try to use ASHMEM if possible (when non-MDP composition is used)
TARGET_GRALLOC_USES_ASHMEM := true

# Arch related defines and optimizations
TARGET_ARCH := arm
TARGET_CPU_ABI  := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a5
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_BOARD_PLATFORM := msm7x27a
TARGET_BOOTLOADER_BOARD_NAME := 7x27
TARGET_CPU_SMP := true

TARGET_CORTEX_CACHE_LINE_32 := true
TARGET_USE_QCOM_BIONIC_OPTIMIZATION := true

TARGET_USES_ION := true

TARGET_BOARD_PLATFORM_GPU := qcom-adreno203
BOARD_USES_ADRENO_200 := true

# Inline kernel building
TARGET_KERNEL_SOURCE := kernel/nokia/normandy
TARGET_KERNEL_CONFIG := cyanogenmod_normandy_defconfig

KERNEL_EXTERNAL_MODULES:
	mkdir -p $(KERNEL_MODULES_OUT)/ath6kl
	rm -rf $(TARGET_OUT_INTERMEDIATES)/compat-wireless
	cp -a device/nokia/normandy/compat-wireless $(TARGET_OUT_INTERMEDIATES)/
	$(MAKE) -C $(TARGET_OUT_INTERMEDIATES)/compat-wireless KLIB=$(KERNEL_OUT) KLIB_BUILD=$(KERNEL_OUT) ARCH="arm" CROSS_COMPILE="arm-eabi-"
	rm $(KERNEL_MODULES_OUT)/cfg80211.ko
	$(TARGET_OBJCOPY) --strip-unneeded $(TARGET_OUT_INTERMEDIATES)/compat-wireless/cfg80211.ko $(KERNEL_MODULES_OUT)/ath6kl/cfg80211.ko
	$(TARGET_OBJCOPY) --strip-unneeded $(TARGET_OUT_INTERMEDIATES)/compat-wireless/wlan.ko $(KERNEL_MODULES_OUT)/ath6kl/ath6kl_sdio.ko
	ln -sf /system/lib/modules/ath6kl/cfg80211.ko $(KERNEL_MODULES_OUT)/cfg80211.ko
	ln -sf /system/lib/modules/ath6kl/ath6kl_sdio.ko $(KERNEL_MODULES_OUT)/wlan.ko

TARGET_KERNEL_MODULES := KERNEL_EXTERNAL_MODULES

# Kernel
BOARD_KERNEL_BASE    := 0x00200000
BOARD_KERNEL_PAGESIZE := 4096
#Spare size is (BOARD_KERNEL_PAGESIZE>>9)*16
BOARD_KERNEL_SPARESIZE := 128
BOARD_KERNEL_BCHECC_SPARESIZE := 160

# Support to build images for 2K NAND page
BOARD_KERNEL_2KSPARESIZE := 64

TARGET_USERIMAGES_USE_EXT4 := true
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_USES_UNCOMPRESSED_KERNEL := false

BOARD_KERNEL_CMDLINE := androidboot.hardware=qcom loglevel=1 vmalloc=200M androidboot.selinux=permissive
ARCH_ARM_HAVE_TLS_REGISTER := true
BOARD_EGL_CFG := device/nokia/normandy/config/egl.cfg

BOARD_BOOTIMAGE_PARTITION_SIZE := 0x00A00000
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x00A00000
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 465567744
BOARD_USERDATAIMAGE_PARTITION_SIZE := 314556416
BOARD_PERSISTIMAGE_PARTITION_SIZE := 10485760
BOARD_CACHEIMAGE_PARTITION_SIZE := 41943040
BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)

BOARD_USES_QCOM_HARDWARE := true
TARGET_USES_QCOM_BSP := true
COMMON_GLOBAL_CFLAGS += -DQCOM_FM_ENABLED

# Audio
#BOARD_USES_SRS_TRUEMEDIA := true
BOARD_HAVE_QCOM_FM := true
TARGET_PROVIDES_LIBAUDIO := true
TARGET_HAS_QACT := true
TARGET_QCOM_AUDIO_VARIANT := legacy
BOARD_USES_LEGACY_ALSA_AUDIO := true

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/nokia/normandy/bluetooth

# Camera
COMMON_GLOBAL_CFLAGS += -DMR0_CAMERA_BLOB -DNEEDS_VECTORIMPL_SYMBOLS

# Dalvik
TARGET_ARCH_LOWMEM := true

# Display
USE_OPENGL_RENDERER := true
TARGET_QCOM_DISPLAY_VARIANT := legacy
BOARD_ADRENO_DECIDE_TEXTURE_TARGET := true
BOARD_EGL_WORKAROUND_BUG_10194508 := true
BOARD_USE_MHEAP_SCREENSHOT := true

# Media
TARGET_QCOM_MEDIA_VARIANT := caf
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true
COMMON_GLOBAL_CFLAGS += -DQCOM_NO_SECURE_PLAYBACK

# Storage / Sharing
BOARD_VOLD_MAX_PARTITIONS := 35
BOARD_VOLD_EMMC_SHARES_DEV_MAJOR := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := /sys/class/android_usb/android0/f_mass_storage/lun%d/file

# GPS
TARGET_NO_RPC := false
BOARD_USES_QCOM_GPS := true
BOARD_VENDOR_QCOM_GPS_LOC_API_AMSS_VERSION := 50000
BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := default

# Webkit
ENABLE_WEBGL := true
PRODUCT_PREBUILT_WEBVIEWCHROMIUM := yes
TARGET_FORCE_CPU_UPLOAD := true

# WLAN
BOARD_HAS_ATH_WLAN          := true
BOARD_WLAN_DEVICE := ath6kl
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_ath6kl
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_ath6kl
WPA_SUPPLICANT_VERSION      := VER_0_8_X
HOSTAPD_VERSION             := VER_0_8_X
WIFI_EXT_MODULE_PATH        := "/system/lib/modules/cfg80211.ko"
WIFI_EXT_MODULE_NAME        := "cfg80211"
WIFI_EXT_MODULE_ARG         := ""
WIFI_DRIVER_MODULE_PATH     := "/system/lib/modules/wlan.ko"
WIFI_DRIVER_MODULE_NAME     := "wlan"
WIFI_DRIVER_MODULE_ARG      := ""
WIFI_TEST_INTERFACE         := "sta"
WIFI_DRIVER_FW_PATH_STA     := "sta"
WIFI_DRIVER_FW_PATH_AP      := "ap"
WIFI_DRIVER_FW_PATH_P2P     := "p2p"

# Assert
TARGET_OTA_ASSERT_DEVICE := normandy,msm8625

# Recovery
TARGET_RECOVERY_FSTAB := device/nokia/normandy/rootdir/etc/fstab.qcom
BOARD_UMS_LUNFILE := "/sys/class/android_usb/android0/f_mass_storage/lun%d/file"
BOARD_HAS_NO_SELECT_BUTTON := true
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
TW_BOARD_CUSTOM_GRAPHICS := ../../../device/nokia/normandy/recovery/tw_graphics.c
DEVICE_RESOLUTION := 480x800
TW_FLASH_FROM_STORAGE := true
TW_INTERNAL_STORAGE_PATH := "/sdcard1"
TW_EXTERNAL_STORAGE_PATH := "/sdcard"
TW_DEFAULT_EXTERNAL_STORAGE := true
