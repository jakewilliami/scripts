#! /bin/bash

if ! brew ls --versions jq > /dev/null
then
    echo -e "\001b[1;38mInstalling \`jq\`...\u001b[0;38m" && \
    brew install jq && \
    echo -e "\u001b[1;38;5;2m\`jq\` installed successfully\u001b[0;38m"
fi