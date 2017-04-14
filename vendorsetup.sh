while read device; do
  add_lunch_combo aim_$device-userdebug
done < vendor/aim/devices/device.list
