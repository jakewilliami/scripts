#! /bin/bash

#located in ${HOME}/

# dependencies: nano

# set emacs to default editor
export EDITOR='emacs -nw'
export VISUAL='emacs -nw'


# get current branch in git repo
function parse_git_branch() {
	BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=$(parse_git_dirty)
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=$(git status 2>&1 | tee)
	dirty=$(echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?")
	untracked=$(echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?")
	ahead=$(echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?")
	newfile=$(echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?")
	renamed=$(echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?")
	deleted=$(echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?")
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

# make prompt pretty
PS1="\n\[\033[0;31m\]\342\224\214\342\224\200\$()[\[\033[1;38;5;2m\]\u\[\033[0;1m\]@\033[1;33m\]\h: \[\033[1;34m\]\W\[\033[1;33m\]\[\033[0;31m\]]\[\033[0;32m\] \[\033[1;33m\]\`parse_git_branch\`\[\033[0;31m\]\n\[\033[0;31m\]\342\224\224\342\224\200\342\224\200\342\225\274 \[\033[0;1m\]\$\[\033[0;38m\] "
export PS1

alias lsl="ls -l"
# Aliases to change cd not in subshell
alias pdfsearch.rb="ruby ~/projects/scripts/pdfsearches/pdfsearch.rb"
alias pdfsearch.py="python3 ~/projects/scripts/pdfsearches/pdfsearch.py"
alias pdfsearch.pl="perl -X ~/projects/scripts/pdfsearches/pdfsearch.pl"
alias pdfsearch.lisp="clisp ~/projects/scripts/pdfsearches/pdfsearch.lisp"
alias pdfsearch.jl="julia ~/projects/scripts/pdfsearches/pdfsearch.jl"
alias ls.py="python3 ~/projects/scripts/python/ls.py"
alias please="sudo"
alias scripts="cd ${HOME}/projects/scripts; scripts $@"
alias mconfig="cd ${HOME}/projects/macOS-config; mconfig $@"
alias mytex="cd ${HOME}/projects/tex-macros/; mytex $@"
alias sudo-ods="sudo /Applications/OmniDiskSweeper.app/Contents/MacOS/OmniDiskSweeper"
alias get-ip="ipconfig getifaddr en0"
alias get-public-ip="curl ipinfo.io/ip"
alias system-data="system_profiler SPSoftwareDataType"
alias open-dir-dl='wget --recursive --level=0 --no-parent --continue --reject "index.html*"' #Use the -P option to set an output directory
# Alternatively use, if robot not behaving: 
alias open-dir-dl-alt='wget --recursive --continue --level=0 --no-parent --reject="index.html*" --no-clobber --convert-links --random-wait --adjust-extension --execute robots=off --user-agent=mozilla' # to behave like a person # https://www.tupp.me/2014/06/how-to-crawl-website-with-linux-wget.html
alias this-tri="cd ${HOME}'/Desktop/Study/Victoria University/2020/Trimester 2'"
alias fbcli="facebook-cli"
alias Sammu="echo -e '\u001b[1;34m===>\t\u001b[0;38m\u001b[1;38mShutting down machine\u001b[0;38m'; sleep 5; sync; sudo systemctl poweroff" # Sammu; Finnish: Shutdown
alias Päivitys="echo -e '\u001b[1;34m===>\t\u001b[0;38m\u001b[1;38mStarting system upgrade and rebooting machine\u001b[0;38m'; sleep 5; sync; sudo pacman -Syyu; sudo shutdown -r now" # Päivitys; Finnish: Upgrade
alias Siivous="echo -e '\u001b[1;34m===>\t\u001b[0;38m\u001b[1;38mClearing pacman cache\u001b[0;38m'; sleep 5; sync; sudo pacman -Sc; sudo paccache -r" # Siivous; Finnish: Clear Cache
alias curl-bashrc="cd ~/; rm ~/.bashrc; ~/projects/scripts/bash/curl-raw dotfiles/.bash/.bashrc; cp ~/dotfiles/.bash/.bashrc ~/; source ~/.bashrc"
alias curl-bashprofile="cd ~/; rm ~/.bash_profile; ~/projects/scripts/bash/curl-raw dotfiles/.bash/.bash_profile; cp ~/dotfiles/.bash/.bash_profile ~/; source ~/.bash_profile"
alias Kaynnistää-uudelleen="echo -e '\u001b[1;34m===>\t\u001b[0;38m\u001b[1;38mRebooting machine\u001b[0;38m'; sleep 5; sync; sudo reboot" # Käynnistää-uudelleen; Finnish: Start Again (Reboot)
alias Shutdown="echo 'Run the alias Sammu'"
alias Cache="echo 'Run the alias Siivous'"
alias Reboot="echo 'Run the alias Kaynnistää-uudelleen'"
alias Upgrade="echo 'Run the alias Päivitys'"
alias start-eth="sudo launchctl load /Library/LaunchAgents/com.mine.toggleairport.plist"
alias gtime="gdate | awk '{print $4}'"
alias ssh-converter="ssh jakeireland@192.168.1.203 -p 24"
alias ssh-plex="ssh jakeireland@192.168.1.202 -p 24"
alias ssh-server="ssh jakeireland@192.168.1.100"
alias aoc="cd $HOME/projects/scripts/julia/Other/advent_of_code/2020"
alias gl="$HOME/projects/scripts/rust/gl/gl"
alias gl.rs="$HOME/projects/scripts/rust/gl/gl"
alias filmls="$HOME/projects/scripts/rust/filmls/filmls"
alias shuffle="sort -R"
alias pythong="python"
alias emacsc="emacsclient"
alias ls.rs="$HOME/projects/scripts/rust/pere/pere"
alias огдшф="julia"
alias ll="ls -la"
alias el="exa -la"
alias exag="exa -l --git"

function Words.jl() {
	echo 'Words.find_anagrams("word", Words.WORDLIST)'
	julia --project="~/projects/scripts/julia/Other/Words.jl/" -e 'include(joinpath(homedir(), "projects", "scripts", "julia", "Other", "Words.jl", "src", "Words.jl")); using .Words' -i
}

function pdfsearch.rs() {
	PATH_TO_PROJECT="${HOME}"/projects/scripts/pdfsearches/pdfsearch.rs/
	cargo run --manifest-path ${PATH_TO_PROJECT}/Cargo.toml ${PATH_TO_PROJECT}/src/main.rs
}

function clean-all-docker() {
	docker rm docker rm $(docker ps -aq); docker system prune --all
}

function clean-docker() {
	docker rm `docker ps -aq -f status=exited`
}

function get-version() {
	defaults read /Applications/"${1}.app"/Contents/Info CFBundleShortVersionString
}

function view-md() {
	pandoc "${1}" | lynx -stdin
}

function get-status() {
	curl -s -o /dev/null -w "%{http_code}" $1; echo
}

alias http-status-code="get-status"

eval "$(thefuck --alias)"
# You can use whatever you want as an alias, like for Mondays:
eval $(thefuck --alias FUCK)

function push-study() {
	cd ~/Desktop/Study
	git add -A
	git commit -am "Updated current courses"
	git push
	cd - > /dev/null
}

function search-macros() {
	find $HOME/projects/tex-macros/general_macros/ -type f -print | \
	while IFS= read -r file
	do
		results="$(grep -nir "${1}" "${file}")"
		file="$(echo "${results}" | awk -F':' '{print $1}')"
		line="$(echo "${results}" | awk -F':' '{print $2}')"
		found="$(echo "${results}" | awk -F':' '{print $3}')"
		if [ ! -z "${results}" ]
		then
			echo -e "\u001b[1;38mResults found in \u001b[1;38;5;26m${file}\u001b[0;38m\u001b[1;38m on line \u001b[1;38;5;26m${line}\u001b[0;38m"
			echo -e "${found}"
		fi
	done
}

function compile.rs() {
	cargo build && cp -f "./target/debug/$(basename "$(pwd)")" ./
}

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:$HOME/.julia/bin"
