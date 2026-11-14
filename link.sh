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

# --no-dereference / -h: if the destination is already a symlink to a
# directory, replace the symlink itself instead of nesting inside it.
# BSD ln has no long options, so pick the flag set once from the tool itself.
if ln --help 2>/dev/null | grep -q -- --no-dereference; then
    LN_FLAGS=(--symbolic --force --no-dereference --verbose)
else
    LN_FLAGS=(-s -f -h -v)
fi

link() {
    ln "${LN_FLAGS[@]}" "$DIR/$1" "$2"
}
