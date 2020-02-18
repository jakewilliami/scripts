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


GHI='ghi'
FD='fd'
PERL_PACKAGE='perl'
RUBY_PACKAGE='ruby'
RUBY_VERSION='rbenv'#https://aur.archlinux.org/packages/rbenv/
RUBY_BUILD='ruby-build' #https://aur.archlinux.org/packages/ruby-build/
HWINFO='hwinfo'
INXI='inxi' #https://aur.archlinux.org/packages/inxi/
PYDF='pydf'
LMSENSORS='lm-sensors'
NETSTAT='ifstat'
NETSTAT_ALT='tcpstat'
POWERSTAT='upower'
SYSSTAT='sysstat'
IPTSTATE='iptstate'
IPTABLES='iptables'
DSTAT='dstat'
CMAKE='cmake'
PKG_CONFIG='pkg-config'
ICU='icu'
GHLINGUIST='github-linguist'


case $OS in
    macos)
        ICU='icu4c'
        ;;
    arch)
        RUBY_VERSION='rbenv'#https://aur.archlinux.org/packages/rbenv/
        RUBY_BUILD='ruby-build' #https://aur.archlinux.org/packages/ruby-build/
        LMSENSORS='i2c-tools'
        NETSTAT='vnstat'
        ;;
    debian)
        FD="fd-find" #command is fdfind
        POWERSTAT='powerstat'
        ICU='icu-devtools'
        #RUBY_BUILD='ruby-charlock-holmes ruby-escape-utils ruby-rugged'
        GHLINGUIST='ruby-github-linguist'
        ;;
esac
