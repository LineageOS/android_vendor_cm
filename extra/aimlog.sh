#!/bin/bash
# Simple sh to automatic generate a file with source and device specif git commit changes to use in a github wiki pages or file.md
# like this:
# https://github.com/bhb27/android_vendor_crdroid/blob/change_temp/Changelog.md
# file.md can work with more data or have more lines then a page wiki
# input variables set the below the rest must be automatic
# Specify colors utilized in the terminal
    red=$(tput setaf 1)             #  red
    grn=$(tput setaf 2)             #  green
    ylw=$(tput setaf 3)             #  yellow
    blu=$(tput setaf 4)             #  blue
    ppl=$(tput setaf 5)             #  purple
    cya=$(tput setaf 6)             #  cyan
    txtbld=$(tput bold)             #  Bold
    bldred=${txtbld}$(tput setaf 1) #  red
    bldgrn=${txtbld}$(tput setaf 2) #  green
    bldylw=${txtbld}$(tput setaf 3) #  yellow
    bldblu=${txtbld}$(tput setaf 4) #  blue
    bldppl=${txtbld}$(tput setaf 5) #  purple
    bldcya=${txtbld}$(tput setaf 6) #  cyan
    txtrst=$(tput sgr0)             #  Reset
    rev=$(tput rev)                 #  Reverse color
    pplrev=${rev}$(tput setaf 5)
    cyarev=${rev}$(tput setaf 6)
    ylwrev=${rev}$(tput setaf 3)
    blurev=${rev}$(tput setaf 4)
    normal='tput sgr0'

source_tree="${ANDROID_BUILD_TOP}"; #path here must be inside home directory
changelog_path_name=vendor/aim/CHANGELOG.mkdn #changelog file path/name.extension
source_name="AIM ROM" #Name to display in changelog.md top before version
# input variables end

export Changelog=$source_tree/$changelog_path_name
export Temp_Changelog=$source_tree/$changelog_path_name.temp

if [ -f $Changelog ];
 then
 	rm -f $Changelog
fi
 
touch $Changelog


# ask for days and version
echo ""
echo ${grn}" -> Set Number Of Days For Changelog"${txtrst}
echo ""
echo -e ${red}"You Have 30/s To Pick Or Else, 6 Days By Default"${txtrst}
echo -e "";
echo -e ${grn}"  Enter How Many Days"${txtrst}
echo -e "";
# use 'export days_to_log=5' before '. build/envsetup.sh' were 5 is days to log
if [ -z $days_to_log ];then
read -r -t 30 days_to_log || days_to_log=7
fi
echo >> $Changelog;
echo " (->) $source_name Ver 1.0 Changelog"    >> $Changelog;
echo " ====================================== "  >> $Changelog;
echo '' >> $Changelog;
echo >> $Changelog;

cd $source_tree

for i in $(seq $days_to_log);
do
export After_Date=`date --date="$i days ago" +%m/%d/%Y`
k=$(expr $i - 1)
	export Until_Date=`date --date="$k days ago" +%m/%d/%Y`
    echo ""	
	echo ${ylw}" 〉 Generating day number $i ▪ $Until_Date.."${txtrst}
	source=$(repo forall -pc 'git log --oneline --after=$After_Date --until=$Until_Date');

	if [ -n "${source##+([:space:])}" ]; then

		echo " [*] $Until_Date" >> $Changelog;
		echo "  *******************    "  >> $Changelog;
                echo '' >> $Changelog;
		repo forall -pc 'git log --oneline --after=$After_Date --until=$Until_Date' | sed 's/^$/#EL /' | sed 's/^/ ▪ /' | sed 's/ ▪ #EL //' >> $Changelog
		echo >> $Changelog;
	fi

done

sed -i 's/* Project /[*] /g' $Changelog
echo "---------------------------------------------------------" >> $Changelog;
echo '' >> $Changelog;
Changelog=$source_tree/$changelog_path_name
if [ -f $Changelog ] && [ -f $Temp_Changelog ];
then
	echo "$(cat $Temp_Changelog)\n$(cat $Changelog)" > $Changelog
	rm -f $Temp_Changelog
fi

echo -e ${grn}"\n AIM ROM Changelogs have been succesfully generated.\n"${txtrst}
