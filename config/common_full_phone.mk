# Inherit common CM stuff
$(call inherit-product, vendor/aim/config/common_full.mk)

# Required CM packages
PRODUCT_PACKAGES += \
    LatinIME

# Include CM LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/aim/overlay/dictionaries

$(call inherit-product, vendor/aim/config/telephony.mk)
