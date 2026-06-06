#!/bin/bash

# ================================= TODO LIST =================================
# REFACTORS
# - Search for a better option than $PWD when doing ln
# - If I do a header file, and I call a variable that could is defined until
#   later; would it read it?
#
# FEATURES
# - File with which configurations were installed + current pulled version
#   + last version the script was run on
#     - Idea is to have a script that can tell you if you should run the script
#       again
# - Add install all
# - Add install specific package
# - How to manage sudos?
#
# TOOLS?
# - Automatic backups
#     - maybe rsync?
#     - Script to login to google for drive etc (pop up)
#     - Install icloud?
#     - Script to keep updating the folders
#
# BUGS
# - Warn in case using root as user (home will not work)
# - wallpaper dir depends on distro
# - checking with -e will tell if file/dir exists but we want to let the user
# know if it is something not correct
# =============================================================================

# ---------------------------- IMPORT HEADERS ---------------------------------
source ./scripts/lib/headers-logs.sh # TODO! Change not to be relative path!
source ./scripts/lib/headers-system.sh # TODO! Change not to be relative path!

# --------------------------------- CONSTANTS ---------------------------------
MERGE_SCRIPT_MSG="To compare and merge configuration files use TODO script\n"
MANIFEST_PATH="./install-manifest.yaml"

# --------------------------------- DEFAULTS ----------------------------------
symbolic_links=true

# =============================================================================
#                            GENERAL USE FUNCTIONS                             
# This section contains a general categorization set of functions that is used
# within the script
# This section will return the error code: 2
# =============================================================================

# ----------------------------- USER INTERACTION ------------------------------

# confirm [Request message]
# Function aimed to integrate with an if condition, which ask for approval to
# the user before continuing
confirm() {
    if [[ $PGR_YESALL == true ]]; then
        return 1
    fi

    read -p "$1 [Y/n] " confirm
    [[ $confirm == "" || $confirm == [yY]  || $confirm == "yes" ]]
}

# select_option [available option]+
# Function aimed to integrate with an case condition, which asks the user to
# select a function from a list.
# The default option will be the first argument received.
select_option() {
    if [ $? -lt 2 ]; then
        slog_error ""
        return 1
    fi
}

# ------------------------------- HANDLE FLAGS --------------------------------
usage() {
    # SCRIPT USAGE MESSAGE
    echo "Usage: $0 [Flags]"
    echo "Flags:"
    echo " -h, --help       Display this help message"
    echo " -v, --verbose    Enable verbose mode"
    echo " -Y               Attempt to install all without asking for confirmation. Will use defaults"
    echo " -l, --list       List the options to be installed (separated by coma)"
    echo " -s, --shadow     Does not run any authorative command. Only logs it."
}

has_argument() {
    [[ ("$1" == *=* && -n ${1#*=}) || ( ! -z "$2" && "$2" != -*) ]];
}

extract_argument() {
    echo "${2:-${1#*=}}"
}

handle_flags(){
    while [ $# -gt 0 ]; do
        case $1 in
            -h | --help)
                usage
                exit 0
                ;;

            -v | --verbose)
                slog "Verbose mode is on"
                verbose_mode=true
                ;;

            -Y | -y)
                slog_warn "Installing all packages and default options"
                install_all=true
                ;;

            -f)
                slog_warn "Forcing installations as indicated of flag -f"
                force_install=true
                ;;

            -c | --no-symbolic-links)
                slog_warn "Copying configuration files instead of adding symbolic links"
                symbolic_links=false
                ;;

            -l)
                # Check second argument
                if ! has_argument $@; then
                        echo "No list given." >&2
                        usage
                        exit 2
                fi
                list=$(extract_argument $@)
                ;;

            -S | --shadow)
                slog_warn "Shadow mode is enabled!"
                shadow_mode=true
                ;;

            -c | --copy-only)
                slog_warn "Copy only set. Will not create soft link to configurations!"
                SYM_LINKS=true
                ;;
            *)
                slog_error "Invalid option: $1"
                usage
                exit 1
                ;;
        esac
        shift
    done
}

