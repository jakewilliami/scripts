#! /bin/bash

BASH_DIR="${HOME}"/scripts/bash/

#dependencies/package-man.sh is sourced in brew-install-dep
source "${BASH_DIR}"/dependencies/brew-install-dep.sh

is-command-then-install() {
    #boolean for checking if we need to install commands
    MISSING_DEPENDENCIES=false
    DEPS_DOWNLOADED=false
    #echo satifying deps if needed
    for i in "${@}"
    do
        if ! command -v "${i}" > /dev/null 2>&1 # if can't find command $i then we have missing
        then
            MISSING_DEPENDENCIES=true
        fi
    done
    #echo satisfying deps if needed
    $MISSING_DEPENDENCIES && \
    echo -e "${SATISFYING_DEPS}"
    #install deps if command is not found
    for i in "${@}"
    do
        if [[ $MISSING_DEPENDENCIES = true ]]
        then
            brew_install "${i}" && \
            DEPS_DOWNLOADED=true
        fi
    done
    #echo deps satisfied if they are
    if [[ $DEPS_DOWNLOADED = true ]]
    then
        echo -e "${DEPS_SATISFIED}"
    else
        [[ $MISSING_DEPENDENCIES = true ]] && \
        echo -e "${ERROR_OCCURRED}"
    fi 
}

is-library-then-install() {
    #boolean for checking if we need to install commands
    MISSING_DEPENDENCIES=false
    DEPS_DOWNLOADED=false
    #echo satifying deps if needed
    for i in "${@}"
    do
        if ! $PACSEARCH | grep "${i}" > /dev/null 2>&1 # if can't find $i installed then we have missing
        then
            MISSING_DEPENDENCIES=true
        fi
    done
    #echo satisfying deps if needed
    $MISSING_DEPENDENCIES && \
    echo -e "${SATISFYING_LIBS}"
    #install deps if command is not found
    for i in "${@}"
    do
        if [[ $MISSING_DEPENDENCIES = true ]]
        then
            lib_install "${i}" && DEPS_DOWNLOADED=true
        fi
    done
    #echo libs satisfied if needed
    if [[ $DEPS_DOWNLOADED = true ]]
    then
        echo -e "${LIBS_SATISFIED}"
    else
        [[ $MISSING_DEPENDENCIES = true ]] && \
        echo -e "${ERROR_OCCURRED}" 
}
