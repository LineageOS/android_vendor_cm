# Extra Packages For AimRom
PRODUCT_PACKAGES += \
    ThemeInterfacer \
    SnapdragonCamera \
    PixelLauncherPrebuilt \
    Turbo \
    AIMWIZARD
    
# Enable assistant by default
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opa.eligible_device=true

# Pixel icons
vendor/aim/prebuilt/app/pixelicons/PixelLauncherIcons.apk:system/app/pixellaunchericons/PixelLauncherIcons.apk

# MAGISK INCLUDE
ifneq ($(WITH_MAGISK),false)
# Magisk Manager
PRODUCT_PACKAGES += \
    MagiskManager
# Copy Magisk zip
PRODUCT_COPY_FILES += \
    vendor/aim/prebuilt/common/magisk.zip:system/addon.d/magisk.zip
endif
