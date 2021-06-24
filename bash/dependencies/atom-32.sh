echo -e "${BWHITE}Downloading Atom dependencies.${BNORM}"

sudo apt-get install build-essential git libgnome-keyring-common libgnome-keyring0 fakeroot rpm libx11-dev libxkbfile-dev nodejs npm

echo -e "${BWHITE}Setting up Node.js.${BNORM}"

curl --silent --location https://deb.nodesource.com/setup_10.x | sudo bash -

echo -e "${BWHITE}Cloning the Atom GitHub repository.${BNORM}"

cd

git clone https://github.com/atom/atom

echo -e "${BWHITE}Getting latest Atom release.${BNORM}"

cd atom/

git fetch -p

git checkout $(git describe --tags `git rev-list --tags --max-count=1`)

echo -e "${BWHITE}Building and installing Atom.${BNORM}"

cd atom

sudo script/build --create-debian-package 
