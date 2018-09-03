#!/bin/bash

# random-groups.sh by Andrew Kulak
# v1.2 Mon Sep  3 14:46:10 EDT 2018
# This script generates random groups of students for activities
# Argument 1: path to a Virginia Tech Hokie Spa student list CSV
# Argument 2: Number of groups
# Tested on Mac OS X, 10.11.6, 15G1421 GNU bash, version 3.2.57(1)
# Uses: gshuf, awk, cat, tr, seq

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

	# Checks to make sure input will work
	if [ $(($num_students / $2)) -gt "1" ] ; then
		grouped_students=()
		current_student=0
		for i in "${class_arr[@]}" ; do
			current_group=$(($current_student % $2))
			grouped_students[current_group]="${grouped_students[current_group]}$i\n"
			current_student=$(($current_student + 1))
		done
		for j in `seq 1 $2` ; do
			grouped_students[$(($j - 1))]="Group $j\n${grouped_students[$(($j - 1))]}"
		done

		# Builds array of individual students ordered into their groups with group headers
		# Use newline characters as field seperator for array
		IFS=$'\n'
		
		# The awk command trims extra whitespace which is important for correct formatting later
		indiv_students=($(echo -e ${grouped_students[@]} | awk '$1=$1'))
		
		# Reset IFS
		IFS=$SAVEIFS

		# Adds individual student numbers for each student
		current_student=0
		current_line=0
		for k in "${indiv_students[@]}" ; do
			if [[ $k != Group*  ]] ; then
				indiv_students[$current_line]="$(($current_student + 1))\t$k"
				current_student=$(($current_student + 1))
				current_line=$(($current_line + 1))
			else
				indiv_students[$current_line]="\t$k"	
				current_line=$(($current_line + 1))
			fi
		done

		# Prints out the groups to stdout
		for l in "${indiv_students[@]}" ; do
			echo -e $l
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
