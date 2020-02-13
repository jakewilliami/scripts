#! /bin/bash


DIRECTORY_ARCHIVE="${HOME}/Archives/archived-reddit/"
SCRIPTS_DIR="${HOME}/scripts/"


# Colours
source ${SCRIPTS_DIR}/bash/colours/json-colour-parser.sh

# Invalid Option
opt_err() {
    HELP="${BYELLOW}Invalid option.  Use option -h for help.${NORM}"
    echo -e "${HELP}"
	clean-exit
}

# Help
display_help() {
    echo -e "${BWHITE}Usage: mktex [option] [dir] [file name]${NORM}"
    echo
    echo -e "${ITWHITE}The present script will help to make a new LaTeX file using predefined templates and .${NORM}"
    echo
    echo -e "${BBLUE}\t -h | --help \t\t${BYELLOW}Shows ${ULINE}${BBLUE}h${BYELLOW}elp${NORM} ${BYELLOW}(present output).${NORM}"
    clean-exit
}

#define new and old archive number
ARCHIVE_OLD_NO=$(for i in ${DIRECTORY_ARCHIVE}/*; do if [[ -d $i ]]; then echo $i; fi; done | grep -Eo "[0-9]{1,4}" | sort -nr | head -1)
ARCHIVE_NEW_NO=$(echo "$(($ARCHIVE_OLD_NO + 1))")
IMMUT_OLD_NO=$(echo ${ARCHIVE_OLD_NO})
IMMUT_NEW_NO=$(echo ${ARCHIVE_NEW_NO})
URL_INPUT=$3
REDDIT_ARCHIVE_TEXT_FILE="${SCRIPTS_DIR}/python/reddit-archive-to-be-read.txt"


#Make new archive directory
make_archive_dir() {
    mkdir "archive-$IMMUT_NEW_NO" || clean-exit
}


#cd function
cd_archive_dir() {
    cd archive-$IMMUT_NEW_NO || clean-exit
}

make_archive_text() {
    #create reddit archive text
    if [[ -z $3 ]]
    then
        echo -e "${BYELLOW}This option requires a reddit url${NORM}"
    else
        python3 ~/scripts/python/praw-for-kt.py $URL_INPUT
    fi
}


#Puts it all together!
compile_pdf() {

}



while getopts ":-:h" OPTION; do
        case $OPTION in
                -)
                    case $OPTARG in
                        help)
                            display_help ;;
                        *)
                            opt_err ;;
                    esac ;;
                h)
                    display_help ;;
                *)
                    opt_err ;;
        esac
done


# if no options were passed                   
if [ $OPTIND -eq 1 ]
then 
    echo -e "${BYELLOW}You must pass an option to the script.  Please use -h for help.${NORM}"
    clean-exit
fi