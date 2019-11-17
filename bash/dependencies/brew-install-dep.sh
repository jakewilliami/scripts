#! /bin/bash

# Get package manager
source bash/dependencies/package-man.sh

SATISFYING_DEPS="${BWHITE}Satisfying dependencies...${NORM}"
DEPS_SATISFIED="${BGREEN}Dependencies satisfied.${NORM}"



brew_install() {
    PACINSTALL=false
    for i in ${@:2};
    do
        if [[ -z $(which ${i}) ]]
        then
            PACINSTALL=true
            echo -e ${1}
            $PACMAN $i
        fi
    done
    if [ "${PACINSTALL}" = true ]
    then
        return 0
    else
        return 1
    fi
}