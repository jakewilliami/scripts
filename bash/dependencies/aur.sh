#! /bin/bash

aur_install() {
    URL="${2}"
    if ! $PACSEARCH | grep "${1}" > /dev/null 2>&1
    then
        cd "${HOME}"/Downloads/
        wget "${URL}" || echo -e "${ERROR_OCCURRED}"
        DOWNLOADED_FILE="${URL##*/}"
        tar xvzf "${DOWNLOADED_FILE}"
        EXTRACTED_DIR="${DOWNLOADED_FILE%%.*}"
        cd - > /dev/null
        cd "${HOME}"/Downloads/
        cd "${EXTRACTED_DIR}"
        makepkg -sicCfL
        cd - > /dev/null
        cd "${HOME}"/Downloads/
        rm "${DOWNLOADED_FILE}"
        rm -rf "${EXTRACTED_DIR}"
        cd - > /dev/null
    fi
}