#!/bin/bash

# ================================= TODO LIST =================================
# - Search for a better option than $PWD when doing ln
# - Having sudo calls
# - Script to login to google for drive etc (pop up)
# - Install icloud
# - Warn in case using root as user (home will not work)
# - Add install all
# - Add install package
# - ln flag
# - wallpaper dir depends on distro
# - checking with -e will tell if file/dir exists but we want to let the user
# - know if it is something not correct
# - functions per install? More readable

# =============================== HANDLE FLAGS ================================
usage() {
    # SCRIPT USAGE MESSAGE
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo " -h, --help       Display this help message"
    echo " -v, --verbose    Enable verbose mode"
    echo " -Y               Attempt to install all without asking for confirmation"
    echo " -l, --list       List the options to be installed (separated by coma)"
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
                verbose_mode=true
                ;;

            -Y)
                install_all=true
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

            *)
                echo "Invalid option: $1" >&2
                usage
                exit 1
                ;;
        esac
        shift
    done
}

# ================================= CONSTANTS =================================
tabs="    "
#VIM_CONFIGURATION_DIRECTORY="$HOME/.config/nvim"
#VIM_RC_FILE="init.vim"
NVIM_CONFIG_DIR="$HOME/.config/nvim"

MERGE_SCRIPT_MSG="To compare and merge configuration files use TODO script\n"

# Verbose debug
printf "\$HOME: $HOME\n"

# ================================= FUNCTIONS =================================
# TODO not working
system_install() {
    # TODO different options according to package system
    sudo apt install -y $@
}

pip_system_install() {
    # TODO: warning about possibly breaking the system
    sudo pip3 install $1 --break-system-packages
}

