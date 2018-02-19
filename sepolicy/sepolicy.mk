#
# This policy configuration will be used by all products that
# inherit from CM
#

BOARD_SEPOLICY_DIRS += \
    vendor/cm/sepolicy

BOARD_SEPOLICY_UNION += \
    file.te \
    file_contexts \
    fs_use \
    genfs_contexts \
    seapp_contexts \
    installd.te \
    netd.te \
    system.te \
    ueventd.te \
    vold.te \
    mac_permissions.xml

ifeq ($(TARGET_BUILD_VARIANT),user)
BOARD_SEPOLICY_UNION += \
    su_user.te
else
BOARD_SEPOLICY_UNION += \
    su.te
endif