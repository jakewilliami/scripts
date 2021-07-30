curl -s https://raw.githubusercontent.com/github/linguist/master/lib/linguist/languages.yml > ./src/languages.yml
cargo build
strip ./target/debug/pere
cp -f ./target/debug/pere ./
