for combo in $(curl -s https://raw.githubusercontent.com/LineageOS/hudson/master/cm-build-targets | sed -e 's/#.*$//' | grep cm-13.0 | awk '{printf "cm_%s-%s\n", $1, $2}')
do
    add_lunch_combo $combo
done
