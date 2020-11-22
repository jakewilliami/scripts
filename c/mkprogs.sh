#! /bin/bash

CDIR="${HOME}/projects/scripts/c/"
COMPILEDIR="${CDIR}/compiled/"

if [[ $(uname -s) == "Darwin" ]]; then
    SYSDIR="Darwin"
elif [[ $(uname -s) == "Linux" ]]; then
    SYSDIR="Linux"
elif [[ $(uname -s) == "FreeBSD" ]]; then
    SYSDIR="BSD"
else
    echo "Warning: Unknown operating system."
    SYSDIR="$(uname -s)"
    mkdir -p "${COMPILEDIR}/${SYSDIR}"
fi

if [[ $(uname -m) =~ ^.*64$ ]]; then
    ARCH="64"
elif [[ $(uname -m) =~ ^.*32$ ]]; then
    ARCH="32"
else
    echo "Warning: Unknown system architecture"
    ARCH="$(uname -m)"
    mkdir -p "${COMPILEDIR}/${SYSIER}/${ARCH}"
fi

files=( "countmedia.c" "ls.c" "mktex.c" )
# files=( "ls.c" )

for file in "${files[@]}"; do
    filename="$(basename -- "${CDIR}/${file}")"
    extension="${filename##*.}"
    filename="${filename%.*}"
    gcc -o "${COMPILEDIR}/${SYSDIR}/${ARCH}/${filename}.o" "${CDIR}/${filename}.${extension}"
done
