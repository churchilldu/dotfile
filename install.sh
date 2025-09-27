#!/usr/bin/env bash

BASEDIR=$(cd "$(dirname "$0")" && pwd)

# Check if the script is running on Windows (using MSYS or Git Bash)
if [[ "$(uname -s)" == *MINGW* ]]; then
    echo "Running on Windows. Setting MSYS environment variable."
    export MSYS=winsymlinks:nativestrict
fi

# Default values
FORCE_MODE=false
INSTALL_ALL=false
SHOW_HELP=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--force)
            FORCE_MODE=true
            shift
            ;;
        -a|--all)
            INSTALL_ALL=true
            shift
            ;;
        -h|--help)
            SHOW_HELP=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Show help and exit
if [ "$SHOW_HELP" = true ]; then
    echo "Dotfile Installer"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -f, --force    Force overwrite existing files"
    echo "  -a, --all      Install all modules without prompting"
    echo "  -h, --help     Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                 # Interactive mode"
    echo "  $0 -a              # Install all modules"
    echo "  $0 -f -a           # Force install all modules"
    echo "  $0 --force         # Interactive mode with force overwrite"
    exit 0
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

# Module definitions: name="source_dir:destination_dir:dot_prefix"
# dot_prefix: true=add dot to filenames, false=keep original names
declare -A MODULES=(
    ["bash"]="bash:$HOME:true"
    ["git"]="git:$HOME:true"
    ["vim"]="vim:$HOME:true"
    ["rime"]="Rime:${APPDATA}/Rime:false"
    ["idea"]="idea:$HOME:true"
)

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
            if [ "$FORCE_MODE" = true ]; then
                rm -rf "$dest"
                echo "🔧 [force] removed existing: $dest"
            else
                skip "$dest points to $current_target (wanted $src)"
                return 0
            fi
        fi
    fi

    if [ -e "$dest" ]; then
        if [ "$FORCE_MODE" = true ]; then
            rm -rf "$dest"
            echo "🔧 [force] removed existing: $dest"
        else
            skip "exists: $dest"
            return 0
        fi
    fi

    ln -s "$src" "$dest"
    link "$dest -> $src"
}

# Install a module by linking all files from source to destination
install_module() {
    local module_name="$1"
    local module_config="${MODULES[$module_name]}"
    
    if [ -z "$module_config" ]; then
        warn "Unknown module: $module_name"
        return 1
    fi
    
    # Parse module config: source_dir:destination_dir:dot_prefix
    IFS=':' read -r source_dir dest_dir dot_prefix <<< "$module_config"
    
    # Build source path
    source_path="$BASEDIR/$source_dir"
    
    # Check if source directory exists
    if [ ! -d "$source_path" ]; then
        skip "Module directory not found: $source_path"
        return 0
    fi
    
    # Create destination directory if it doesn't exist
    mkdir -p "$dest_dir"
    
    # Find and link all files in the source directory
    while IFS= read -r -d '' file; do
        # Get relative path from source directory
        rel_path="${file#$source_path/}"
        
        # Determine destination filename
        if [ "$dot_prefix" = "true" ]; then
            # Add dot prefix to top-level files only
            if [[ "$rel_path" != */* ]]; then
                dest_name=".$rel_path"
            else
                dest_name="$rel_path"
            fi
        else
            dest_name="$rel_path"
        fi
        
        dest_file="$dest_dir/$dest_name"
        
        # Create parent directories if needed
        mkdir -p "$(dirname "$dest_file")"
        
        # Link the file
        soft_link "$file" "$dest_file"
        
    done < <(find "$source_path" -type f -print0)
}


# Handle --all flag
if [ "$INSTALL_ALL" = true ]; then
    selected_modules=()
    for module in "${!MODULES[@]}"; do
        selected_modules+=("$module")
    done
    echo "Installing all modules..."
else
    # Generate dynamic menu from module definitions
    echo "Select components to install (multiple allowed, separated by spaces or commas):"
    echo "  0) all"

    # Create array of module names for indexing
    module_names=()
    i=1
    for module in "${!MODULES[@]}"; do
        echo "  $i) $module"
        module_names+=("$module")
        ((i++))
    done

    printf "Enter selection: "
    IFS= read -r selection

    # Normalize input: split on commas/spaces, lowercase
    normalized_items=()
    for token in $selection; do
        token="${token%,}"
        token_lower=$(echo "$token" | tr '[:upper:]' '[:lower:]')
        normalized_items+=("$token_lower")
    done

    # Process selections
    selected_modules=()
    for item in "${normalized_items[@]}"; do
        case "$item" in
            0|all)
                # Add all modules
                for module in "${!MODULES[@]}"; do
                    selected_modules+=("$module")
                done
                break
                ;;
            *)
                # Check if it's a number
                if [[ "$item" =~ ^[0-9]+$ ]]; then
                    index=$((item - 1))
                    if [ $index -ge 0 ] && [ $index -lt ${#module_names[@]} ]; then
                        selected_modules+=("${module_names[$index]}")
                    else
                        warn "Invalid number: $item"
                    fi
                else
                    # Check if it's a valid module name
                    if [ -n "${MODULES[$item]}" ]; then
                        selected_modules+=("$item")
                    else
                        warn "Unknown module: $item"
                    fi
                fi
                ;;
        esac
    done

    if [ ${#selected_modules[@]} -eq 0 ]; then
        echo "Nothing selected. Exiting."
        exit 0
    fi
fi

# Install selected modules
for module in "${selected_modules[@]}"; do
    echo "Installing module: $module"
    install_module "$module"
done

read -p "Done. Press enter to exit..."
