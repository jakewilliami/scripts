#! /bin/bash

gem_install() {
    # Check dependencies
    if ! gem list --quiet --installed "^${1}$" > /dev/null 2>&1
    then
        echo -e "${BYELLOW} Installing dependencies...${NORM}" && \
        sudo gem install "${1}" && \
        echo -e "${BGREEN}Dependencies successfully installed.${NORM}"
    fi
}
