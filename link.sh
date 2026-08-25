#!/usr/bin/env bash

# Windows (Git Bash/MSYS) needs this for symlinks to work natively
[[ "$(uname -s)" == *MINGW* ]] && export MSYS=winsymlinks:nativestrict

# Shared symlink helper for dotfiles.
#
#   link <source> <destination>
#
# Source paths are relative to this repo directory (DIR). If DIR is not set
# before sourcing this file it is set to this file's directory.
if [[ -z "$DIR" ]]; then
    DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
fi

link() {
    # -n (--no-dereference): if the destination is already a symlink to a
    # directory, replace the symlink itself instead of nesting inside it
    ln --symbolic --force --no-dereference --verbose "$DIR/$1" "$2"
}