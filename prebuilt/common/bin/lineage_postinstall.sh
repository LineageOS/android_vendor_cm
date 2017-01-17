#!/system/bin/sh
#
# LineageOS Postinstall Script
#

# Symlink /system/bin/sh to /sbin/sh for the backuptool scripts
ln -s /system/bin/sh /sbin/sh

# Run otapreopt_script, the default AOSP postinstall script
/system/bin/otapreopt_script

# Backup and restore using backuptool
/system/bin/backuptool.sh backup
/system/bin/backuptool.sh restore

exit 0
