#\342\224\200 is an em dash

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
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


# to see a list of all running applications
running-apps() {
    applications=()

    # loop through all open windows (ids)
    for win_id in $( wmctrl -l | cut -d' ' -f1 ); do 

        # test if window is a normal window
        if  $( xprop -id $win_id _NET_WM_WINDOW_TYPE | grep -q _NET_WM_WINDOW_TYPE_NORMAL ) ; then 

            # filter application name and remove double-quote at beginning and end
            appname=$( xprop -id $win_id WM_CLASS | cut -d" " -f4 )
            appname=${appname#?}
            appname=${appname%?}

            # add to result list
            applications+=( "$appname" ) 

        fi

    done

    # sort result list and remove duplicates  
    readarray -t applications < <(printf '%s\0' "${applications[@]}" | sort -z | xargs -0n1 | uniq)

    printf -- '%s\n' "${applications[@]}" 
}


# Function
git-add-all() {
git add *; git add .; git commit -am ${1}; git push
}



# Aliases to change cd not in subshell
alias pdfsearch.rb="ruby ~/scripts/pdfsearches/pdfsearch.rb"
alias pdfsearch.py="python3 ~/scripts/pdfsearches/pdfsearch.py"
alias pdfsearch.pl="perl -X ~/scripts/pdfsearches/pdfsearch.pl"
alias pdfsearch.lisp="clisp ~/scripts/pdfsearches/pdfsearch.lisp"
alias ls.py="python3 ~/scripts/python/ls.py"
alias please="sudo"
alias scripts="source scripts"
alias mytex="source mytex"
alias sherlock="python3 ${HOME}/sherlock/sherlock.py"
alias sudo-ods="sudo /Applications/OmniDiskSweeper.app/Contents/MacOS/OmniDiskSweeper"
alias get-ip="ipconfig getifaddr en0"
alias get-public-ip="curl ipinfo.io/ip"
alias system-data="system_profiler SPSoftwareDataType"

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


eval "$(thefuck --alias)"
# You can use whatever you want as an alias, like for Mondays:
eval $(thefuck --alias FUCK)
