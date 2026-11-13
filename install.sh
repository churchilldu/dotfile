#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")" && pwd)

# shared symlink helper
source "$DIR/link.sh"

# bash
link bash/bashrc ~/.bashrc
link bash/inputrc ~/.inputrc
link bash/prompt.sh ~/.prompt.sh
link bash/completions ~/.bash_completion.d

link lesskey ~/.lesskey

command -v rg &>/dev/null && rg --generate complete-bash > "~/.bash_completion.d/rg.bash"
command -v fd &>/dev/null && fd --gen-completions bash > "~/.bash_completion.d/fd.bash"


# git
link git/git-amend.sh ~/.git-amend.sh
link git/gitattributes ~/.gitattributes
link git/gitconfig ~/.gitconfig

# vim
mkdir -p ~/.vim
link vim/vimrc ~/.vimrc
link vim/plugins.vim ~/.vim/plugins.vim
link vim/plugin ~/.vim/plugin.d
## ideavim
command -v idea idea64 &>/dev/null && link idea/ideavimrc ~/.ideavimrc

# rime 
if [[ "$(uname --kernel-name)" == *MINGW* || "$(uname --kernel-name)" == *MSYS* || "$(uname --kernel-name)" == *CYGWIN* ]]; then
    mkdir -p "${APPDATA}/Rime"
    link Rime/custom_phrase.txt "${APPDATA}/Rime/custom_phrase.txt"
    link Rime/default.custom.yaml "${APPDATA}/Rime/default.custom.yaml"
    link Rime/rime_ice.custom.yaml "${APPDATA}/Rime/rime_ice.custom.yaml"
    link Rime/weasel.custom.yaml "${APPDATA}/Rime/weasel.custom.yaml"
fi

# tmux
link tmux.conf ~/.tmux.conf
## psmux
command -v psmux && link psmux.conf ~/.psmux.conf

