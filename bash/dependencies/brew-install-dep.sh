#! /bin/bash

# Get package manager
source "${HOME}"/scripts/bash/dependencies/package-man.sh

SATISFYING_DEPS="${BWHITE}Satisfying dependencies...${NORM}"
DEPS_SATISFIED="${BGREEN}Dependencies satisfied.${NORM}"
SATISFYING_LIBS="${BWHITE}Satisfying uninstalled but required libraries...${NORM}"
LIBS_SATISFIED="${BGREEN}Dependent libraries installed.${NORM}"



brew_install() {
    PACINSTALL=false
    for i in "${@}"; #previously @:2
    do
        if ! command -v "${i}" > /dev/null 2>&1
        then
            PACINSTALL=true
            echo -e "${ITWHITE}Installing ${1}${NORM}"
            $PACMAN "${i}"
        fi
    done
    if [ "${PACINSTALL}" = true ]
    then
        return 0
    else
        return 1
    fi
}

lib_install() {
    PACINSTALL=false
    for i in "${@}"; #previously @:2
    do
        if ! $PACSEARCH | grep "${i}" > /dev/null 2>&1
        then
            PACINSTALL=true
            echo -e "${ITWHITE}Installing ${1}${NORM}"
            $PACMAN "${i}"
        fi
    done
    if [ "${PACINSTALL}" = true ]
    then
        return 0
    else
        return 1
    fi
}
