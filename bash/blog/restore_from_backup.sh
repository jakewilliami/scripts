#! /bin/bash

# WIP!!!

# allow Ctrl+C to stop immediately
trap "exit" INT

# Set dir vars
TEMP_BACKUP_DIR="/tmp/pages_backup/"
PAGES_DIR="$HOME/projects/jakewilliami.github.io/"
SCRIPTS_DIR="$HOME/projects/scripts/"
BLOG_BIN_DIR="$SCRIPTS_DIR/bash/blog/"
BACKUP_DIR="$BLOG_BIN_DIR/backup-webserver/"

function notify_user() {
	echo -e "\u001b[1;34m===> \u001b[0;38m\u001b[1;38m$1\u001b[0;38m"
}

function notify_user_error() {
	echo -e "\u001b[1;38m===> \u001b[0;38m\u001b[1;31m$1\u001b[0;38m"
}

BACKUP_NUM=""
if [[ ! -z "$1" ]]; then
    BACKUP_NUM="$1"
else
    notify_user_error "No backup number specified"
fi
