#!/bin/bash

# random-groups.sh by Andrew Kulak
# v1.0 Sun Sep  2 15:31:18 EDT 2018
# This script generates random groups of students for activities
# Argument 1: path to a Virginia Tech Hokie Spa student list CSV
# Argument 2: Number of groups
# Tested on Mac OS X, 10.11.6, 15G1421 GNU bash, version 3.2.57(1)
# Requires: gshuf, awk

if [ "$2" != "" ] ; then
	
	# Save current IFS
	SAVEIFS=$IFS
	
	# Change IFS to new line in order to import student list to array 
	IFS=$'\n'
	arr=($(cat $1 | awk -F, '{ print $5, $4}' | tr -d '"' | gshuf))
	
	# Restore IFS for expected future functionality
	IFS=$SAVEIFS

	# Begin main script
	num_students=${#arr[@]}
	students_per_group=$(($num_students/$2))

	# Handling for classes that break evenly into groups
	if [ $(($num_students % $2)) == "0" ] ; then
		group_size=$(($num_students / $2))
		current_group=1
		for i in `seq 0 $(($num_students - 1))` ; do
			if [ $(($i % $group_size)) == "0" ] ; then
				echo -e '\t'Group $current_group
				current_group=$(($current_group + 1)) 
			fi
			echo -e $(($i + 1))'\t'${arr[$i]}
			if [ $(($i % $group_size)) == $(($group_size - 1)) ] ; then
				echo
			fi
		done

	# Handling for classes that do not break evenly into groups
	else
		group_size=$(($num_students / $2 + 1))
		current_group=1
		full_groups=$(($2 - 2))
		grouped_students=$(($full_groups * $group_size))

		# Begins by forming as many larger groups as possible
		for i in `seq 0 $(($grouped_students - 1))` ; do
			if [ $(($i % $group_size)) == "0" ] ; then
				echo -e '\t'Group $current_group
				current_group=$(($current_group + 1)) 
			fi
			echo -e $(($i + 1))'\t'${arr[$i]}
			if [ $(($i % $group_size)) == $(($group_size - 1)) ] ; then
				echo
			fi
		done
		smaller_group_size=$(($group_size - 1))
		
		# If even number of remaining students, breaks into two same sized groups
		if [ $(($grouped_students  % 2)) == "0" ] ; then
			for i in `seq 0 $((($smaller_group_size * 2) - 1))` ; do
				if [ $(($i % $smaller_group_size)) == "0" ] ; then
					echo -e '\t'Group $current_group
					current_group=$(($current_group + 1)) 
				fi
				echo -e $(($i + $grouped_students + 1))'\t'${arr[$(($i + $grouped_students))]}
				if [ $(($i % $smaller_group_size)) == $(($smaller_group_size - 1)) ] ; then
					echo
				fi
			done

		# If odd number of remaining students, forms one larger and one smaller group
		else
			for i in `seq 0 $((($smaller_group_size * 2) - 2))` ; do
				if [ $(($i % $smaller_group_size)) == "0" ] ; then
					echo -e '\t'Group $current_group
					current_group=$(($current_group + 1)) 
				fi
				echo -e $(($i + $grouped_students + 1))'\t'${arr[$(($i + $grouped_students))]}
				if [ $(($i % $smaller_group_size)) == $(($smaller_group_size - 1)) ] ; then
					echo
				fi
			done
			echo
		fi
	fi

# Handles situation where proper arguments are not provided
else
	echo Arguments missing
	echo $0 path/to/file.csv num_groups
fi
