#! /bin/bash

# Get package manager
source "${HOME}"/scripts/bash/dependencies/package-man.sh

#Define jq package for system
JQ="jq"

# Ensure jq is installed
if ! command -v jq > /dev/null 2>&1
then
    echo -e "\u001b[1;38mInstalling \`jq\`...\u001b[0;38m" && \
    $PACMAN "${JQ}" && \
    echo -e "\u001b[1;38;5;2m\`jq\` installed successfully\u001b[0;38m" 
fi

# get colours
source "${BASH_DIR}"/colours/json-colour-parser.sh
