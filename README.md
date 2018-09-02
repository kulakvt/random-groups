# random-groups
A bash script for creating random groups of Virginia Tech students for class activities

## Usage

First, download a CSV summary class record from Hokie Spa. Then run the script with the location of that CSV file as the first argument and the number of random groups as the second:

$ ./random-groups.sh location/of/file.csv num_groups

Default output goes to stdout. Output is a list of students with line breaks and headings for each group. This script uses awk and tr to process the CSV file and gshuf for randomness. You can install gshuf using Homebrew. It does not come with Mac OSX but is required to randomize the list.

This is a basic script. There is very limited input validation.

## Logic

The script uses an array with an element for each group, delimiting student names in the group using commas. It adds students to groups one at a time until it runs out of names, resulting in an even distribution given the number of students and groups. The current version uses a much more streamlined algorithm and incorporates some additional checks on input than the initial commit.

## Applications

For smaller discussion classes and seminars, you can effectively display the groups in your terminal and project them. For larger classes, you may want to pipe output to a text file and edit as needed for handouts, online sharing, etc.
