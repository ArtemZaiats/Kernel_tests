#!/bin/bash

usage="The script that finds ppid of all parent processes of the given process.

Use find_ppid.sh <arg>
Where <arg>:
		<pid> 	PID of a process. Must be a number
		--help  call help
 "

pid=$1
ppid=0
err='^[0-9]+$'

check_input() {

	if [ -z $pid ]; then
		echo "Missing argument, please enter process ID, or call --help"
		exit
	else 
		if [ "$pid" = "--help" ]; then
			printf "$usage"
			exit
		else 
			if ! [[ "$pid" =~ $err ]]; then
				echo "Invalid input $pid. Please call --help."
				exit
			fi
		fi
	fi
}

print_ppid() {

	check_input

	while [ $pid -ne 0 ]; do
	if [ "$(ps -p $pid | grep $pid)" != "" ]; then
		ppid=$(ps -o ppid= $pid)
		echo "$ppid"
		pid=$ppid
	else
		echo "Process with PID $pid is not running"
		exit
	fi
	done
}

print_ppid