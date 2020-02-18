#! /bin/bash

# Define bash directory
BASH_DIR="${HOME}"/scripts/bash/

# get package manager
source "${BASH_DIR}"/dependencies/package-man.sh

#get is-command function
source "${BASH_DIR}"/dependencies/is-command.sh

#decide on packages
source "${BASH_DIR}"/dependencies/if-os.sh

#get jq if not installed and dejsonify colours for bash (jq-dep.sh sources colours/json-colour-parser.sh which does the actual dejsonifying of the colours)
source "${BASH_DIR}"/dependencies/jq-dep.sh

# get the Brew Install Function (for installing with your given package manager; brew install actually sources dependences/package-man.sh itself)
source "${BASH_DIR}"/dependencies/brew-install-dep.sh

# get the Gem Install function (for installing ruby gems)
source "${BASH_DIR}"/dependencies/gem-install-dep.sh

#get clean-exit command
source "${BASH_DIR}"/colours/json-colour-parser.sh

#get help_function command
source "${BASH_DIR}"/help/help.sh

# get errors for lack of options
source "${BASH_DIR}"/help/option-errors.sh
