#! /bin/bash

BASH_DIR="${HOME}/scripts/bash/"


#get clean-exit command
source ${BASH_DIR}/colours/json-colour-parser.sh

help_start() {
    echo -e "${BWHITE}Usage: ${1}${NORM}"
    echo
    echo -e "${ITWHITE}${2}${NORM}"
    echo 
}

help_help() {
    echo -ne "${BBLUE}\t -h | --help"; printf '\t%.0s' $(seq 1 ${1}); echo -e "${BYELLOW}Shows ${ULINE}${BBLUE}h${BYELLOW}elp${NORM}${BYELLOW} (present output).${NORM}"
}

help_commands() {
    echo -ne "${BBLUE}\t ${1} | ${2}"; printf '\t%.0s' $(seq 1 ${3}); echo -e "${BYELLOW}${4} ${ULINE}${BBLUE}${5}${BYELLOW}${6}${NORM}${BYELLOW} ${7}${NORM}"
}

help_examples() {
    echo
    echo -e "${ITWHITE}${1}${NORM}"
}