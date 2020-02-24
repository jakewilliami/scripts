#! /bin/bash

opt_err() { #Invalid option (getopts already reported the illegal option)
    HELP="${BYELLOW}Not a valid option.  Use -h for help.${NORM}"
    echo -e "${HELP}"
    clean-exit
}


opt_err_none() { #Invalid option (getopts already reported the illegal option)
    HELP="${BYELLOW}You must have at least one argument.  Use -h for help.${NORM}"
    echo -e "${HELP}"
    clean-exit
}