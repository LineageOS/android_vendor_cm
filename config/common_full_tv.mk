# Inherit common CM stuff
$(call inherit-product, vendor/cm/config/common_full.mk)

PRODUCT_PACKAGES += TvSettings

DEVICE_PACKAGE_OVERLAYS += vendor/cm/overlay/tv
