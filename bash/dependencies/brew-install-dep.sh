#! /bin/bash

SATISFYING_DEPS="${BWHITE}Satisfying dependencies...${NORM}"
DEPS_SATISFIED="${BGREEN}Dependencies satisfied.${NORM}"

brew_install() {
    BREWINSTALL=false
    for i in ${@:2};
    do
        if ! brew ls --versions $i > /dev/null
        then
            BREWINSTALL=true
            echo -e ${1}
            brew install $i
        fi
    done
    if [ "${BREWINSTALL}" = true ]
    then
        return 0
    else
        return 1
    fi
}