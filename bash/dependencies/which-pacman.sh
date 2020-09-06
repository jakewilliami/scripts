getInstallCommands() {
    # Check if brew exists; if not, which package manager
    if command -v brew > /dev/null 2>&1
    then
        PACMAN='brew install'
        PACSEARCH='brew list'
        PACAPPSEARCH='brew list --cask'
        PACAPP='brew cask install'
    else
        declare -A osInfo;
        osInfo[/etc/redhat-release]='sudo dnf --assumeyes install'
        osInfo[/etc/arch-release]='sudo pacman -S --noconfirm'
        osInfo[/etc/gentoo-release]='sudo emerge'
        osInfo[/etc/SuSE-release]='sudo zypper in'
        osInfo[/etc/debian_version]='sudo apt-get --assume-yes install'
        
        declare -A osSearch;
        osSearch[/etc/redhat-release]='dnf list installed'
        osSearch[/etc/arch-release]='pacman -Qq'
        osSearch[/etc/gentoo-release]="cd /var/db/pkg/ && ls -d */*| sed 's/\/$//'"
        osSearch[/etc/SuSE-release]='rpm -qa'
        osSearch[/etc/debian_version]='dpkg -l' # previously `apt list --installed`.  Can use `sudo apt-cache search`.
        
        for f in "${!osInfo[@]}"
        do
            if [[ -f $f ]];then
                PACMAN="${osInfo[$f]}"
                PACAPP="${osInfo[$f]}"
            fi
        done
        
        for s in "${!osSearch[@]}"
        do
            if [[ -f $s ]];then
                PACSEARCH="${osSearch[$s]}"
                PACAPPSEARCH="${osSearch[$s]}"
            fi
        done
    fi
}
