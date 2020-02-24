#! /bin/bash

URL="${1}"
aur_install() {
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
}