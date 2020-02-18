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


case $OS in
    macos)
        ;;
    arch)
        RUBY_VERSION='https://aur.archlinux.org/packages/rbenv/'
        RUBY_BUILD='https://aur.archlinux.org/packages/ruby-build/'
        ;;
    debian)
        FD="fd-find" #command is fdfind
        ;;
esac
