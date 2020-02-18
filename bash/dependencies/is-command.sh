#! /bin/bash

BASH_DIR="${HOME}"/scripts/bash/

#dependencies/package-man.sh is sourced in brew-install-dep
source "${BASH_DIR}"/dependencies/brew-install-dep.sh

is-command-then-install() {
    #boolean for checking if we need to install commands
    HAVE_DEPENDENCIES=false
    #echo satifying deps if needed
    for i in "${@}"
    do
        if ! command -v "${i}" > /dev/null 2>&1
        then
            HAVE_DEPENDENCIES=true
        fi
    done
    #echo satisfying deps if needed
    $HAVE_DEPENDENCIES && \
    echo -e "${SATISFYING_DEPS}"
    #install deps if command is not found
    for i in "${@}"
    do
        brew_install "${i}"
    done
    #echo deps satisfied if needed
    $HAVE_DEPENDENCIES && \
    echo -e "${DEPS_SATISFIED}"
}

is-library-then-install() {
#boolean for checking if we need to install commands
    HAVE_DEPENDENCIES=false
    #echo satifying deps if needed
    for i in "${@}"
    do
        if ! $PACSEARCH | grep "${i}" > /dev/null 2>&1
        then
            HAVE_DEPENDENCIES=true
        fi
    done
    #echo satisfying deps if needed
    $HAVE_DEPENDENCIES && \
    echo -e "${SATISFYING_LIBS}"
    #install deps if command is not found
    for i in "${@}"
    do
        lib_install "${i}"
    done
    #echo deps satisfied if needed
    $HAVE_DEPENDENCIES && \
    echo -e "${LIBS_SATISFIED}"
}
