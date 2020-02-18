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
RUBY_VERSION='rbenv'
RUBY_BUILD='ruby-build'
HWINFO='hwinfo'
INXI='inxi'
PYDF='pydf'
LMSENSORS='lm-sensors'


case $OS in
    macos)
        ;;
    arch)
        RUBY_VERSION='https://aur.archlinux.org/packages/rbenv/'
        RUBY_BUILD='https://aur.archlinux.org/packages/ruby-build/'
        INXI='https://aur.archlinux.org/packages/inxi/'
        LMSENSORS='i2c-tools'
        ;;
    debian)
        FD="fd-find" #command is fdfind
        ;;
esac
