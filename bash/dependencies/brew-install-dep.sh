#! /bin/bash

SATISFYING_DEPS="${BWHITE}Satisfying dependencies...${NORM}"
DEPS_SATISFIED="${BGREEN}Dependencies satisfied.${NORM}"
SATISFYING_LIBS="${BWHITE}Satisfying uninstalled but required libraries...${NORM}"
LIBS_SATISFIED="${BGREEN}Dependent libraries installed.${NORM}"
ERROR_OCCURRED="${BRED}It seems an error has occurred in the satiation of your dependencies.${NORM}"



brew_install() {
    PACINSTALL=false
    for i in "${@}"; #previously @:2
    do
        if ! command -v "${i}" > /dev/null 2>&1
        then
            echo -e "${ITWHITE}Installing ${1}${NORM}"
            $PACMAN "${i}" && PACINSTALL=true
        else
            PACINSTALL=true
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
            echo -e "${ITWHITE}Installing ${1}${NORM}"
            $PACMAN "${i}" && PACINSTALL=true
        else
            PACINSTALL=true
        fi
    done
    if [ "${PACINSTALL}" = true ]
    then
        return 0
    else
        return 1
    fi
}
