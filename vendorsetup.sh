for combo in $(curl -s https://raw.githubusercontent.com/LineageOS/hudson/master/lineage-build-targets | sed -e 's/#.*$//' | grep cm-13.0 | awk '{printf "lineage_%s-%s\n", $1, $2}')
do
    add_lunch_combo $combo
done

while read -r file; do
    project="$(dirname ${file} | sed 's|vendor/cm/patch/||g')"
    bugid="$(grep '^Bug: ' ${file} | sed -E 's|^\s*Bug: ([0-9]+).*$|\1|g')"
    if [ "$(git -C ${project} log --grep "Bug: ${bugid}")" ]; then
        echo "${project}: b/${bugid} is already patched"
        continue
    fi
    git -C "${project}" am -q "$(pwd)/${file}" || git -C "${project}" am --abort
done <<< "$(find vendor/cm/patch -type f)"
unset project
unset bugid
