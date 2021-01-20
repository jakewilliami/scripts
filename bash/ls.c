#!/usr/bin/env bash

trap "exit" INT

# define bash directory
BASH_DIR="$(realpath "$(dirname "$0")")"
GIT_LOCATION="$(realpath "$(dirname "${BASH_DIR}")")"
CDIR="${GIT_LOCATION}/c/"
COMPILEDIR="${CDIR}/compiled/"

# source required scripts
source ${BASH_DIR}/dependencies/source-dependencies.sh

display_help() { #Displays help
    help_start 'ls.c [-h] [<dir name> | <dirname> <n>] [-d <dirname> <int> | -d <int>]' 'Pretty print the contents of the current --- and <d>-many sub --- -directories.  Defaults to current directory, and depth = 3.'
    help_commands '-d' '--depth' '1' 'Pretty lists with a specified' 'd' 'epth' '(int).'
    help_help '2'
    clean-exit
}

if [[ $(uname -s) == "Darwin" ]]; then
    SYSDIR="Darwin"
elif [[ $(uname -s) == "Linux" ]]; then
    SYSDIR="Linux"
elif [[ $(uname -s) == "FreeBSD" ]]; then
    SYSDIR="BSD"
else
    echo "Warning: Unknown operating system, or Windows."
    SYSDIR="$(uname -s)"
    mkdir -p "${COMPILEDIR}/${SYSDIR}"
fi

if [[ $(uname -m) =~ ^.*64$ ]]; then
    ARCH="64"
elif [[ $(uname -m) =~ ^.*32$ ]]; then
    ARCH="32"
else
    echo "Warning: Unknown system architecture"
    ARCH="$(uname -m)"
    mkdir -p "${COMPILEDIR}/${SYSDER}/${ARCH}/ls.o"
fi

LS_FUNC="${COMPILEDIR}/${SYSDIR}/${ARCH}/ls.o"

ls_dir_with_n() {
    # checks to see if first argument begins with a minus (i.e., is an option) as we cannot assess $OPTIND before options are called
    # if [[ "${1}" =~ ^\-.+ ]]; then
    if [[ -z "${3}" ]]; then
    	# then they have not given a directory name, so we default to current
        "${LS_FUNC}" . "${2}"
        clean-exit
    else
    	"${LS_FUNC}" "${2}" "${3}"
        clean-exit
    fi
}

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.
# Options
while getopts ":-:hd" OPTION
do
    case $OPTION in
            -)  #Long options for bash (without GNU)
                case $OPTARG in
                    help)
                        display_help ;;
                    depth)
                        ls_dir_with_n "${@}" ;;
                    *)
                        opt_err ;;
                esac ;;
            h)
                display_help ;;
            d)
                ls_dir_with_n "${@}" ;;
            *)
                opt_err ;;
    esac
done
shift $((OPTIND-1))
[ "${1:-}" = "--" ] && shift

# default function for no options passed
if [[ $OPTIND -eq 1 ]]; then
    if [[ -z "${1}" ]]; then
        "${LS_FUNC}" . 3
        clean-exit
    else
        "${LS_FUNC}" "${1}" 3
        clean-exit
    fi
fi
