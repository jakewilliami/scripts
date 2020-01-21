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
    brew_install "${SATISFYING_DEPS}" perl ruby rbenv ruby-build && \
    echo -e "${DEPS_SATISFIED}"
fi

clean_brew() {  # https://superuser.com/a/975878/1100925
    BIG_LINE=$(seq -s= $(tput cols) | tr -d '[:digit:]')
    echo -e "${ITYELLOW}Updating Homebrew Core${NORM}"
    brew update # Update homebrew
    echo
    echo -e "${BWHITE}${BIG_LINE}${NORM}"
    echo -e "${ITYELLOW}Updating Homebrew Casks${NORM}"
    brew cask upgrade
    echo
    echo -e "${BWHITE}${BIG_LINE}${NORM}"
    echo -e "${ITYELLOW}Updating Homebrew Formulae${NORM}"
    brew upgrade  # Update outdated formula
    echo
    echo -e "${BWHITE}${BIG_LINE}${NORM}"
    echo -e "${ITYELLOW}Removing Outdated Formula${NORM}"
    brew cleanup -s  # Remove outdated formula
    echo
    echo -e "${BWHITE}${BIG_LINE}${NORM}"
    echo -e "${ITYELLOW}Running Homebrew Doctor for potential problems${NORM}"
    brew cask doctor
    brew doctor  # Check system for potential problems; https://github.com/Homebrew/legacy-homebrew/issues/20598#issuecomment-19686090
    echo
    echo -e "${BWHITE}${BIG_LINE}${NORM}"
    echo -e "${ITYELLOW}Clearing Homebrew Cache${NORM}"
    ls $(brew --cache)
    rm -rf $(brew --cache)
    #Run `brew tap beeftornado/rmtree; brew rmtree [formula]` to remove package AND dependencies
}


clean_gems() {
    sudo gem update  # https://stackoverflow.com/a/36150004/12069968
    sudo gem cleanup  # https://nathanhoad.net/how-to-clean-up-old-gems/
}

clean_perl() {
    perl -MCPAN -e "upgrade /(.\*)/"
}


big_clean() {
    BIG_LINE=$(seq -s= $(tput cols) | tr -d '[:digit:]')
    echo -e "${BGREEN}${BIG_LINE}${NORM}"
    echo -e "${BYELLOW}CLEANING HOMEBREW${NORM}"
    clean_brew
    echo
    echo -e "${BGREEN}${BIG_LINE}${NORM}"
    echo -e "${BYELLOW}CLEANING RUBY${NORM}"
    clean_gems
    echo
    echo -e "${BGREEN}${BIG_LINE}${NORM}"
    echo -e "${BYELLOW}CLEANING CPANM PACKAGES${NORM}"
    clean_perl
    echo
    echo -e "${BGREEN}${BIG_LINE}${NORM}"
    echo -e "${BYELLOW}CLEANING APPS FROM THE APPLE APP STORE${NORM}"
    mas upgrade 
}


#Do the thing
big_clean


# Clean up
clean-exit
