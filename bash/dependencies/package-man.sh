#! /bin/bash

# Check if brew exists; if not, which package manager
if command -v brew > /dev/null 2>&1
then
    PACMAN='brew install'
    PACSEARCH='brew list'
else
    declare -A osInfo;
    osInfo[/etc/redhat-release]='sudo yum install'
    osInfo[/etc/arch-release]='sudo pacman -S --noconfirm'
    osInfo[/etc/gentoo-release]='sudo emerge'
    osInfo[/etc/SuSE-release]='sudo zypper in'
    osInfo[/etc/debian_version]='sudo apt-get install -y'
    
    declare -A osSearch;
    osSearch[/etc/redhat-release]='yum list installed'
    osSearch[/etc/arch-release]='sudo pacman -Q'
    osSearch[/etc/gentoo-release]="cd /var/db/pkg/ && ls -d */*| sed 's/\/$//'"
    osSearch[/etc/SuSE-release]='rpm -qa'
    osSearch[/etc/debian_version]='apt-get list --installed'
    
    for f in "${!osInfo[@]}"
    do
        if [[ -f $f ]];then
            PACMAN="${osInfo[$f]}"  
        fi
    done
    
    for s in "${!osSearch[@]}"
    do
        if [[ -f $s ]];then
            PACSEARCH="${osSearch[$s]}"  
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
