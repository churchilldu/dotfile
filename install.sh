#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")" && pwd)

# shared symlink helper
source "$DIR/link.sh"

# bash
link bash/bashrc ~/.bashrc
link bash/inputrc ~/.inputrc
link bash/prompt.sh ~/.prompt.sh
link bash/completions ~/.bash_completion.d

# generate tool completions at install time so they always match the
# installed version (the generated .bash files are gitignored).
command -v rg >/dev/null 2>&1 && rg --generate complete-bash > "${HOME}/.bash_completion.d/rg.bash"
command -v fd  >/dev/null 2>&1 && fd --gen-completions bash > "${HOME}/.bash_completion.d/fd.bash"

link lesskey ~/.lesskey

# git
link git/git-amend.sh ~/.git-amend.sh
link git/gitattributes ~/.gitattributes
link git/gitconfig ~/.gitconfig

# vim
mkdir -p ~/.vim
link vim/vimrc ~/.vimrc
link vim/plugins.vim ~/.vim/plugins.vim
link vim/plugin ~/.vim/plugin.d
link idea/ideavimrc ~/.ideavimrc

# rime
mkdir -p "${APPDATA}/Rime"
link Rime/custom_phrase.txt "${APPDATA}/Rime/custom_phrase.txt"
link Rime/default.custom.yaml "${APPDATA}/Rime/default.custom.yaml"
link Rime/rime_ice.custom.yaml "${APPDATA}/Rime/rime_ice.custom.yaml"
link Rime/weasel.custom.yaml "${APPDATA}/Rime/weasel.custom.yaml"

# tmux
link tmux.conf ~/.tmux.conf
link psmux.conf ~/.psmux.conf

