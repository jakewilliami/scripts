trap "exit" INT

MODE="debug" # previously: "release"
D="$(basename "$PWD")"
F="${D%%.*}"
cargo build #--$MODE
strip ./target/"$MODE"/"${F}-rs"
cp -f ./target/"$MODE"/"${F}-rs" ./"$D"

