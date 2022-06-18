#!/usr/bin/env bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )"
declare -a DOTFILES=("$HOME/.bash_profile" "$HOME/.bashrc" "$HOME/.emacs" "$HOME/.vimrc" "$HOME/.tmux.conf")

for dotfile in "${DOTFILES[@]}"; do
	cp -vi "$dotfile" "$SCRIPT_DIR"
done

