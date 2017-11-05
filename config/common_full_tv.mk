# Inherit common CM stuff
$(call inherit-product, vendor/cm/config/common_full.mk)

PRODUCT_PACKAGES += TvSettings

DEVICE_PACKAGE_OVERLAYS += vendor/cm/overlay/tv

# SetupWraith needs WRITE_SECURE_SETTINGS as its not platform signed
PRODUCT_COPY_FILES += \
    vendor/cm/config/permissions/com.google.android.tungsten.setupwraith.xml:system/etc/permissions/com.google.android.tungsten.setupwraith.xml
