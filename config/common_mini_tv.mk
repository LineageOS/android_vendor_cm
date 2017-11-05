# Inherit common CM stuff
$(call inherit-product, vendor/cm/config/common_mini.mk)

# SetupWraith needs WRITE_SECURE_SETTINGS as its not platform signed
PRODUCT_COPY_FILES += \
    vendor/cm/config/permissions/com.google.android.tungsten.setupwraith.xml:system/etc/permissions/com.google.android.tungsten.setupwraith.xml
