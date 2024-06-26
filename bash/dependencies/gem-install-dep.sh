#! /bin/bash

gem_install() {
    # Check dependencies
    if ! gem list --quiet --installed "^${1}$" > /dev/null 2>&1
    then
        echo -e "${BYELLOW} Installing dependencies...${NORM}" && \
        for i in "${@}"
        do
            if [[ $OS == "arch" ]]
            then
                gem install "${i}"
            else
                sudo gem install "${i}"
            fi
        done && \
        echo -e "${BGREEN}Dependencies successfully installed.${NORM}"
    fi
}
