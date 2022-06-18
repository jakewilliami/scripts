TARGET="release"  # or "debug"
cargo build --$TARGET
strip ./target/$TARGET/$(basename "$PWD")
cp -f ./target/$TARGET/$(basename "$PWD") ./
