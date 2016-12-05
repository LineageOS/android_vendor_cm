#!/bin/bash

WIDTH="$1"
HEIGHT="$2"
HALF_RES="$3"
OUT="$ANDROID_PRODUCT_OUT/obj/BOOTANIMATION"

if [ "$HEIGHT" -lt "$WIDTH" ]; then
    SIZE="$HEIGHT"
else
    SIZE="$WIDTH"
fi

if [ "$HALF_RES" = "true" ]; then
    IMAGESIZE=$(expr $SIZE / 2)
else
    IMAGESIZE="$SIZE"
fi

RESOLUTION=""$IMAGESIZE"x"$IMAGESIZE""

for part_cnt in 0 1 2
do
    mkdir -p $ANDROID_PRODUCT_OUT/obj/BOOTANIMATION/bootanimation/part$part_cnt
done
CONVERTBIN="convert"
if [ "$HOST_OS" = "linux" ]; then
    # use embedded linux x86_64 prebuilt
    CONVERTBIN="vendor/cm/bootanimation/convert"
fi
tar xfp "vendor/cm/bootanimation/bootanimation.tar" --to-command="$CONVERTBIN - -resize '$RESOLUTION' \"png8:$OUT/bootanimation/\$TAR_FILENAME\""

# Create desc.txt
echo "$SIZE" "$SIZE" 30 > "$OUT/bootanimation/desc.txt"
cat "vendor/cm/bootanimation/desc.txt" >> "$OUT/bootanimation/desc.txt"

# Create bootanimation.zip
cd "$OUT/bootanimation"

zip -qr0 "$OUT/bootanimation.zip" .
