#! /bin/bash

notifyUser() {
    case ${1} in
        w) echo -e "${BBLUE}===>${NORM}\t${BWHITE}${2}${NORM}" ;;
        g) echo -e "${BBLUE}===>${NORM}\t${BGREEN}${2}${NORM}" ;;
        y) echo -e "${BBLUE}===>${NORM}\t${BYELLOW}${2}${NORM}" ;;
        r) echo -e "${BBLUE}===>${NORM}\t${BRED}${2}${NORM}" ;;
        i) echo -e "${BBLUE}===>${NORM}\t${ITWHITE}${2}${NORM}" ;;
        *) echo -e "${BBLUE}===>${NORM}\t${BWHITE}${2}${NORM}" ;;
    esac
}


# define functions for printing messages
satisfyingDeps() {
    notifyUser w 'Satisfying dependencies...'
}

depsSatisfied() {
    notifyUser g 'Dependencies satisfied.'
}

satisfyingLibs() {
    notifyUser w 'Satisfying uninstalled but required libraries...'
}

libsSatisfied() {
    notifyUser g 'Dependent libraries installed.'
}

satisfyingApps() {
    notifyUser w 'Installing required applications...'
}

appsSatisfied() {
    notifyUser g 'Dependent applications installed.'
}

errorOccurred() {
    if [[ $OS == "arch" ]]
    then
        notifyUser r 'It seems an error has occurred in the satiation of your dependencies. You may need to manually download the package using the AUR.'
    else
        notifyUser r 'It seems an error has occurred in the satiation of your dependencies.'
    fi
}

installingPackageMessage() {
    notifyUser i "Installing ${1}"
}
