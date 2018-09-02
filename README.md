# random-groups
A bash script for creating random groups of Virginia Tech students for class activities

# Usage

First, download a CSV summary class record from Hokie Spa. Then run the script with the location of that CSV file as the first argument and the number of random groups as the second:

$ ./random-groups.sh location/of/file.csv num_groups

Default output goes to stdout. Output is a tab-seperated numbered list of students with line breaks and headings for each group. This script uses awk and tr to process the CSV file and gshuf for randomness. You can install gshuf using Homebrew. It does not come with Mac OSX.

This is a basic script. There is very limited input validation.

# Logic

Simply using a modulo to iterate over a student list can result in a group with one student or a group that is much smaller than other groups. Logic is incorporated into the script to make groups that are of comprable sizes regardless of the situation.

The script will create groups of the same size if the number of students and number of groups permit. If there is a remainder, the script will attempt to create two smaller groups with one fewer student than in the larger groups. If this is not possible, it will create two smaller groups: one with one fewer student than in the larger groups and one with two fewer students.
