#! /bin/bash


DIRECTORY_ARCHIVE="${HOME}/Archives/Misc.\ Archival/archived-reddit/"


BASH_DIR="${HOME}/scripts/bash/"
TEMPLATES_DIR="${HOME}/tex-macros/tea_templates/"
BEAMER_DIR="${TEMPLATES_DIR}/beamer/"


#Ensure that tex-macros dir exists and the mktex does as well
if [[ $USER != "jakeireland" ]]
then
    # Ensure jq is installed and directories for mktex script is installed
    source ${BASH_DIR}/dependencies/jq-dep.sh
    cd ${HOME}/
    git clone https://github.com/jakewilliami/tex-macros
fi


# Colours
source ${BASH_DIR}/colours/json-colour-parser.sh

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
REDDIT_ARCHIVE_TEXT_FILE="${HOME}/scripts/python/reddit-archive-to-be-read.txt"


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


#def latex creating option function
make_tex() {
    #Get script dir
    SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
    Make tex file
    cd ${DIRECTORY_ARCHIVE}/
    mktex --general ./ archive-${A}
    cat archive-1.tex | sed 's///g' > archive-1.tex
}


alter_tex() {
    #Change Title of file
    perl -pi -e 's/%enter title here/tile!/g' test.tex  
    #Change Author
    perl -pi -e 's/Jake W. Ireland/author :)/g' test.tex
    #Date
    perl -pi -e 's/%\\tableofcontent/date :)/g' test.tex
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