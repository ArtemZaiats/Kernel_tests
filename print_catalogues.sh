#!/bin/bash
usage="The following script prints first 5 catalogues in current or 
in the specified directory.

Use print_catalogues.sh <args>
Where <args>:
		-r 			reverse sort
		[/path/directory/]	path to requested directory
		
or nothing\n"

list="ls -F"
gr="grep "./""
head="head -5"
sort="sort -r"
cnt=$(ls $2 | wc -l) 

if ! [ -d $2 ]; then
	echo "Specified directory doesn't exist"
else
	if [ $cnt -eq 0 ]; then
		echo "Directory is empty"
	else
	case $1 in
		--help) 
			printf "$usage"
			;;
		-r) 
			if [ -z $2 ]; then
				$list | $gr | $head | $sort
			else 
				$list $2 | $gr | $head | $sort
			fi
			;;
		*)
			if [ -z $1 ]; then
				$list | $gr | $head
			else
				echo "Invalid argument of sort. Please use --help"
			fi
			;; 
	esac 
fi
fi


