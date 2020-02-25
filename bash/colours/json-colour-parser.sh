#! /bin/bash

# Parse json colours to bash
jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' ${BASH_DIR}/colours/textcolours.json | \
sed -e 's/=\([^" >][^ >]*\)/="\1"/g' > \
${BASH_DIR}/temp.d/textcolours && source ${BASH_DIR}/temp.d/textcolours


# Clean up
clean-exit() {
    [[ -f ${BASH_DIR}/temp.d/textcolours ]] && \
    rm ${BASH_DIR}/temp.d/textcolours
    exit $?
}


clean-return() {
    [[ -f ${BASH_DIR}/temp.d/textcolours ]] && \
    rm ${BASH_DIR}/temp.d/textcolours
#    kill -INT $$
    return $?
}
