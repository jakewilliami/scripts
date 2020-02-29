<h1 align="center">
Scripts for Rust
</h1>


## Description
I have created a separate directory for [Rust](https://www.wikiwand.com/en/Rust_(programming_language)) in order to make gitignores a little bit easier (as I don't want to count the `make` files in my language breakdown&mdash;see also `gl -l`).

To create a new Rust project, you should run
```
PROJNAME="<name of project>"
cd ~/scripts/rust && \
cargo init --bin ${PROJNAME} && \
cd ${PROJNAME}/ && \
cargo run src/main.rs
```
