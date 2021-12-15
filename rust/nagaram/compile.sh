curl -s https://raw.githubusercontent.com/github/linguist/master/lib/linguist/languages.yml > ./src/languages.yml
cargo build
strip ./target/debug/$(basename "$PWD")
cp -f ./target/debug/$(basename "$PWD") ./