# =============================================================================
#                           INSTALLATION OVERWRITTES
# This sections contains all the custom installation functions of applications
# or tooling that cannot be installed directly with a specific package manager.
# This section will return the error code: 3
# =============================================================================
installation_env_setup() {
    slog_debug "installation_env_setup $@"
    case $OS in
        macOS)
            macos_installation_env_setup
        ;;
        *)
            slog_error "A installation overwrite wrapper for $os does not exist!"
        ;;
    esac
}

installation_wrapper() {
    slog_debug "installation_wrapper $@"

    if command -v $1 &> /dev/null; then
        slog "Installation found for $1"
        return 0
    fi

    # Check if there is an installation overwrite in relation to an OS
    slog_debug "Using detected os $OS"
    case $OS in
        macOS)
            macos_installation_wrapper $@
        ;;
        *)
            slog_error "A installation overwrite wrapper for $os does not exist!"
        ;;
    esac
}

# ---------------------------------- macOS -------------------------------------
macos_installation_env_setup() {
    slog_debug "macos_installation_env_setup $@"

    # Install brew if it doesn't exist
    if ! command -v brew &> /dev/null; then
        slog_warn "brew installation not found!"
        if confirm "brew installation is required. Should it be installed?"; then
            macos_install_brew
        fi
    fi

    echo "brew"
    return 0
}

macos_installation_wrapper() {
    slog_debug "macos_installation_wrapper $@"

    case $1 in
        *)
            slog_debug "Did not find any installation overwrite for pkg $1"
            shadow brew install $@
            return 0
        ;;
    esac
    slog_debug "macos_installation_wrapper error: I...don't know how I got here"
    exit 3
}

macos_install_brew() {
    slog "Installing brew with custom installation"
    /bin/bash -c \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh) NONINTERACTIVE"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh) NONINTERACTIVE"

    if test $? -ne 0; then
        slog_error "Failed to install brew!"
        exit 3
    fi

    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
    return 0
}

# -------------------------------- hyprland -----------------------------------

# =============================================================================
#                               MAIN EXECUTION
# This section will return the error code: 1
# =============================================================================

# ----------------------------- DETECTING ENV ---------------------------------
handle_flags "$@"

# Save detected os
OS=$(detect_system)
slog_debug "Detected OS system: $OS"

# Determine pkg managers available
pkg_mgr=$(macos_installation_env_setup)
slog_debug "Package managers available (in order): $pkg_mgr"

# ----------------- INSTALL REQUIRED TOOLS FOR THIS SCRIPT --------------------
installation_wrapper yq

# --------------------------- INSTALL MANIFEST --------------------------------
cat_len=$(yq '. | length' "$MANIFEST_PATH")
slog_debug "Parsed $cat_len categories in manifest"
for i in $(seq 0 $((cat_len - 1))); do
    category=$(yq ".[$i]" $MANIFEST_PATH)
    start_log_section $(echo "$category" | yq ".category")
    slog_debug "Category yaml: \n$category"

    pkg_len=$(echo "$category" | yq '.packages | length')
    slog_debug "Found $pkg_len packages to iterate"
    for j in $(seq 0 $((pkg_len - 1))); do
        if command -v "$(echo '$category' | yq )" &> /dev/null; then
            slog "Package $name already installed... Skipping"
            continue
        fi

        slog "Package: $name, Command to install: $cmd"
        shadow $pkg_cmd
    done < <(echo "$pkgs")
done

exit 0

# ----------------------------------- ZSH -------------------------------------
# Shell installation
#if ! zsh --version &> /dev/null; then
#    read -p "Do you wish to install and use zsh as default shell? [Y/n] " confirm
#    if [[ $confirm == "" || $confirm == [yY] ]]; then
#        start_section "ZSH"
#
#        printf "Installing zsh...\n"
#        system_install zsh
#
#        printf "Working with `zsh --version`\n"
#        if ! [ $SHELL == `which zsh` ]; then
#            printf "$USER Not using zsh\n"
##            sudo chsh -s $(which zsh) $USER # TODO: using sudo
#        fi
#
#        end_section
#    fi
#else
#    printf "zsh installation found! "
#    zsh --version
#    # TODO: Ask if u want to update zsh profile to use this one
#    # TODO: Compare zsh profile to the current configuration
#fi