start_section() {
    # TODO error handling: no arguments
    n=$(((80-${#1}-2)/2))
    printf "\n\n"
    printf "=%.s" $(eval "echo {1.."$(($n))"}")
    printf " $1 "
    if test $((${#1} % 2)) -ne 0; then
        n=$(($n+1))
    fi
    printf "=%.s" $(eval "echo {1.."$(($n))"}")
    printf "\n"
}

set_config() {
    # TODO error handling: no arguments
    # TODO check file exists
    if [ $symbolic_links == 1 ]; then
        printf "Creating symbolic link $2->$2...\n"
        ln -s $1 $2
    else
        printf "Copying configuration $1 to $2...\n"
        cp -r $1 $2
    fi
}

# =============================================================================
#                                 MAIN EXECUTION
# =============================================================================

# =========================== DISTRO DETECTION VARS ===========================
WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# =========================== INSTALL CONFIGURATION ===========================
handle_flags "$@"

#read -p "Do you wish to utilize symbolic links for better version control? [Y/n]" confirm
confirm="y"
if [[ $confirm == "" || $confirm == [yY] ]]; then
    symbolic_links=1
else
    symbolic_links=0
fi


# ============================= SCRIPTS AND TOOLS =============================
# TODO:
# sudo apt-get update

# git
if ! git --version &> /dev/null; then
    printf "Installing git...\n"
    system_install git
fi

# curl
if ! curl --version &> /dev/null; then
    printf "Installing curl...\n"
    system_install curl      
fi

# python
if ! python3 --version &> /dev/null; then
    printf "Installing python3...\n"
    system_install python3    
fi

# ----------------------------------- ZSH -------------------------------------
if ! zsh --version &> /dev/null; then
    read -p "Do you wish to install and use zsh as default shell? [Y/n] " confirm
    if [[ $confirm == "" || $confirm == [yY] ]]; then
        start_section "ZSH"

        printf "Installing zsh...\n"
        system_install zsh

        printf "Working with `zsh --version`\n"
        if ! [ $SHELL == `which zsh` ]; then
            printf "$USER Not using zsh\n"
#            sudo chsh -s $(which zsh) $USER # TODO: using sudo
        fi
    fi
else
    printf "zsh installation found! "
    zsh --version
    # TODO: Ask if u want to update zsh profile to use this one
    # TODO: Compare zsh profile to the current configuration
fi

# ---------------------------------- KITTY ------------------------------------
if ! kitty --version &> /dev/null; then
    read -p "Do you wish to install kitty terminal? [Y/n] " confirm
    if [[ $confirm == "" || $confirm == [yY] ]]; then
        start_section "Kitty"
        printf "${tabs}Installing kitty....\n"
        system_install kitty

        printf "${tabs}Setting kitty's configuration file...\n"
        set_config $PWD/kitty $HOME/.config/kitty
    fi
else
    printf "Kitty installation found! "
    kitty --version
    # TODO: Check if a configuration already exists
        # TODO: Ask if we want to override/merge/ignore the configuration
    # TODO: else - ask if we want to set the configuration
fi

# --------------------------------- NVIM/VIM -----------------------------------
if ! nvim --version &> /dev/null; then
    read -p "Do you wish to install neovim? [Y/n] " confirm
    if [[ $confirm == "" || $confirm == [yY] ]]; then
        using_nvim=true
        start_section "NVIM"
        # TODO: install nvim

        read -p "Do you wish to set up this nvim configuration? [Y/n] " confirm
        if [[ $confirm == "" || $confirm == [yY] ]]; then
            set_config $PWD/nvim $HOME/.config/nvim
        fi
    else
        using_nvim=false
    fi
else
    printf "Nvim installation found! "
    nvim --version
    using_nvim=true
    # TODO: check if there is a configuration
        # TODO: Ask if we want to override/merge/ignore the configuration
    # TODO: else - ask if we want to set this configuration
    read -p "Do you wish to set up this nvim configuration? [Y/n] " confirm
    if [[ $confirm == "" || $confirm == [yY] ]]; then
        set_config $PWD/nvim $HOME/.config/nvim
    fi
fi

# TODO: currently not working
#if [[ !$(vim --version &> /dev/null) && !$using_nvim ]]; then
#    read -p "Do you wish to install vim? [Y/n] " confirm
#    if [[ $confirm == "" || $confirm == [yY] ]]; then
#        start_section "VIM"
#        # TODO: install vim
#
#        read -p "Do you wish to setup this vim configuration [Y/n] " confirm
#        if ! [ -f $HOME/.config/vim/autoload/plug.vim ]; then
#            printf "${tabs}Installing Plug in manager...\n"
#            curl -flo $HOME/.config/vim/autoload/plug.vim --create-dirs \
#                    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
#            set_config $PWD/vim/init.vim $HOME/.config/vim/.
#            # TODO: run plug install
#        fi
#    fi
#else
#    printf "Vim installation found! "
#    vim --version
#    # TODO: check if there is a configuration
#        # TODO: Ask if we want to override/merge/ignore the configuration
#    # TODO: else - ask if we want to set this configuration
#fi

# --------------------------------- Z SCRIPT ----------------------------------
if [ -f $HOME/.local/bin/z.sh ]; then
    printf "Z script installation found!\n"
else
    read -p "Do you wish to install z script? [Y/n] " confirm
    if [[ $confirm == "" || $confirm == [yY] ]]; then
        start_section "Z SCRIPT"
        wget "https://raw.githubusercontent.com/rupa/z/master/z.sh" \
            -O $HOME/.local/bin/z.sh
    fi
fi

# ----------------------------------- GIT -------------------------------------
read -p "Do you wish to append git aliases? [Y/n] " confirm
if [[ $confirm == "" || $confirm == [yY] ]]; then
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

# ================================ AESTHETICS =================================

# ---------------------------------- FONTS ------------------------------------
# TODO: curl install Proto Nerd Fonts https://www.nerdfonts.com/font-downloads
# ~/.local/share/fonts

# ------------------------------ POWERLINE ------------------------------------
# TODO: currently not working
#if ! powerline-status --version &> /dev/null; then
#    read -p "Do you wish to install powerline? [Y/n] " confirm
#    if [[ $confirm == "" || $confirm == [yY] ]]; then
#        start_section "POWERLINE"
#
#        # Check installation TODO: depends on package per distribution
#            # TODO: depends on system
#        #pip3 install powerline-status
#
#        # Add config files
#        # TODO powerline config according to shell (zsh has right)
#        set_config $PWD/powerline $HOME/.config/powerline
#    fi
#else
#    printf "Powerline installation found! "
#    powerline-status --version
#    # TODO: check if there is a configuration
#        # TODO: Ask if we want to override/merge/ignore the configuration
#    # TODO: else - ask if we want to set this configuration
#fi

# ------------------------------ Wallpapers -----------------------------------
# TODO: currently not working
#if [ -e $WALLPAPER_DIR ]; then
#    read -p "Do you wish to update the wallpapers directory with saved wallpapers? [Y/n] " confirm
#    if [[ $confirm == "" || $confirm == [yY] ]]; then
#        start_section "WALLPAPERS"
#        set_config $PWD/resource/images/wallpapers $WALLPAPER_DIR
#    fi
#
#        # TODO use google drive instead of github
#        # TODO
#else
#    printf "Found wallpaper directory at $WALLPAPER_DIR\n"
##    read -p "Do you wish to update wallpaper options? [Y/n] " confirm
#    # TODO: update wallpapers
#fi

# ---------------------------------- PYWAL ------------------------------------
# TODO: Check python3 configuration
if ! wal -v &> /dev/null; then
    # TODO SHELL returns error when saying no
    read -p "Do you wish to install pywall? [Y/n] " confirm &&\
        [[ $confirm == "" || $confirm == [yY] ]] && \
            pip_system_install pywal
else
    printf "Pywal installation found! "
    wal -v
fi
# TODO Check if pywal and then link to wallpaper
# TODO pywal on startup

# ------------------------------- FONTAWESOME ---------------------------------
# TODO: Node install in the beginning?
# TODO: Check if fontawesome is installed
if true; then
    if ! node -v &> /dev/null; then
        read -p "yarn requires npm. Do you wish to install npm? [Y/n]" confirm &&\
        [[ $confirm == "" || $confirm == [yY] ]] && \
            system_install node
    fi
    read -p "Do you wish to install pywall? [Y/n] " confirm &&\
        [[ $confirm == "" || $confirm == [yY] ]] && \
            pip_system_install pywal
else
    printf "Pywal installation found! "
    wal -v
fi
# TODO Check if pywal and then link to wallpaper
# TODO pywal on startup
