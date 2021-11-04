#!/bin/bash

####
#
#   option:: -m --move-origname-file [move origname-file to directory from which it gots it name] [NO ARGUMENT, boolean true/false]
#	option:: -f --fix-directory [check for / at end of inputted filename]
#   option:: -r --renamed-name [name to be used to rename original directory used for origname command] [REQUIRES ARGUMENT]
#   option:: -d --destination [where to move the renamed file/directory; e.g., "move 'Season 01' (renamed from 'Show.Name.S01') to 'Show Name' folder"] [REQUIRES ARGUMENT]
#
#
#	intended use: origname Show.Name.S01-RipTeam -r Season\ 01 -d Show\ Name
#	intended results:
#		(0) {file "input file" --> check if directory AND ends in forward slash "/" -- if so, delete forward slash before proceeding
#		(1) File created called "Show.Name.S01-RipTeam.origname"
#		(2) {-m} "Show.Name.S01-RipTeam.origname" moved to directory from which it got its name
#			[ "Show.Name.S01-RipTeam.origname" --> "Show.Name.S01-RipTeam/Show.Name.S01-RipTeam.origname" ]
#		(3) {-r} Original directory "Show.Name.S01-RipTeam" renamed to "Season 01" {or whatever user wants}
#			[ "Show.Name.S01-RipTeam" --> "Season 01"
#		(4) {-d} Directory of current focus (renamed OR not!) moved to desired destination (if one exists)
#			[ "Show.Name.S01-RipTeam" --> "Show Name/Show.Name.S01-RipTeam"
#			[ "Season 01" --> "Show Name/Season 01"
#
####


# read the options
OPTS=$(getopt -o 'hmr:d:' --long 'help,move-origname-file,renamed-name:,destination:' -- "$@")

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

# echo "$OPTS"
eval "set -- $OPTS"

# initialize variables
opt_bool_MOVE_ORIGNAMEFILE=false # -m
opt_bool_RENAME_NAME=false # -r
opt_string_RENAME_target="" # -r {target}
opt_bool_MOVE_TO_DESTINATION=false # -d
opt_string_DESTINATION_target="" # -d {target}

while true ; do
	case "$1" in
		-h|--help)
			echo "Usage: [message here]" ;
			exit 0 ;;
		-m|--move-origname-file)
			opt_bool_MOVE_ORIGNAMEFILE=true ;
			shift ;;
		-r|--renamed-name)
			opt_bool_RENAME_NAME=true ;
			opt_string_RENAME_target="$2" ;
			shift 2 ;;
		-d|--destination)
			opt_bool_MOVE_TO_DESTINATION=true ;
			opt_string_DESTINATION_target="$2" ;
			shift 2 ;;
		-- ) shift ; break ;;
		* ) break ;;
	esac
done

#echo -e "\nAll variables3:"
#echo "$@"
#echo

working_FILE="$1"

#echo -e "\ngetopt variables:"
#echo "Working file: $working_FILE"
#echo "Move origname file?: $opt_bool_MOVE_ORIGNAMEFILE"
#echo "Rename file?: $opt_bool_RENAME_NAME"
#echo "Rename file name: $opt_string_RENAME_target"
#echo "Destination move?: $opt_bool_MOVE_TO_DESTINATION"
#echo "Destination path: $opt_string_DESTINATION_target"


#take action
# m, r, d

if [[ $working_FILE == *"/" ]]; then #### checks if working_FILE ends in "/"
#	echo "Detected ending forward slash!"
	action_FILE="${working_FILE%?}" #### creates new variable with one character removed from working_FILE
#	echo "Converted $working_FILE to $action_FILE"
else
#	echo "No ending forward slash detected"
	action_FILE="$working_FILE"
fi

origname_FILE="$action_FILE".origname

touch "$origname_FILE" # create .origname file
echo "created $origname_FILE"

if $opt_bool_MOVE_ORIGNAMEFILE ; then
#	echo "Moving origname file"
	mv -v "$origname_FILE" ./"$action_FILE"
	# action_FILE.origname --> action_FILE/action_FILE.origname
fi

if $opt_bool_RENAME_NAME ; then
#	echo "Renaming original file"
	mv -v "$action_FILE" ./"$opt_string_RENAME_target"
	# action_FILE --> opt_string_RENAME_target
	## result: opt_string_RENAME_target/action_FILE.origname
fi

if $opt_bool_MOVE_TO_DESTINATION ; then
#	echo "Moving to final destination"
	mv -v "$opt_string_RENAME_target" "$opt_string_DESTINATION_target"
	# opt_string_RENAME_target/action_FILE.origname -->
	## opt_string_DESTINATION_target/opt_string_RENAME_target/action_FILE.origname
fi
