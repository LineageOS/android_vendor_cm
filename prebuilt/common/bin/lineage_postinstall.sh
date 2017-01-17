#!/system/bin/sh
#
# LineageOS A/B OTA Postinstall Script
#

# Run otapreopt_script, the default AOSP postinstall script
/system/bin/otapreopt_script

# Backup and restore using backuptool_ab
/system/bin/backuptool_ab.sh backup
/system/bin/backuptool_ab.sh restore

exit 0
