## Specify phone tech before including full_phone
$(call inherit-product, vendor/cm/config/gsm.mk)

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Boot animation
TARGET_SCREEN_WIDTH := 480
TARGET_SCREEN_HEIGHT := 800

# Release name
PRODUCT_RELEASE_NAME := Nokia X 
PRODUCT_NAME := cm_normandy

$(call inherit-product, device/nokia/normandy/full_normandy.mk)

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_BRAND=Nokia \
    PRODUCT_NAME=Nokia_X \
    BUILD_PRODUCT=RM-980
#    BUILD_FINGERPRINT=qcom/msm8625/msm8625:4.1.2/JZO54K/eng.ZYC.20140213.151118:eng/test-keys
