#! /bin/bash

# located in ${HOME}/

# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH

#always check .bashrc
[[ -e ~/.bashrc ]] && source ~/.bashrc

#if using arch, ensure package manager is colourised
[[ -f /etc/arch-release ]] && sudo sed -n '/Color/s/^#//g' /etc/pacman.conf

# colourise nano
if [[ $(uname -s) == "Linux" ]]
then
	echo '/usr/share/nano/*.nanorc' > ${HOME}/.nanorc
elif [[ $(uname -s) == "Darwin" ]]
then
	echo 'include /usr/local/Cellar/nano/**/share/nano/*.nanorc' > ${HOME}/.nanorc
fi

# Switch to using brew-installed bash as default shell
if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/bash;
fi;


# Colourise `ls` output
export CLICOLOR=YES
export LSCOLORS=Exfxcxdxbxegedabagacad

# make ruby look for correct version
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

#make scripts executable from PATH (which are stored in bin)
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:${HOME}/scripts/bash
export PATH=$PATH:${HOME}/scripts/pdfsearches
export PATH=$PATH:${HOME}/tex-macros
export PATH=$PATH:${HOME}/Desktop/Assorted\ Personal\ Documents/Work
export PATH=$PATH:${HOME}/pfetch/
export PATH=$PATH:${HOME}/sherlock/
export PATH=$PATH:${HOME}/.npm/
export PATH=$PATH:/usr/local/lib/node_modules/
export PATH=$PATH:${HOME}/Desktop/Study/Victoria\ University/2019/Trimester\ 3/SCIE306b/306/Alia-Laura-research/curse-of-knowing/
export PATH=$PATH:/usr/local/opt/openjdk/bin
if [ -e /Users/jakeireland/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/jakeireland/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

##
# Your previous /Users/jakeireland/.bash_profile file was backed up as /Users/jakeireland/.bash_profile.macports-saved_2020-02-18_at_09:46:19
##

# MacPorts Installer addition on 2020-02-18_at_09:46:19: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

