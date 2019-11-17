#! /bin/bash

# Get package manager
source bash/dependencies/package-man.sh

# Download jq
if [[ -z $(which jq) ]]
then
    echo -e "\u001b[1;38mInstalling \`jq\`...\u001b[0;38m" && \
    $PACMAN jq && \
    echo -e "\u001b[1;38;5;2m\`jq\` installed successfully\u001b[0;38m"
fi