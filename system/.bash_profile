# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH

#always check .bashrc
[[ -e ~/.bashrc ]] && source ~/.bashrc

#if using arch, ensure package manager is colourised
[[ -f /etc/arch-release ]] && sudo sed '/^#Color$/s/^#//' /etc/pacman.conf

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
