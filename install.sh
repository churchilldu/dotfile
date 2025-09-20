#!/usr/bin/env bash

BASEDIR=$(cd "$(dirname "$0")" && pwd)

# Check if the script is running on Windows (using MSYS or Git Bash)
if [[ "$(uname -s)" == *MINGW* ]]; then
    echo "Running on Windows. Setting MSYS environment variable."
    export MSYS=winsymlinks:nativestrict
fi

# Colors and emoji log helpers
RESET="\033[0m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
RED="\033[31m"
ok()   { echo -e "${GREEN}✅ [ok]${RESET} $*"; }
skip() { echo -e "${YELLOW}⏭️  [skip]${RESET} $*"; }
link() { echo -e "${BLUE}🔗 [link]${RESET} $*"; }
warn() { echo -e "${RED}⚠️  [warn]${RESET} $*"; }

soft_link() {
    src="$1"
    dest="$2"

    if [ ! -e "$src" ]; then
        skip "missing src: $src"
        return 0
    fi

    if [ -L "$dest" ]; then
        current_target=$(readlink "$dest")
        if [ "$current_target" = "$src" ]; then
            ok "exists: $dest -> $src"
            return 0
        else
            skip "$dest points to $current_target (wanted $src)"
            rm -rf "$dest"
            return 0
        fi
    fi

    if [ -e "$dest" ]; then
        skip "exists: $dest"
        return 0
    fi

    ln -s "$src" "$dest"
    link "$dest -> $src"
}

install_bash() {
    cd "$BASEDIR"
    soft_link "${PWD}/bashrc" "$HOME/.bashrc"
    soft_link "${PWD}/inputrc" "$HOME/.inputrc"
    soft_link "${PWD}/ideavimrc" "$HOME/.ideavimrc"
}

install_git() {
    cd "$BASEDIR"
    soft_link "${PWD}/git/gitconfig" "$HOME/.gitconfig"
    soft_link "${PWD}/git/gitattributes" "$HOME/.gitattributes"
    soft_link "${PWD}/sh/git-amend.sh" "$HOME/.git-amend.sh"
}

install_rime() {
    RIMEDIR="$BASEDIR/Rime"
    RIMEDATAFOLDER="${APPDATA}/Rime"
    soft_link "${PWD}/Rime/default.custom.yaml" "$RIMEDATAFOLDER/default.custom.yaml"
    soft_link "${PWD}/Rime/weasel.custom.yaml" "$RIMEDATAFOLDER/weasel.custom.yaml"
    soft_link "${PWD}/Rime/rime_ice.custom.yaml" "$RIMEDATAFOLDER/rime_ice.custom.yaml"
    soft_link "${PWD}/Rime/custom_phrase.txt" "$RIMEDATAFOLDER/custom_phrase.txt"
}

install_vim() {
    soft_link "${PWD}/vim/vimrc" "$HOME/.vimrc"
    soft_link "${PWD}/vim/plugins.vim" "$HOME/.vim/plugins.vim"
}

echo "Select components to install (multiple allowed, separated by spaces or commas):"
echo "  0) all"
echo "  1) bash"
echo "  2) git"
echo "  3) rime"
echo "  4) vim"
printf "Enter selection: "
IFS= read -r selection

# Normalize input: split on commas/spaces, lowercase
normalized_items=()
for token in $selection; do
    token="${token%,}"
    token_lower=$(echo "$token" | tr '[:upper:]' '[:lower:]')
    normalized_items+=("$token_lower")
done

do_bash=0
do_git=0
do_rime=0
do_vim=0

for item in "${normalized_items[@]}"; do
    case "$item" in
        0|all)
            do_bash=1
            do_git=1
            do_rime=1
            do_vim=1
            ;;
        1|bash)
            do_bash=1
            ;;
        2|git)
            do_git=1
            ;;
        3|rime)
            do_rime=1
            ;;
        4|vim)
            do_vim=1
            ;;
        *)
            warn "unknown option: $item"
            ;;
    esac
done

if [ $do_bash -eq 0 ] && [ $do_git -eq 0 ] && [ $do_rime -eq 0 ] && [ $do_vim -eq 0 ]; then
    echo "Nothing selected. Exiting."
    exit 0
fi

[ $do_bash -eq 1 ] && install_bash
[ $do_git -eq 1 ] && install_git
[ $do_rime -eq 1 ] && install_rime
[ $do_vim -eq 1 ] && install_vim

read -p "Done. Press enter to exit..."
