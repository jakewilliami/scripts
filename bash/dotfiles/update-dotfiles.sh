#!/usr/bin/env bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )"
declare -a DOTFILES=(
	"$HOME/.bash_profile"
	"$HOME/.bashrc"
	"$HOME/.emacs"
	"$HOME/.vimrc"
	"$HOME/.tmux.conf"
	"$HOME/.alacritty.yml"
)

for fsrc in "${DOTFILES[@]}"; do
	fdst="$SCRIPT_DIR/$(basename "$fsrc")"
	if [ ! -f "$fdst" ] || ! cmp -s "$fsrc" "$fdst"; then
		cp -vi "$fsrc" "$SCRIPT_DIR"
	fi
done

