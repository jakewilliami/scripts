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




make_tex() {
    #Get script dir
    SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
    
    #Make tex file
    cd ${DIRECTORY_ARCHIVE}/
    mktex --general ./ archive-1
    cat archive-1.tex | sed 's///g' > archive-1.tex
    
    
    #Change Title of file
    perl -pi -e 's/%enter title here/tile!/g' test.tex  
    #Change Author
    perl -pi -e 's/Jake W. Ireland/author :)/g' test.tex
    #Date
    perl -pi -e 's/%\\tableofcontent/date :)/g' test.tex
}



while getopts ":-:gabph" OPTION; do
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