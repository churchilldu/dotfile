#!/usr/bin/env bash

# Yellow color escape code
RED='\033[0;31m'
BROWN='\033[0;33m'
NC='\033[0m' # No Color

while getopts "a" opt
do
	case "$opt" in
		a) git commit --amend --no-edit --all
			exit 0;;
		*) exit 1;;
	esac
done

staged_files=$(git diff --name-only --staged) 

if [[ $? -ne 0 ]]; then
	exit 1
elif [[ -z $staged_files ]]; then
	echo "Nothing to amend, no file added."
	echo -e "${BROWN}hint: Did you mean git amend -a?${NC}"
else
	git commit --amend --no-edit
fi
