#!/usr/bin/env bash
# 
# Script to sync dotfiles with the git repository.
# Can be used to sync them from your machine to the git
# repository, or from the repo to your local machine.
# 
# Usage:
# You can sync these files from the git repository
# to your machine using the "local" parameter:
# $ ./sync-dotfiles.sh local
# 
# You can sync the dotfiles from your machine, locally,
# to the git repository by either providing no arguments,
# or the "remote" argument:
# $ ./sync-dotfiles.sh
# $ ./sync-dotfiles.sh remote
# 
# This helper script was written by Jake Ireland
# (jakewilliami@icloud.com) in Winter, 2022.

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )"
declare -a DOTFILES=(
	"$HOME/.bash_profile"
	"$HOME/.bashrc"
	"$HOME/.emacs"
	"$HOME/.vimrc"
	"$HOME/.tmux.conf"
	"$HOME/.alacritty.yml"
	"$HOME/.config/fish/config.fish"
)

for fsrc in "${DOTFILES[@]}"; do
	fdst="$SCRIPT_DIR/$(basename "$fsrc")"
	if [ ! -f "$fdst" ] || ! cmp -s "$fsrc" "$fdst"; then
		case "$1" in
			(remote) cp -vi "$fsrc" "$SCRIPT_DIR";;
			(local)  cp -vi "$fdst" "$fsrc";;
			(*)      cp -vi "$fsrc" "$SCRIPT_DIR";;
		esac
	fi
done

