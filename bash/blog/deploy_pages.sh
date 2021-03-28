#! /bin/bash

# V2.0

# allow Ctrl+C to stop immediately
trap "exit" INT

# Set dir vars
TEMP_BACKUP_DIR="/tmp/pages_backup/"
PAGES_DIR="$HOME/projects/jakewilliami.github.io/"
SCRIPTS_DIR="$HOME/projects/scripts/"
BLOG_BIN_DIR="$SCRIPTS_DIR/bash/blog/"
BACKUP_DIR="$BLOG_BIN_DIR/backup-webserver/"

COMMIT_MESSAGE=""
if [[ -z "$1" ]]; then
	COMMIT_MESSAGE="Automatic master update"
else
	COMMIT_MESSAGE="$1"
fi

function notify_user() {
	echo -e "\u001b[1;34m===> \u001b[0;38m\u001b[1;38m$1\u001b[0;38m"
}

function notify_user_error() {
	echo -e "\u001b[1;38m===> \u001b[0;38m\u001b[1;31m$1\u001b[0;38m"
}

if [[ -z "$(git config --list | grep github.user)" ]]; then
	notify_user_error "Git credentials not set.  Please run"
	echo -e '\tgit config --global user.email "user@example.com"; git config --global user.name "username"'
	exit
fi

if [[ -z "$(command -v gsed)" ]]; then
	notify_user_error "Ensure you have gsed installed.  Exiting."
	exit
fi

if [[ "$(git rev-parse --abbrev-ref HEAD)" != "master" ]]; then
	SUCCESS=TRUE
	notify_user "Branch is not master; switching to master"
	git switch master || SUCCESS=FALSE
	if ! $SUCCESS; then
		notify_user_error "Could not switch branch to master.  Please do so manually."
		exit
	fi
	
	sleep 5
fi

notify_user "Moving current post data to separate backup dir"
CURRENT_MAX=$(ls "$BACKUP_DIR" | sort -nr | head -n1)
NEXT_BACKUP=$(printf %02d "$((10#$CURRENT_MAX + 1))")
# make next backup directory
mkdir "$BACKUP_DIR/$NEXT_BACKUP"
# cp backup items
cp -Rf "$PAGES_DIR/_posts/" "$BACKUP_DIR/$NEXT_BACKUP/_posts/"
cp -Rf "$PAGES_DIR/_wip/" "$BACKUP_DIR/$NEXT_BACKUP/_wip/"
cp -Rf "$PAGES_DIR/images/" "$BACKUP_DIR/$NEXT_BACKUP/images/"
cp -f "$PAGES_DIR/README.md" "$BACKUP_DIR/$NEXT_BACKUP/"
cp -f "$PAGES_DIR/_config.yml" "$BACKUP_DIR/$NEXT_BACKUP/"
cp -f "$PAGES_DIR/about.html" "$BACKUP_DIR/$NEXT_BACKUP/"
# delete this new backup if no different from old
if [[ -z $(diff -qr "$BACKUP_DIR/$CURRENT_MAX" "$BACKUP_DIR/$NEXT_BACKUP") ]]; then
	rm -rf "$BACKUP_DIR/$NEXT_BACKUP/"
fi

# change dir
notify_user "Changing directory to your blog directory within the subshell"
cd "$PAGES_DIR"
# make backup_dir
notify_user "Making backup directory"
if [[ -d "$TEMP_BACKUP_DIR/" ]]; then
	rm -rf "$TEMP_BACKUP_DIR/"
fi
mkdir "$TEMP_BACKUP_DIR/"
# cp backup items
notify_user "Coping items from pages directory to backup directory at $TEMP_BACKUP_DIR"
cp -Rf "$PAGES_DIR/_posts/" "$TEMP_BACKUP_DIR/_posts/"
cp -Rf "$PAGES_DIR/_wip/" "$TEMP_BACKUP_DIR/_wip/"
cp -Rf "$PAGES_DIR/images/" "$TEMP_BACKUP_DIR/images/"
cp -f "$PAGES_DIR/README.md" "$TEMP_BACKUP_DIR/"
cp -f "$PAGES_DIR/_config.yml" "$TEMP_BACKUP_DIR/"
cp -f "$PAGES_DIR/about.html" "$TEMP_BACKUP_DIR/"
# get chalk stuff
notify_user "Downloading Chalk template"
if [[ -d /tmp/chalk/ ]]; then
	rm -rf /tmp/chalk/
fi
git clone https://github.com/nielsenramon/chalk /tmp/chalk/
# move chalk stuff to pages dir
notify_user "Moving Chalk stuff to pages directory"
rm -rf "$PAGES_DIR/*"
rsync -a --delete /tmp/chalk/* "$PAGES_DIR/"
# move backup stuff back to pages dir
notify_user "Moving backup stuff back to pages directory"
rsync -a --delete "$TEMP_BACKUP_DIR/_posts/" "$PAGES_DIR/_posts/"
rsync -a --delete "$TEMP_BACKUP_DIR/_wip/" "$PAGES_DIR/_wip/"
rsync -a --delete "$TEMP_BACKUP_DIR/images/" "$PAGES_DIR/images/"
rsync -a --delete "$TEMP_BACKUP_DIR/README.md" "$PAGES_DIR/"
rsync -a --delete "$TEMP_BACKUP_DIR/_config.yml" "$PAGES_DIR/"
rsync -a --delete "$TEMP_BACKUP_DIR/about.html" "$PAGES_DIR/"
# make images
notify_user "Creating custom icons"
python3 "$BLOG_BIN_DIR/createicon.py"
# change branch if needed
if [[ "$(git rev-parse --abbrev-ref HEAD)" == "gh-pages" ]]; then
	notify_user "Switching back to master branch before deploying"
	git switch master
fi
# edit footer
notify_user "Editing footers"
gsed -i '/{% include footer.html %}/d' "$PAGES_DIR/_layouts/default.html"
gsed -i '/{% include footer.html %}/d' "$PAGES_DIR/_layouts/post.html"
# edit deploy script
notify_user "Editing deploy script"
gsed -i 's/if [ `git branch | grep gh-pages` ]/if [[ $(git branch | grep gh-pages) ]]/g' "$PAGES_DIR/bin/deploy"
# push master to GH
if git -C "$PAGES_DIR" diff-index --quiet HEAD --; then
    :
else
	SUCCESS=TRUE
	notify_user "Pushing changes to master"
    git add . || SUCCESS=FALSE
	git commit -am "$COMMIT_MESSAGE" || SUCCESS=FALSE
	git push || SUCCESS=FALSE
	if $SUCCESS; then
		notify_user "Successfully updated master"
	else
		notify_user_error "Something went wrong..."
	fi
fi
# setup and deploy
notify_user "Setting up to deploy pages"
"$PAGES_DIR"/bin/setup
notify_user "Deploying pages"
"$PAGES_DIR"/bin/deploy
# done
notify_user "Done!"
