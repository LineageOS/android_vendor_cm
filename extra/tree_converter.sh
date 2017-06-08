#! /bin/bash
# For AIMROM built by ShadowReaper1

rom_source="${ANDROID_BUILD_TOP}"

echo -e "Searching for any available LineageOS device tree."
cd $rom_source/device
if grep -rl "lineage_"; then
echo -e "LineageOS device tree found!"
echo -e "Please wait until we modify it to work with our sources."
find . -type f -name lineage.mk -execdir mv {} aim.mk \;
wait
grep -rl "lineage_" | xargs sed -i s:lineage_:aim_:g
grep -rl "/cm/" | xargs sed -i s:/cm/:/aim/:g
echo -e "Device tree converted succesfully!"
echo -e "Make sure to clone the vendor for your device."
echo -e "You can continue building now."
else
echo -e "No LineageOS device tree found."
echo -e "If you have already edited the device tree to work with AIMROM then you can continue building the rom otherwise lunch your device."
fi
cd $rom_source
