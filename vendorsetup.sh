for combo in $(curl -s https://raw.githubusercontent.com/LineageOS/hudson/master/lineage-build-targets | sed -e 's/#.*$//' | grep cm-13.0 | awk '{printf "lineage_%s-%s\n", $1, $2}')
do
    add_lunch_combo $combo
done

while read -r file; do
    project="$(dirname ${file} | sed 's|vendor/cm/patch/||g')"
    bugid="$(grep '^Bug: ' ${file})"
    while read -r line; do
        if [ "$(git -C ${project} log --grep "${line}")" ]; then
            continue
        fi

        git -C "${project}" am -q "$(pwd)/${file}"

        if [ $? = 0 ]; then
            echo "${project}: ${file} succeeded to apply"
        else
            git -C "${project}" am -q "$(pwd)/${file}" || git -C "${project}" am --abort
            echo "${project}: ${file} failed to apply"
        fi

        break
    done <<< "${bugid}"
done <<< "$(find vendor/cm/patch -type f)"
unset project
unset bugid
