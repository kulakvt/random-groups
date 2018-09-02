#!/bin/bash

# random-groups.sh by Andrew Kulak
# v1.1 Sun Sep  2 18:35:02 EDT 2018
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
	class_arr=($(cat $1 | awk -F, '{ print $5, $4}' | tr -d '"' | gshuf))
	
	# Restore IFS for expected future functionality
	IFS=$SAVEIFS

	# Begin main script
	num_students=${#class_arr[@]}
	students_per_group=$(($num_students/$2))

	# Checks to make sure input will work
	if [ $(($num_students / $2)) -gt "1" ] ; then
		grouped_students=()
		for i in `seq 0 $(($num_students - 1))` ; do
			current_group=$(($i % $2))
			grouped_students[current_group]="${grouped_students[current_group]}${class_arr[$i]},"
		done
		for j in `seq 0 $(($2 - 1))` ; do
			echo Group $((j + 1))
			echo ${grouped_students[$j]} | tr , '\n'
		done

	# Output for user if too many groups are entered
	else
		echo Not enough students to divide into $2 groups
	fi

# Handles situation where proper arguments are not provided
else
	echo Arguments missing
	echo $0 location/of/file.csv num_groups
fi
