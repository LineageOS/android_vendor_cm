for combo in $(curl -s https://raw.githubusercontent.com/LineageOS/hudson/master/lineage-build-targets | sed -e 's/#.*$//' | grep cm-13.0 | awk '{printf "lineage_%s-%s\n", $1, $2}')
do
    add_lunch_combo $combo
done

if grep -q "PLATFORM_VERSION := 6.0.1" build/core/version_defaults.mk
  then
  cd external/svox
  if [ -e "bug_69177126" ]; then
    echo 'external/svox patched already';
  else
    git am ../../vendor/cm/patch/external/svox/0001-SVOX-Properly-initialize-buffers.patch || git am --abort
  fi
else
  echo 'This is not Android 6, patching external/svox not possible';
fi
croot
