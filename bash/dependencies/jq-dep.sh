#! /bin/bash

# get the package manager from which-pacman.sh
getInstallCommands

main() {
    #Define jq package for system
    JQ="jq"

    # Ensure jq is installed
    if ! command -v jq > /dev/null 2>&1
    then
        echo -e "\033[1;38mInstalling \`jq\`...\033[0;38m" && \
        $PACMAN "${JQ}" && \
        echo -e "\033[1;38;5;2m\`jq\` installed successfully\033[0;38m"
    fi
}

# get colours
main
source "${BASH_DIR}"/colours/json-colour-parser.sh
