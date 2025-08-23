#!/usr/bin/env bash

BASEDIR=$(dirname $0)

# Check if the script is running on Windows (using MSYS or Git Bash)
if [[ "$(uname -s)" == *MINGW* ]]; then
    echo "Running on Windows. Setting MSYS environment variable."
    export MSYS=winsymlinks:nativestrict
fi


cd $BASEDIR
ln -s ${PWD}/bashrc ~/.bashrc
ln -s ${PWD}/inputrc ~/.inputrc
ln -s ${PWD}/gitconfig ~/.gitconfig
ln -s ${PWD}/vimrc ~/.vimrc
ln -s ${PWD}/ideavimrc ~/.ideavimrc
ln -s ${PWD}/gitattributes ~/.gitattributes
ln -s ${PWD}/sh/git-amend.sh ~/.git-amend.sh

RIMEDIR=Rime
RIMEDATAFOLDER="$APPDATA/Rime"
cd $BASEDIR/$RIMEDIR
ln -s "${PWD}/default.custom.yaml" "$RIMEDATAFOLDER/default.custom.yaml"
ln -s "${PWD}/weasel.custom.yaml" "$RIMEDATAFOLDER/weasel.custom.yaml"
ln -s "${PWD}/rime_ice.custom.yaml" "$RIMEDATAFOLDER/rime_ice.custom.yaml"
ln -s "${PWD}/custom_phrase.txt" "$RIMEDATAFOLDER/custom_phrase.txt"

read -p "Press enter to continue..."
