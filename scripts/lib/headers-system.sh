# =========================================================================
# This is the headers file of common functions that are used across the
# different installation scripts focused on the obtaining definitions of
# the system.
# Return errors will be handled in the 10-19 range
# =========================================================================

# ========================== SYSTEM CHECKS ================================
detect_system() {
    case $(uname -s) in
        Darwin)
            slog "Operating system: macOS"
            echo "macOS"
            return 0
            ;;
        Linux)
            slog "Operating system: Linux"

            # Identify desktop environment
            if [ -n "$XDG_CURRENT_DESKTOP" ]; then
                slog "Desktop Environment: $XDG_CURRENT_DESKTOP"
                echo "$XDG_CURRENT_DESKTOP"
            elif [ -n "$DESKTOP_SESSION" ]; then
                slog "Desktop Environment: $DESKTOP_SESSION"
                echo "$DESKTOP_SESSION"
            else
                slog "Could not detect a Desktop Environment"
                slog "Treating Desktop Environment as SSH"
            fi

            return 0
            ;;
        *)
            slog_error "Could not identify Operating System"
            return 11
            ;;
    esac
    return 11
}

# ======================= INSTALL PROCEDURES =============================

# system_install [package] [* arguments]
# Function to call the instalation of a package by automatically checking
# which system is currently in use
system_install() {
    # Check if there is a custom overwrite for that installation
    case $1 in
        *)
            slog "No installation overwrite found for $1. Using default pkg manager"
        ;;
    esac

    case $PGR_PKGMANAGER in
        brew)
            shadow brew install $@
            if test $? -ne 0; then
                slog_error "Installation of package $1 failed!"
            fi
        ;;

        pacman)
            shadow pacman install $@ # This is probably wrong
        ;;

        apt)
            shadow apt install -y $@
        ;;
    esac
}

pip_user_install() {
    sudo pip3 install --user --break-system-packages $1
}

pip_system_install() {
    # TODO: warning about possibly breaking the system
    sudo apt-get install python3-$1
    if [ $? != 0 ]; then
        if [[ $force_install = true ]]; then
            confirm="Y"
        else
            read -p "Do you wish to force install $1? [y/N] " confirm
        fi

        if [[ $confirm == [yY] ]]; then
            sudo pip3 install $1 --break-system-packages
        fi
    fi
}

set_config() {
    # TODO error handling: no arguments
    # TODO check file exists
    if [ $symbolic_links == 1 ]; then
        slog "Creating symbolic link $2->$2..."
        ln -s $1 $2
    else
        slog "Copying configuration $1 to $2..."
        cp -r $1 $2
    fi
}

# ======================= INSTALLATIONS =============================

