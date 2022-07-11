#! /bin/bash

# located in ${HOME}/
### DEPENDS ON FINDUTILS

# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH

#always check .bashrc
[[ -e ~/.bashrc ]] && source ~/.bashrc

#if using arch, ensure package manager is colourised
if [[ -f /etc/arch-release ]]
then
	grep '#Color' /etc/pacman.conf > /dev/null && \
	sudo sed -i '/Color/s/^#//g' /etc/pacman.conf
fi

# colourise nano and permanantly set $PATH
if [[ $(uname -s) == "Linux" ]]
then
	echo 'include /usr/share/nano/*.nanorc' > ${HOME}/.nanorc
	if [[ $(grep -v '^#' /etc/environment | wc -l) -eq 0 ]]
	then
		echo 'export PATH=$PATH:/usr/local/bin' | sudo tee /etc/environment
	fi
	if [[ $(grep -v '^#' /etc/environment | wc -l) -gt 0 ]]
	then
		#make scripts executable from PATH (which are stored in bin)
		echo 'PATH=$PATH:/usr/local/bin' | sudo tee -a /etc/environment
		echo 'PATH=$PATH:${HOME}/scripts/bash' | sudo tee -a /etc/environment
		echo 'PATH=$PATH:${HOME}/scripts/pdfsearches' | sudo tee -a /etc/environment
		echo 'PATH=$PATH:${HOME}/tex-macros' | sudo tee -a /etc/environment
		echo 'PATH=$PATH:${HOME}/pfetch/' | sudo tee -a /etc/environment
		echo 'PATH=$PATH:${HOME}/sherlock/' | sudo tee -a /etc/environment
		echo 'PATH=$PATH:${HOME}/.npm/' | sudo tee -a /etc/environment
		echo 'PATH=$PATH:/usr/local/lib/node_modules/' | sudo tee -a /etc/environment
		echo 'PATH=$PATH:/usr/local/opt/openjdk/bin' | sudo tee -a /etc/environment
		echo 'PATH=$PATH:${HOME}/.gem/ruby/**/bin' | sudo tee -a /etc/environment
		echo 'PATH=/usr/local/sbin:$PATH' | sudo tee -a /etc/environment
	fi
elif [[ $(uname -s) == "Darwin" ]]
then
	echo 'include /usr/local/Cellar/nano/**/share/nano/*.nanorc' > ${HOME}/.nanorc
	#make scripts executable from PATH (which are stored in bin)
	export PATH=$PATH:/usr/local/bin
	export PATH=$PATH:${HOME}/projects/scripts/bash
	export PATH=$PATH:${HOME}/projects/scripts/pdfsearches
	export PATH=$PATH:${HOME}/projects/tex-macros
	export PATH=$PATH:${HOME}/projects/scripts/c/compiled/Darwin/64/
	export PATH=$PATH:${HOME}/Desktop/Assorted\ Personal\ Documents/Work
	export PATH=$PATH:${HOME}/.npm/
	export PATH=$PATH:/usr/local/lib/node_modules/
	export PATH=$PATH:${HOME}/Desktop/Study/Victoria\ University/2019/Trimester\ 3/SCIE306b/306/Alia-Laura-research/curse-of-knowing
	export PATH=$PATH:/usr/local/opt/openjdk/bin
	export PATH=$PATH:${HOME}/.gem/ruby/**/bin
	export PATH=$PATH:${HOME}/projects/macOS-config/mconfig.d/
	export PATH=/usr/local/sbin:$PATH
	export PATH=$PATH:${HOME}/projects/scripts/julia/
	export PATH=$PATH$( gfind $HOME/projects/scripts/julia/ -type d -printf ":%p" )
	export PATH=$PATH:$HOME/projects/scripts/python/
	export PATH=$PATH:$HOME/perl5/perlbrew/bin/
	export PATH=$PATH:$HOME/projects/scripts/julia/Other/advent_of_code/2020/
	export PATH=$PATH:$HOME/projects/scripts/rust/emacs-help/
	export PATH=$PATH:$HOME/projects/pentesting/HTB/exploitdb/
	if [ -e /Users/jakeireland/.nix-profile/etc/profile.d/nix.sh ]
	then
        	. /Users/jakeireland/.nix-profile/etc/profile.d/nix.sh
	fi # added by Nix installer
	# MacPorts Installer addition on 2020-02-18_at_09:46:19: adding an appropriate PATH variable for use with MacPorts.
	export PATH=/opt/local/bin:/opt/local/sbin:$PATH
	# Finished adapting your PATH environment variable for use with MacPorts.
	# Based on `brew --prefix ruby`, so that it uses the correct version of ruby
	export PATH=/usr/local/opt/ruby/bin:$PATH
	export PATH=$HOME/.gem/ruby/3.0.0/bin:$PATH
	# load rvm (ruby version manager) into session
	[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
fi

# add line numbers to nano
echo 'set linenumbers' >> ${HOME}/.nanorc


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



echo "( .-.)"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/Caskroom/miniconda/base/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

. "$HOME/.cargo/env"
