#! /bin/bash

# Parse json colours to bash
jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' ${BASH_DIR}/colours/textcolours.json | \
sed -e 's/=\([^" >][^ >]*\)/="\1"/g' >> \
${BASH_DIR}/textcolours.txt && source ${BASH_DIR}/textcolours.txt


# Clean up
clean-exit() {
    [[ -f ${BASH_DIR}/textcolours.txt ]] && \
    rm ${BASH_DIR}/textcolours.txt
    exit $?
}


clean-return() {
    [[ -f ${BASH_DIR}/textcolours.txt ]] && \
    rm ${HOME}/scripts/bash/textcolours.txt
#    kill -INT $$
    return $?
}
