#!/system/bin/sh
#
# LineageOS A/B OTA Postinstall Script
#

# Run otapreopt_script, the default AOSP postinstall script
/postinstall/system/bin/otapreopt_script "$@"

# Unmount the context-mounted /postinstall
umount /postinstall

# Get slot for new install
TARGET_SLOT="$1"
if [ "$TARGET_SLOT" = "0" ] ; then
  TARGET_SLOT_SUFFIX="_a"
elif [ "$TARGET_SLOT" = "1" ] ; then
  TARGET_SLOT_SUFFIX="_b"
else
  echo "Unknown target slot $TARGET_SLOT"
  exit 1
fi

# Mount without a context and perform backuptool operations
mount /dev/block/bootdevice/by-name/system$TARGET_SLOT_SUFFIX /postinstall
/postinstall/system/bin/backuptool_ab.sh backup
/postinstall/system/bin/backuptool_ab.sh restore

sync

exit 0
