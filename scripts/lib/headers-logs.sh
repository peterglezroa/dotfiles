# =========================================================================
# This is the headers file of common functions that are used across the
# different installation scripts focused on logging relevant information
# during the script execution.
# =========================================================================

# ============================= LOGGING ===================================
RED="\033[0;31m"
BOLDRED="\033[1;31m"
YELLOW="\033[0;33m"
BOLDYELLOW="\033[0;33m"
GREEN="\033[0;32m"
BOLDGREEN="\033[1;32m"
BLUE="\033[0;34m"
BOLDBLUE="\033[1;34m"
MAGENTA="\033[0;35m"
BOLDMAGENTA="\033[1;35m"
CYAN="\033[0;36m"
BOLDCYAN="\033[1;36m"
NC="\033[0m"

# Why is it named slog? Because I didn't want to overwrite the log command
slog() {
    printf "[INFO] [$(date +"%H:%M:%S")] $@\n" >&2
}

slog_debug() {
    printf "[${BOLDCYAN}DEBUG${NC}] [$(date +"%H:%M:%S")] $@\n" >&2
}

slog_warn() {
    printf "[${BOLDYELLOW}WARN${NC}] [$(date +"%H:%M:%S")] $@\n" >&2
}

slog_error() {
    printf "[${BOLDRED}ERROR${NC}] [$(date +"%H:%M:%S")] $@\n" >&2
}

slog_command() {
    printf "[${BOLDBLUE}CMD${NC}] [$(date +"%H:%M:%S")] $@\n" >&2
}

slog_reference() {
    log "${BLUE}$@${NC}\n" >&2
}

start_log_section() {
    title="$@"

    # TODO error handling: no arguments
    n=$(((80-${#title}-2)/2))
    printf "\n\n"
    printf "=%.s" $(eval "echo {1.."$(($n))"}")
    printf " $title "
    if test $((${#title} % 2)) -ne 0; then
        n=$(($n+1))
    fi
    printf "=%.s" $(eval "echo {1.."$(($n))"}")
    printf "\n"
}

end_log_section() {
    printf "\n"
    printf "=%.s" {1..79}
    printf "\n\n"
}

# ============================= SHADOW ====================================
# shadow [command] [* arguments]
# Function meant to add a layer for authorative calls. This is for testing
# purposes, since when the variable PGR_SHADOW is active (1), it will skip
# calling those calls and simply print the command for debugging.
shadow() {
    # Check number of arguments

    if [[ ! -z $PGR_SHADOW && $PGR_SHADOW -eq 1 ]]; then
        slog_command $@
    fi
    $@
}

