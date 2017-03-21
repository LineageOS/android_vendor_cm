#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

DEVICE=**** FILL IN DEVICE NAME ****
VENDOR=*** FILL IN VENDOR ****

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

CM_ROOT="$MY_DIR"/../../..

HELPER="$CM_ROOT"/vendor/cm/build/tools/extract_utils.sh
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

if [ $# -eq 0 ]; then
    SRC=adb
else
    if [ $# -eq 1 ]; then
        if [ "${1##*.}" == "zip" ]; then   # this could probably be improved
            DUMPDIR=$CM_ROOT/system_dump
            rm -rf $DUMPDIR
            mkdir $DUMPDIR
            unzip $1 -d $DUMPDIR

            # If block based, extract it first
            if [ -a $DUMPDIR/system.new.dat ]; then
                sdatpath=`which sdat2img.py`
                if [[ $sdatpath == "" ]]; then
                    git clone https://github.com/xpirt/sdat2img $DUMPDIR/sdat2img
                    sdatpath=$DUMPDIR/sdat2img/sdat2img.py
                fi

                echo "Converting system.new.dat to system.img"
                python $sdatpath $DUMPDIR/system.transfer.list $DUMPDIR/system.new.dat $DUMPDIR/system.img 2>&1
                rm $DUMPDIR/system.new.dat
                rm -rf $DUMPDIR/system
                mkdir $DUMPDIR/system $DUMPDIR/tmp
                echo "Requesting sudo access to mount the system.img"
                sudo mount -o loop $DUMPDIR/system.img $DUMPDIR/tmp
                sudo cp -r $DUMPDIR/tmp/* $DUMPDIR/system/
                sudo umount $DUMPDIR/tmp
                sudo chown -R ${whoami}:${whoami} $DUMPDIR/system/
                rmdir $DUMPDIR/tmp
                rm $DUMPDIR/system.img
            fi

            SRC=$DUMPDIR
        else
            SRC=$1
        fi
    else
        echo "$0: bad number of arguments"
        echo ""
        echo "usage: $0 [PATH_TO_EXPANDED_ROM]"
        echo ""
        echo "If PATH_TO_EXPANDED_ROM is not specified, blobs will be extracted from"
        echo "the device using adb pull."
        exit 1
    fi
fi

# Initialize the helper
setup_vendor "$DEVICE" "$VENDOR" "$CM_ROOT"

extract "$MY_DIR"/proprietary-files.txt "$SRC"

"$MY_DIR"/setup-makefiles.sh
