#!/usr/bin/env bash

# Windows (Git Bash/MSYS) needs this for symlinks
[[ "$(uname -s)" == *MINGW* ]] && export MSYS=winsymlinks:nativestrict

DIR=$(cd "$(dirname "$0")" && pwd)
link() { 
    ln --symbolic --force --verbose "$DIR/$1" "$2" 
}

# bash
link bash/bashrc ~/.bashrc
link bash/inputrc ~/.inputrc
link bash/prompt.sh ~/.prompt.sh
link lesskey ~/.lesskey

# git
link git/git-amend.sh ~/.git-amend.sh
link git/gitattributes ~/.gitattributes
link git/gitconfig ~/.gitconfig

# vim
mkdir -p ~/.vim
link vim/plugins.vim ~/.vim/plugins.vim
link vim/vimrc ~/.vimrc
link idea/ideavimrc ~/.ideavimrc

# rime
mkdir -p "${APPDATA}/Rime"
link Rime/custom_phrase.txt "${APPDATA}/Rime/custom_phrase.txt"
link Rime/default.custom.yaml "${APPDATA}/Rime/default.custom.yaml"
link Rime/rime_ice.custom.yaml "${APPDATA}/Rime/rime_ice.custom.yaml"
link Rime/weasel.custom.yaml "${APPDATA}/Rime/weasel.custom.yaml"

# tmux
link tmux.conf ~/.tmux.conf
