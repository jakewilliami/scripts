#! /bin/bash

BASH_DIR="${HOME}/scripts/bash/"

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
    # Get perl update https://stackoverflow.com/questions/3727795/how-do-i-update-all-my-cpan-modules-to-their-latest-versions
    # Satisfy Dependencies
    brew_install "${SATISFYING_DEPS}" p7zip && \
    echo -e "${DEPS_SATISFIED}"
fi

# Help
display_help() {
    echo -e "${BWHITE}Usage: [sudo] clean [option...]${NORM}"
    echo
    echo -e "${ITWHITE}The present script will download a list of all redditors for you to scrape and search through.${NORM}"
    echo
    echo -e "${BBLUE}\t -d | --download \t\t${BYELLOW}${ULINE}${BBLUE}D${BYELLOW}ownload${NORM}${BYELLOW}s, extracts, and writes to text a list of all Redditors.${NORM}"
    echo -e "${BBLUE}\t -h | --help \t\t${BYELLOW}Shows ${ULINE}${BBLUE}h${BYELLOW}elp${NORM} ${BYELLOW}(present output).${NORM}"
    clean-exit
}


download_redditors() {
    BIG_LINE=$(seq -s= $(tput cols) | tr -d '[:digit:]')
    echo -e "${ITYELLOW}Downloading Redditors List${NORM}"
    cd ${HOME}/Downloads/
    curl https://files.pushshift.io/reddit/69M_reddit_accounts.csv.gz > ./69M_reddit_accounts.csv.gz
    echo
    echo -e "${BWHITE}${BIG_LINE}${NORM}"
    echo -e "${ITYELLOW}Extracting the Redditors CSV${NORM}"
    7z e 69M_reddit_accounts.csv.gz
    echo
    echo -e "${BWHITE}${BIG_LINE}${NORM}"
    echo -e "${ITYELLOW}Simplifying CSV to plain text${NORM}"
    while read -r line; do echo ${line} | awk -F[,] '{print $2}'; done < ./69M_reddit_accounts.csv > ${HOME}/Desktop/reddit-accounts.txt
    echo
    echo -e "${BWHITE}${BIG_LINE}${NORM}"
    echo -e "${ITYELLOW}File of all Redditors written to a text file on your desktop${NORM}"
}



# Options
while getopts ":-:hd" OPTION; do
        case $OPTION in
                -)
                    case $OPTARG in
                        download)
                            download_redditors ;;
                        help)
                            display_help ;;
                        *)
                            opt_err ;;
                    esac ;;
                d)
                    download_redditors ;;
                h)
                    display_help ;;
                *)
                    opt_err ;;
        esac
done