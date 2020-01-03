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
    echo -e "${BWHITE}Usage: get-redditors.sh [option...]${NORM}"
    echo
    echo -e "${ITWHITE}The present script will download a list of all redditors for you to scrape and search through.${NORM}"
    echo
    echo -e "${BBLUE}\t -e | --extended-find \t${BYELLOW}${ULINE}${BBLUE}e${BYELLOW}xtends${NORM}${BYELLOW} the search complexity using regex (use option 1 then 2).${NORM}"
    echo -e "${BBLUE}\t -d | --download \t${BYELLOW}${ULINE}${BBLUE}D${BYELLOW}ownload${NORM}${BYELLOW}s, extracts, and writes to text a list of all Redditors.${NORM}"
    echo -e "${BBLUE}\t -f | --find \t\t${BYELLOW}${ULINE}${BBLUE}F${BYELLOW}ind${NORM}${BYELLOW} Redditors from csv.${NORM}"
    echo -e "${BBLUE}\t -h | --help \t\t${BYELLOW}Shows ${BYELLOW}${ULINE}${BBLUE}h${BYELLOW}elp${NORM}${BYELLOW} (present output).${NORM}"
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
    7z e -o${HOME}/Desktop ${HOME}/Downloads/69M_reddit_accounts.csv.gz
    echo
    echo -e "${BWHITE}${BIG_LINE}${NORM}"
    echo -e "${ITYELLOW}File of all Redditors written to a CSV file on your desktop${NORM}"
    clean-exit
}

option_two=$2
option_three=$3
find_redditor() {
    if [[ -z $option_two ]]
    then
        echo -e "${BYELLOW}Must parse a search term using this option${NORM}"
        clean-exit
    else
         while read -r line; do grep -i ${option_two} | awk -F[,] '{print $2}'; done < ${HOME}/Desktop/69M_reddit_accounts.csv
    fi
}



find_regex_redditor() {
    if [[ -z $option_two ]]
    then
        echo -e "${BYELLOW}Must parse a search term and then an extended regex form of it${NORM}"
        clean-exit
    else
         while read -r line; do grep -i ${option_two} | awk -F[,] '{print $2}' | egrep -i ${option_three}; done < ${HOME}/Desktop/69M_reddit_accounts.csv
    fi
}


# Options
while getopts ":-:fhd" OPTION; do
        case $OPTION in
                -)
                    case $OPTARG in
                        extended-find)
                            find_regex_redditor 1 2 ;;
                        find)
                            find_redditor 1 ;;
                        download)
                            download_redditors ;;
                        help)
                            display_help ;;
                        *)
                            opt_err ;;
                    esac ;;
                e)
                    find_regex_redditor 1 2 ;;
                f)
                    find_redditor 1 ;;
                d)
                    download_redditors ;;
                h)
                    display_help ;;
                *)
                    opt_err ;;
        esac
done