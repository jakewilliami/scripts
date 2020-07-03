#! /bin/bash

# Define bash directory
BASH_DIR="${HOME}"/scripts/bash/

# determines which package manager one uses
source "${BASH_DIR}"/dependencies/which-pacman.sh

# provides OS-specific package names (after determining the kernel and OS)
source "${BASH_DIR}"/dependencies/if-os.sh

# get jq if not installed and dejsonify colours for bash (jq-dep.sh sources colours/json-colour-parser.sh
# which does the actual dejsonifying).  Sources get-dependencies.sh for the getInstallCommands function.
source "${BASH_DIR}"/dependencies/jq-dep.sh

# provides the notifyUser <x> <message> function to print a user message in nice colours
source "${BASH_DIR}"/dependencies/notifying-messages.sh

# provides functions to check if a command/library/application is available and install if not
source "${BASH_DIR}"/dependencies/get-dependencies.sh

# provides the aur_install command for installing libraries and applications from the AUR
source "${BASH_DIR}"/dependencies/aur.sh

# provides the gen_install function for installing ruby gems
source "${BASH_DIR}"/dependencies/gem-install-dep.sh

# provides functions for making the writing of help output easier
source "${BASH_DIR}"/help/help.sh

# provides the error for lack of options function
source "${BASH_DIR}"/help/option-errors.sh
