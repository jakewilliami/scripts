#! /bin/bash


# get os
if [[ $(uname -s) == "Darwin" ]]
then
    KERNEL="Darwin"
    OS="macos"
elif [[ $(uname -s) == "Linux" ]]
then
    KERNEL="Linux"
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
RUBY_BUILD='ruby-build' #see, for example, bash/clean for example on debian ruby build packages
HWINFO='hwinfo'
INXI='inxi'
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
SNIFF='sniffglue'
DHCP='dhcpdump'
DHCPING='dhcping'
ROOTKITHUNT='rkhunter'
ARPSCAN='arp-scan'
NMAP='nmap'
TSHARK='tshark'
PYTHON3='python3'
PIP3='python3-pip'
BREWCASK='cask'
ATOM='atom'
BRACKETS='brackets'
PDFGREP='pdfgrep'
GDEBI='gdebi-core'


case $OS in
    macos)
        ICU='icu4c'
        PYTHON3='python' # Includes pip3 on macOS
        ;;
    arch)
        LMSENSORS='i2c-tools'
        NETSTAT='vnstat'
        ATOM='atom-editor-git' #https://aur.archlinux.org/packages/atom-editor-git/
        RUBY_VERSION='rbenv' #https://aur.archlinux.org/cgit/aur.git/snapshot/rbenv.tar.gz
        RUBY_BUILD='ruby-build' #https://aur.archlinux.org/cgit/aur.git/snapshot/ruby-build.tar.gz
        INXI='inxi' #https://aur.archlinux.org/cgit/aur.git/snapshot/inxi.tar.gz
        DHCP='dhcpdump' #https://aur.archlinux.org/cgit/aur.git/snapshot/dhcpdump.tar.gz
        BRACKETS='brackets' #https://aur.archlinux.org/cgit/aur.git/snapshot/brackets.tar.gz
        PYTHON3='python'
        PIP3='python-pip'
        ;;
    debian)
        FD="fd-find" #command is fdfind
        POWERSTAT='powerstat'
        ICU='icu-devtools'
        GHLINGUIST='ruby-github-linguist'
        ;;
esac
