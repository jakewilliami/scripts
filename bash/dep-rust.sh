#! /bin/bash

#Define local variables
REPLACING="\033[01;31mReplacing outdated file(s) in git repository from ~/.cargo.\033[0;38m"
COMPLETED="\033[1;38;5;2m.cargo transfer complete.\033[0;38m"
ALL_GOOD="\033[1;38;5;2mYour git repository's .cargo files are up to date with your local ~/.cargo directory.\033[0;38m"

GIT_LOCATION="${HOME}/bin/scripts/"

LOCAL_DIR="${HOME}/.cargo/"
GIT_DIR="${GIT_LOCATION}rust/"

DIFF=$(comm -23 <(ls "${LOCAL_DIR}" | sort) <(ls "${GIT_DIR}" | sort))

#Begin script
#check files in .cargo
if [ "$DIFF" != "" ]
then
    echo -e "${REPLACING}" 
    cp -rf "${LOCAL_DIR}" "${GIT_DIR}" && echo -e ${COMPLETED}
else
    echo -e "${ALL_GOOD}"
fi
