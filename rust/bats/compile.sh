TARGET="release"  # or "debug"
FLAG=""
if [[ $TARGET != "debug" ]]; then
    FLAG="--$TARGET"
fi
cargo build $FLAG
strip ./target/$TARGET/$(basename "$PWD")
cp -f ./target/$TARGET/$(basename "$PWD") ./
