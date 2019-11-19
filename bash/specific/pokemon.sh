#! /bin/bash

BASH_DIR="${HOME}/scripts/bash/"
TRASH_SHARED_DIR="${HOME}/Library/Mobile Documents/com~apple~CloudDocs/.Trash/"
TRASH_LOCAL_DIR="${HOME}/.Trash/"
TRASH_ROOT_DIR="/private/var/root/.Trash/"
DOWNLOADS_DIR="${HOME}/Downloads/"

if [[ $(hostname) == "jake-mbp2017.local" ]] && [[ $(whoami) == "jakeireland" ]]
then
    # Colours
    source ${BASH_DIR}/colours/json-colour-parser.sh
else
    # Ensure jq is installed
    source ${BASH_DIR}/dependencies/jq-dep.sh && \
    source ${BASH_DIR}/colours/json-colour-parser.sh
fi

if [[ $(hostname) == 'jake-mbp2017.local' ]] && [[ $(whoami) == 'jakeireland' ]]
then
    :
else
    # Brew Install function
    source ${BASH_DIR}/dependencies/brew-install-dep.sh
    # Satisfy Dependencies
    brew_install "${SATISFYING_DEPS}" youtube-dl && \
    echo -e "${DEPS_SATISFIED}"
fi

# Help
display_help() {
    echo -e "${BWHITE}Usage: pokemon.sh [option...] [season number] [path/to/downloaded/html]${NORM}"
    echo
    echo -e "${ITWHITE}The present scrip requires you to have downloaded the web html. ${NORM}"
    echo
    echo -e "${BBLUE}\t -o | --open \t\t${BYELLOW}${ULINE}${BBLUE}O${BYELLOW}pens${NORM} ${BYELLOW}the webpage given a season number.${NORM}"
    echo -e "${BBLUE}\t -h | --help \t\t${BYELLOW}Shows ${ULINE}${BBLUE}h${BYELLOW}elp${NORM} ${BYELLOW}(present output).${NORM}"
    echo
    echo -e "${BBLUE}Example:${NORM}"
    echo -e "\`pokemon.sh -o 21\`"
    echo -e "[download html as pokemon-adventures.html]"
    echo -e "\`pokemon.sh 21 ~/Desktop/pokemon-adventures.html\`"
    clean-exit
}


open_url() {
    open "https://www.pokemon.com/us/pokemon-episodes/pokemon-tv-seasons/season-${1}/"
}


# Options
while getopts ":-:oh" OPTION; do
        case $OPTION in
                -)
                    case $OPTARG in
                        help)
                            display_help ;;
                        open)
                            open_url ${2} ;;
                        *)
                            opt_err ;;
                    esac ;;
                o)
                    open_url ${2} ;;
                h)
                    display_help ;;
                *)
                    opt_err ;;
        esac
done


if [[ $OPTIND -eq 1 ]]
then
    mkdir "${HOME}/Desktop/pokemon-s${1}" && \
    cat $2 | \
    egrep "<a href\=\"\/us\/pokemon-episodes" | \
    egrep "[0-9]" | \
    sed -e 's/<a href\=\"\(.*\)\">/\1/' | \
    awk '{$1=$1};1' | \
    sed -e "s/^/https\:\/\/www.pokemon.com/" > "${HOME}/Desktop/pokemon-s${1}/pokemon-s${1}.txt"
    
    cd ${HOME}/Desktop/pokemon-s${1}/ || clean-exit
    
    while IFS= read line
    do
        youtube-dl --ignore-config -f best $line
    done < "${HOME}/Desktop/pokemon-s${1}/pokemon-s${1}.txt"
fi

clean-exit