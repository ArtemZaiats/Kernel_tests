#!/bin/bash

usage="The script that starts application by it's package name

Use start_app.sh <arg>
Where <arg>:
		<pkg>	package name
		-l 	list of available packages on current device
		-a 	list of packages that can be launch 
		--help	call help
 "

#Script variables
package_name=$1
activity_name=""
filter="android.intent.category.LAUNCHER"
package_list=""


get_package_list() {
	package_list=$(adb shell 'pm list packages -f' | sed -e 's/.*=//' | sort)
}

get_activity_name() {
	activity_name=$(adb shell dumpsys package $package_name | grep -B 5 'LAUNCHER' | grep -oh "$package_name[./a-Z]*")
}

get_runnable_pkg_list() {
	touch tmp_f
	printf "$package_list" > tmp_f
	while IFS= read -r line; do
		arr+=("$line")
	done <tmp_f

	rm -rf tmp_f

	for i in "${arr[@]}"; do
		package_name="$i"
		get_activity_name
		if [ "$activity_name" != "" ]; then
			echo $package_name
		fi
	done
}

check_arg() {
	case $package_name in 
		--help) 
				printf "$usage"
				exit
				;;
		-l)
				get_package_list
				printf "$package_list"
				exit
				;;
		-a)
				get_package_list
				get_runnable_pkg_list
				exit
				;;
		*)
				if [ -z $package_name ]; then
					echo "Missing argument! Please use --help."
					exit
				fi
				;;
	esac
}

check_package() {
	get_package_list
	if [ "$(printf "$package_list" | grep $(echo "$package_name$"))" = "" ]; then
		echo "Wrong package name! 
Package <'$package_name'> not found. Please use --help"
		exit
	fi
}

check_activity() {
	if [ "$activity_name" = "" ]; then
		printf "Activity not found!

		Please use --help
		"
	fi
}


check_arg
check_package

get_activity_name
check_activity

adb shell am start $activity_name
