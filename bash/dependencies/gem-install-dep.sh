#! /bin/bash

gem_install() {
    # Check dependencies
    if ! gem list --silent -i "^${1}$"
    then
        echo -e "${BYELLOW} Installing dependencies...${NORM}" && \
        sudo gem install ${1} && \
        echo -e "${BGREEN}Dependencies successfully installed.${NORM}"
    fi
}
