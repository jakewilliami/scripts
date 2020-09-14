#! /bin/bash

# define bash directory
BASH_DIR="$(realpath $(dirname $0))"

# source required scripts
source ${BASH_DIR}/dependencies/source-dependencies.sh

# get script dependencies
is-library-then-install p7zip


# Help
display_help() {
    help_start 'get-redditors.sh [option...]' 'The present script will download a list of all redditors for you to scrape and search through.'
    help_commands '-e' '--extended-find' '1' '\b' 'E' 'xtends' 'the search complexity using regex (see example).'
    help_commands '-d' '--download' '1' '\b' 'D' 'ownload' '\bs, extracts, and writes to text a list of all Redditors\x27 usernames.'
    help_commands '-f' '--find' '2' '\b' 'F' 'ind' 'Redditors from CSV.'
    help_help '2'
    help_examples 'The extended regex option should be used as follows: `get-redditors.sh -e [search_term] [search_term_with_regex]`.  For example, `get-redditors.sh -e moose ^moose` will find all usernames starting with the term moose.'
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