#!/bin/bash

LINEAGE_OUT_DIR=$1
LINEAGE_OUT_ZIP=$2
LINEAGE_SU_BIN=$3
LINEAGE_UPDATER_BIN=$4
LINEAGE_ADDOND_SCRIPT=$5

LINEAGE_OUT_DIR=$LINEAGE_OUT_DIR/staging

for flag in "$@"
do
    if [ -z $flag ] && [ ! -d $flag ]; then
        echo "$flag: file not found!"
        exit 1
    fi
done

if [ -d $LINEAGE_OUT_DIR ]; then
    rm -rf $LINEAGE_OUT_DIR
fi
mkdir $LINEAGE_OUT_DIR

mkdir $LINEAGE_OUT_DIR/system
mkdir $LINEAGE_OUT_DIR/system/addon.d
mkdir $LINEAGE_OUT_DIR/system/xbin
mkdir $LINEAGE_OUT_DIR/META-INF
mkdir $LINEAGE_OUT_DIR/META-INF/com/
mkdir $LINEAGE_OUT_DIR/META-INF/com/google/
mkdir $LINEAGE_OUT_DIR/META-INF/com/google/android

LINEAGE_SCRIPTS_DIR=$LINEAGE_OUT_DIR/META-INF/com/google/android

cp $LINEAGE_UPDATER_BIN $LINEAGE_SCRIPTS_DIR/update-binary
touch $LINEAGE_SCRIPTS_DIR/updater-script

cat<<EOF > $LINEAGE_SCRIPTS_DIR/updater-script
ui_print("Installing su addon...");
ifelse(is_mounted("/system"), unmount("/system"));
mount("ext4", "EMMC", "ANDROID_SYSTEM_PARTITION", "/system", "");
package_extract_dir("system", "/system");
unmount("/system");
ui_print("Done");
EOF

cp $LINEAGE_SU_BIN $LINEAGE_OUT_DIR/system/xbin/su
cp $LINEAGE_ADDOND_SCRIPT $LINEAGE_OUT_DIR/system/addon.d/51-addon-su.sh

rm $LINEAGE_OUT_ZIP
cd $LINEAGE_OUT_DIR
zip -ry $LINEAGE_OUT_ZIP .