# ---------------------------------- TERMINAL -----------------------------------
# Do not show iterm option if not macos
if [[ $PGR_SYSTEM == "macOS" ]]; then
    PGR_OPTIONS="[ghostty] | kitty | iterm2 | none"
else
    PGR_OPTIONS="[ghostty] | kitty | none"
fi

read -p "Which terminal do you wish to install?" confirm
case $confirm in
    ghostty)
        start_section "Ghostty"
        slog "Installing Ghostty..."
        system_install ghostty

        slog "Setting Ghossty configuration files..."
        set_config $PWD/ghostty $HOME/.config/ghostty

        end_section
        ;;
    kitty)
        start_section "Kitty"
        slog "Installing kitty...."
        system_install kitty

        slog "Setting kitty's configuration file..."
        set_config $PWD/kitty $HOME/.config/kitty

        end_section
        ;;
    iterm2)
        if [[ $PGR_SYSTEM == "macOS" ]]; then
            slog_warn "Skipping installation of a terminal..."
        fi

        start_section "iterm2"
        slog "Installing iterm2..."
        system_install iterm2

        slog "Setting iterm's configuration files..."
        set_config $PWD/iterm2 $HOME/.config/iterm2
        ;;
    *)
        slog_warn "Skipping installation of a terminal..."
        ;;
esac

# --------------------------------- NVIM/VIM -----------------------------------
if ! command -z nvim &> /dev/null; then
    if confirm "Do you wish to install neovim?"; then
        start_section "NVIM"
        slog "Installing neovim"
        system_install neovim
        end_section
    fi
else
    slog "nvim installation found! Neovim version: $(nvim --version)"
fi

if [[ command -z nvim &> /dev/null && confirm "Do you want peter's nvim config?" ]]; then
    slog "Setting neovim config folder"
    set_config $PWD/nvim $HOME/.config/nvim
fi

# --------------------------------- Z SCRIPT ----------------------------------
if [ ! -f $HOME/.local/bin/z.sh ]; then
    if confirm "Do you wish to install z script"; then
        start_section "Z SCRIPT"
        wget "https://raw.githubusercontent.com/rupa/z/master/z.sh" \
            -O $HOME/.local/bin/z.sh
        end_section
    fi
else
    slog "Z script installation found!\n"
fi

# ----------------------------------- RCs -------------------------------------
# TODO: rc comparison!
if confirm "Do you wish to append git aliases?"; then
    if [ -f $HOME/.gitconfig ]; then
        echo "Appending to $HOME/.gitconfig..."
        # TODO: merge config
#        cat $PWD/config/gitconfig >> $HOME/.gitconfig
    elif [ -e $HOME/.gitconfig ]; then
        echo "$HOME/.gitconfig file exists but make sure it is a file!"
    else
        echo "Creating $HOME/.gitconfig file..."
        set_config $PWD/config/gitconfig $HOME/.gitconfig
    fi
fi

