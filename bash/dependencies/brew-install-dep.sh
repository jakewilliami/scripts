#! /bin/bash

SATISFYING_DEPS="${BWHITE}Satisfying dependencies...${NORM}"
DEPS_SATISFIED="${BGREEN}Dependencies satisfied.${NORM}"
SATISFYING_LIBS="${BWHITE}Satisfying uninstalled but required libraries...${NORM}"
LIBS_SATISFIED="${BGREEN}Dependent libraries installed.${NORM}"
SATISFYING_APPS="${BWHITE}Installing required applications...${NORM}"
APPS_SATISFIED="${BGREEN}Dependent applications installed.${NORM}"
ERROR_OCCURRED="${BRED}It seems an error has occurred in the satiation of your dependencies.  If you are using Arch Linux, there is a chance you may need to manually download the package using the AUR.${NORM}"



brew_install() {
    PACINSTALL=false
    for i in "${@}"; #previously @:2
    do
        if ! command -v "${i}" > /dev/null 2>&1
        then
            echo -e "${ITWHITE}Installing ${1}${NORM}"
            $PACMAN "${i}" && PACINSTALL=true
        fi
    done
    if [ "${PACINSTALL}" == true ]
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
        fi
    done
    if [ "${PACINSTALL}" == true ]
    then
        return 0
    else
        return 1
    fi
}


app_install() {
    PACINSTALL=false
    for i in "${@}"; #previously @:2
    do
        if ! $PACSEARCH | grep "${i}" > /dev/null 2>&1
        then
            echo -e "${ITWHITE}Installing ${1}${NORM}"
            $PACAPP "${i}" && PACINSTALL=true
        fi
    done
    if [ "${PACINSTALL}" = true ]
    then
        return 0
    else
        return 1
    fi
}
