
# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH

#always check .bashrc
[[ -e ~/.bashrc ]] && source ~/.bashrc


# Setting JAVA_HOME
# JAVA_HOME=`/usr/libexec/java_home -v 1.8.0_222`
# JAVA_HOME=$(/Library/Java/JavaVirtualMachines/jdk1.8.0_221.jdk/Contents/Home/bin)
# JAVA_HOME=/Library/Java/JavaVirtualMachines
export JAVA_HOME;

# Install perlbrew
source ~/perl5/perlbrew/etc/bashrc

# Colourise `ls` output
export CLICOLOR=YES
export LSCOLORS=Exfxcxdxbxegedabagacad

# make ruby look for correct version
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

#OUTDATED
#for 3ello  # https://trello.com/app-key
export TRELLO_USER=jakeireland2
export TRELLO_KEY=54053e85d9c82a1b79694a9f22c0ecb8
export TRELLO_TOKEN=210613158c54215685b88585453627e0e3fb357baa6f0f0da3456b5b3d2371b6

#make scripts executable from PATH (which are stored in bin)
export PATH=$PATH:/Users/jakeireland/bin/scripts
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/Users/jakeireland/.cargo/bin
export PATH=$PATH:/Users/jakeireland/.cargo/registry
export PATH=$PATH:/Users/jakeireland/scripts/rust
export PATH=$PATH:/Users/jakeireland/scripts/rust/registry
export PATH=$PATH:/Users/jakeireland/scripts/rust/binexport 
export PATH=$PATH:/Users/jakeireland/scripts/bash
export PATH=$PATH:/Users/jakeireland/scripts/pdfsearches
export PATH="/usr/local/sbin:$PATH"
export PATH=$PATH:${HOME}/tex-macros
export PATH=$PATH:${HOME}/Desktop/Assorted\ Personal\ Documents/Work
export PATH=$PATH:${HOME}/pfetch/
export PATH=$PATH:${HOME}/sherlock/
export PATH=$PATH:${HOME}/.npm/
export PATH=$PATH:/usr/local/lib/node_modules/
export PATH=$PATH:/Users/jakeireland/Desktop/Study/Victoria\ University/2019/Trimester\ 3/SCIE306b/306/Alia-Laura-research/curse-of-knowing/
export PATH="/usr/local/opt/openjdk/bin:$PATH"
