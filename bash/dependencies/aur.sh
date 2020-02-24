#! /bin/bash

URL="${2}"
aur_install() {
    if ! $PACSEARCH | grep "${1}" > /dev/null 2>&1
    then
        cd "${HOME}"/Downloads/
        curl "${URL}"
        DOWNLOADED_FILE="${URL##*/}"
        tar xvzf "${DOWNLOADED_FILE}"
        EXTRACTED_DIR="${DOWNLOADED_FILE%%.*}"
        cd "${EXTRACTED_DIR}"
        makepkg -sicCfL
        cd ..
        rm "${DOWNLOADED_FILE}"
        rm -rf "${EXTRACTED_DIR}"
    fi
}