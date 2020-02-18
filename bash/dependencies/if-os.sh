#! /bin/bash


# get os
if [[ $(uname -s) == "Darwin" ]]
then
    OS="macos"
elif [[ $(uname -s) == "Linux" ]]
then
    if [[ -f /etc/arch-release ]]
    then
        OS="arch"
    elif [[ -f /etc/debian_version ]]
    then
        OS="debian"
    fi
else
    exit 1
fi


case $OS in
    macos)
        GHI="ghi"
        FD="fd"
        PERL="perl"
        ;;
    arch)
        GHI="ghi"
        FD="fd"
        PERL="perl"
        ;;
    debian)
        GHI="ghi"
        FD="fd-find" #command is fdfind
        PERL="perl"
        ;;
esac
