#! /bin/bash

# Check if brew; if not, which package manager
if [[ ! -z $(which brew) ]]
then
    PACMAN='brew install'
else
    declare -A osInfo;
    osInfo[/etc/redhat-release]='sudo yum install'
    osInfo[/etc/arch-release]='sudo pacman -S'
    osInfo[/etc/gentoo-release]='sudo emerge'
    osInfo[/etc/SuSE-release]='sudo zypper in'
    osInfo[/etc/debian_version]='sudo apt-get install'
    
    for f in ${!osInfo[@]}
    do
        if [[ -f $f ]];then
            PACMAN=${osInfo[$f]}
        else
            PACMAN='sudo apt install'
        fi
    done
fi




#if [ -f /etc/os-release ]; then
#    # freedesktop.org and systemd
#    source /etc/os-release
#    OS=$NAME
#    VER=$VERSION_ID
#elif type lsb_release >/dev/null 2>&1; then
#    # linuxbase.org
#    OS=$(lsb_release -si)
#    VER=$(lsb_release -sr)
#elif [ -f /etc/lsb-release ]; then
#    # For some versions of Debian/Ubuntu without lsb_release command
#    source /etc/lsb-release
#    OS=$DISTRIB_ID
#    VER=$DISTRIB_RELEASE
#elif [ -f /etc/debian_version ]; then
#    # Older Debian/Ubuntu/etc.
#    OS=Debian
#    VER=$(cat /etc/debian_version)
##elif [ -f /etc/SuSe-release ]; then
##    # Older SuSE/etc.
##    ...
##elif [ -f /etc/redhat-release ]; then
##    # Older Red Hat, CentOS, etc.
##    ...
#else
#    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
#    OS=$(uname -s)
#    VER=$(uname -r)
#fi