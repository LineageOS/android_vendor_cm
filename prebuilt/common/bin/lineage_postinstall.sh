#!/system/bin/sh
#
# LineageOS A/B OTA Postinstall Script
#

# Run otapreopt_script, the default AOSP postinstall script
/postinstall/system/bin/otapreopt_script "$@"

# Sleep for a few seconds to make sure /postinstall is no longer in use
sleep 3

# Unmount the context-mounted /postinstall
umount /postinstall

# Let's loop a bit just to ensure this got unmounted...hack, shitty, but effective
for i in `seq 1 10`; do
  if mount | grep /postinstall; then
    echo "/postinstall still mounted. Attempting unmount in 3 seconds..."
    sleep 3
    umount /postinstall
  else
    echo "/postinstall successfully unmounted. Continuing with backuptool..."
    break
  fi
done

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