# --------------------------------- CLAUDE ------------------------------------
# Install Claude
if ! command -v claude &> /dev/null; then
    slog "claude installation not found."
    adsf
    read -p "Do you wish to install claude? [Y/n] " confirm

    if [[ $confirm == "" || $confirm == [
else
    slog "claude installation found! Claude version: $(claude --version)"
fi

# Install Claude Code
if ! command -v claude-code &> /dev/null; then
    slog "claude-code installation not found."
    read -p "Do you wish to install claude-code? [Y/n] " confirm
else
    slog "claude-code installation found!"
fi

if [[ $confirm == "" || $confirm == [yY] ]]; then
    system_install claude-code
fi


# Install Setup
# TODO: compare global claude configuration?

# ================================ AESTHETICS =================================

# ---------------------------------- FONTS ------------------------------------
# TODO: curl install Proto Nerd Fonts https://www.nerdfonts.com/font-downloads
# ~/.local/share/fonts
# TODO: refresh fonts
# fc-cache -fv
# TODO: check font installation
# fc-list | grep "Proto Nerd Font" | wc -l

# ------------------------------ POWERLINE ------------------------------------
# TODO: currently not working
if ! powerline-daemon --version &> /dev/null; then
    read -p "Do you wish to install powerline? [Y/n] " confirm
    if [[ $confirm == "" || $confirm == [yY] ]]; then
        start_section "POWERLINE"

        # Check installation TODO: depends on package per distribution
            # TODO: depends on system
#        pip_user_install powerline-status
        system_install powerline

        # Add config files
        # TODO powerline config according to shell (zsh has right)
        # TODO merge powerline config?
        if powerline-daemon --version &> /dev/null; then
            # TODO: Only works on debian
            system_install fonts-powerline
            set_config $PWD/powerline $HOME/.config/powerline

            # TODO: setting lines in bashrc
        else
            printf "Error when installing powerline-status!\n"
        fi

        end_section
    fi
else
    printf "Powerline installation found! "
    powerline-status --version
    # TODO: check if there is a configuration
        # TODO: Ask if we want to override/merge/ignore the configuration
    # TODO: else - ask if we want to set this configuration
fi

# ------------------------------ WALLPAPERS -----------------------------------
# TODO: currently not working
read -p "Do you wish to update the wallpapers directory with saved wallpapers? [Y/n] " confirm
if [[ $confirm == "" || $confirm == [yY] ]]; then
    start_section "WALLPAPERS"
    # TODO use google drive instead of github
    if [ ! -e $WALLPAPER_DIR ]; then
        mkdir -p $WALLPAPER_DIR
    else
        printf "Found wallpaper directory at $WALLPAPER_DIR\n"
    fi
    set_config $PWD/resource/images/wallpapers $WALLPAPER_DIR
    end_section
fi

# ---------------------------------- PYWAL ------------------------------------
# TODO: Check python3 configuration
if ! wal -v &> /dev/null; then
    # TODO SHELL returns error when saying no
    read -p "Do you wish to install pywall? [Y/n] " confirm &&\
        [[ $confirm == "" || $confirm == [yY] ]] && \
            pip_system_install pywal

    read -p "Do you wish to install colorthief backend? [Y/n] " confirm
    if [[ $confirm == "" || $confirm == [yY] ]]; then
        pip_system_install colorthief
    else
        system_install imagemagick
    fi

    # run pywal on current wallpaper
    # TODO: currently runs on gnome but add options for other
    wal -i $(gsettings get org.gnome.desktop.background picture-uri | awk '{sub(/file:\/\//, ""); print}') --backend colorthief

    # TODO pywal on startup
else
    printf "Pywal installation found! "
    wal -v
fi

# ------------------------------- FONTAWESOME ---------------------------------
# TODO: LOOKS LIKE FONT AWESOME NOW COSTS TO DOWNLOAD FFS
# TODO: Node install in the beginning?
# TODO: Check if fontawesome is installed
#if true; then
#    read -p "Do you wish to install FontAwesome fonts? [Y/n] " confirm
#    if [[ $confirm == "" || $confirm == [yY] ]]; then
#        if ! node -v &> /dev/null; then
#            read -p "yarn requires npm. Do you wish to install npm? [Y/n]" confirm &&\
#            [[ $confirm == "" || $confirm == [yY] ]] && \
#                system_install node
#        fi
#        if ! yarn --version &> /dev/null; then
#            read -p "yarn requires npm. Do you wish to install npm? [Y/n]" confirm &&\
#            [[ $confirm == "" || $confirm == [yY] ]] && \
#                system_install node
#        fi
#    fi
#else
#    printf "FontAwesome font installation found! "
#fi
