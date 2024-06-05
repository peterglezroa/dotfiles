#!/bin/bash

# ================================= TODO LIST =================================
# - Search for a better option than $PWD when doing ln
# - Having sudo calls
# - Script to login to google for drive etc (pop up)
# - Warn in case using root as user (home will not work)
# - Add install all
# - Add install package
# - ln flag
# - wallpaper dir depends on distro
# - checking with -e will tell if file/dir exists but we want to let the user
#   know if it is something not correct

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

# ================================= FUNCTIONS =================================
# TODO not working
function system_install {
	# TODO different options according to package system
	sudo apt install -y $@
}

function start_section {
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

# ================================= CONSTANTS =================================
#VIM_CONFIGURATION_DIRECTORY="$HOME/.config/nvim"
#VIM_RC_FILE="init.vim"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
NVIM_RC_FILE="init.vim"

MERGE_SCRIPT_MSG="To compare and merge configuration files use TODO script\n"

# Verbose debug
printf "\$HOME: $HOME\n"

# =============================================================================
#                               MAIN EXECUTION
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
# TODO
# sudo apt-get update

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
read -p "Do you wish to install and use zsh as default shell? [Y/n] " confirm
if [[ $confirm == "" || $confirm == [yY] ]]; then
    start_section "ZSH"
    if ! zsh --version &> /dev/null; then
        printf "Installing zsh...\n"
        system_install zsh
    fi
    printf "Working with `zsh --version`\n"
    if ! [ $SHELL == `which zsh` ]; then
        printf "$USER Not using zsh\n"
        sudo chsh -s $(which zsh) $USER #TODO
    fi
fi

# ---------------------------------- KITTY ------------------------------------
#read -p "Do you wish to install kitty? [Y/n] " confirm && \
#    [[ $confirm == "" || $confirm == [yY] ]] && \
#    system_install kitty

# ----------------------------------- NVIM ------------------------------------
# set neovim or vim configuration file and install plugins
read -p "Do you wish to install neovim and its plugins? [Y/n] " confirm
if [[ $confirm == "" || $confirm == [yY] ]]; then
    start_section "NVIM"

	# Check installation
	if ! vim --version &> /dev/null; then
		printf "No installation of vim or neovim found! Installing...\n"
		# TODO: depends on system
	fi

	vimversion=$(vim --version | head -1)
	printf "Vim version found: $vimversion\n"
	case `echo $vimversion | awk '{print $1;}'` in
		"NVIM")
			# Copy rcfile
			if ! [ -d $NVIM_CONFIG_DIR ]; then
				printf "Configuration folder could not be found. Creating it...\n"
				mkdir $HOME/.config/nvim
			fi
			if [ -f $NVIM_CONFIG_DIR/$NVIM_RC_FILE ]; then
				printf "File $HOME/.config/nvim/init.vim already exists!\n$MERGE_SCRIPT_MSG"
            elif [ $symbolic_links ]; then
				printf "Creating symbolic link to configuration file..."
				ln -s $PWD/config/init.vim $HOME/.config/nvim/.
            else
                asdf
			fi

			# Install Plugin Manager
			if ! [ -f $HOME/.local/share/nvim/site/autoload/plug.vim ]; then
				printf "Installing Plug in manager...\n"
				curl -flo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
					https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
			fi
			printf "Installing Plugins...\n"
			vim +'PlugInstall --sync' +qa
			if [ $? == 0 ]; then
				printf "Installation successful!\n\n"
			else
				printf "Error occurred. Check installation!\n\n"
			fi
		;;
		"VIM")
			printf "VIM\n"
		;;
	esac
fi

# --------------------------------- Z SCRIPT ----------------------------------
if [ -f $HOME/.local/bin/z.sh ]; then
    printf "Z script installation found!\n"
else
    read -p "Do you wish to install z script? [Y/n] " confirm
    if [[ $confirm == "" || $confirm == [yY] ]]; then
        start_section "Z SCRIPT"
        wget "https://raw.githubusercontent.com/rupa/z/master/z.sh" -O $HOME/.local/bin/z.sh
    fi
fi


# ================================ AESTHETICS =================================

# ------------------------------ POWERLINE ------------------------------------
read -p "Do you wish to install powerline? [Y/n] " confirm
if [[ $confirm == "" || $confirm == [yY] ]]; then
    start_section "POWERLINE"

	# Check installation TODO: depends on package per distribution
	if powerline-status --version &> /dev/null; then
		printf "Powerline installation found!\n"
		# TODO: depends on system
    else
        printf "Installing Powerline using pip...\n"
        #pip3 install powerline-status
	fi

    # Check fonts
    # TODO

    # Add config files
    # TODO powerline config according to shell (zsh has right)
    if [ -e $HOME/.config/powerline/ ]; then
        printf "Powerline configuration folder found at $HOME/.config/powerline!\n$MERGE_SCRIPT_MSG"
    elif [ $symbolic_links ]; then
        printf "Creating symbolic link to configuration folder..."
        ln -s $PWD/powerline $HOME/.config/powerline
    else
        printf "Coping configuration folder..."
        cp -r $PWD/powerline $HOME/.config/powerline
    fi
fi

# ---------------------------------- PYWAL ------------------------------------
if wal -v &> /dev/null; then
    printf "Pywal installation found!\n"
else
    # TODO SHELL returns error when saying no
    read -p "Do you wish to install pywall? [Y/n] " confirm &&\
    [[ $confirm == "" || $confirm == [yY] ]] && \
    sudo pip3 install pywal
fi

# ------------------------------ Wallpapers -----------------------------------
read -p "Do you wish to update the wallpapers directory with saved wallpapers? [Y/n] " confirm
if [[ $confirm == "" || $confirm == [yY] ]]; then
    start_section "WALLPAPERS"
    # TODO use google drive instead of github
    if [ -e $WALLPAPER_DIR ]; then
        printf "Found wallpaper directory at $WALLPAPER_DIR\n"
        read -p "Do you wish to update wallpaper options? [Y/n] " confirm
        #if [[ $confirm == "" || $confirm == [yY] ]]; then
            # TODO
        #fi
    elif [ $symbolic_links  ]; then
        printf "Creating symbolic link to wallpaper directory...\n"
        ln -s $PWD/resources/images/wallpapers $WALLPAPER_DIR
    else
        printf "Coping wallpaper directory...\n"
        cp -r $PWD/resources/images/wallpapers $WALLPAPER_DIR
    fi

    # TODO Check if pywal and then link to wallpaper
    # TODO pywal on startup

    printf "\n\n"
fi

# ------------------------------ GNOME CORNERS --------------------------------
