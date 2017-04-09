ifeq ($(WITH_GMS),true)
ifneq ($(TARGET_ARCH),)
$(call inherit-product-if-exists, vendor/gapps/$(TARGET_ARCH)/$(TARGET_ARCH)-vendor.mk)
endif
endif
