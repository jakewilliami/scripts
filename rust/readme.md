<h1 align="center">
Scripts for Rust
</h1>


## Description
I have created a separate directory for [Rust](https://www.wikiwand.com/en/Rust_(programming_language)) in order to make gitignores a little bit easier (as I don't want to count the `make` files in my language breakdown&mdash;see also `gl -l`).

I have renamed `rusty_ls/main.rs` to `rusty_ls/ls.rs`.  I first started using Rust in early October, 2019.

## Getting Started
On macOS, run
```
brew install rust
```
On Fedora:
```
sudo dnf install rust
```
On Debian:
```
sudo apt install rustc
```
And on Arch:
```
sudo pacman -S rust
```

## Notes on use of Rust
### Small standalone
Sometimes I feel that projects are overkill.  Simply do
```bash
emacs main.rs # write some code
rustc main.rs && ./main
```

### Project
To create a new Rust project, you should run
```bash
PROJNAME="<name of project>" && \
cd ~/projects/scripts/rust && \
cargo init --bin ${PROJNAME} && \
cd ${PROJNAME}/ && \
cargo run src/main.rs  // invokes `rustc` behind the scenes
```
or
```bash
PROJNAME="<name of project>" && \
cd ~/projects/scripts/rust && \
cargo new ${PROJNAME}
```
If you need to download a Rust library, you must first clone it, and then
```
PROJNAME="<name of project>" && \
cd ./${PROJNAME} && \
cargo build
```
To install binaries, use 
```
cargo install --path .
```
If you want to use a crate as a dependency, edit your `Cargo.toml`.  There is a third-party [Cargo subcommand](https://github.com/killercup/cargo-edit) called cargo-edit that makes it easier to edit your `Cargo.toml`:
```
cargo install cargo-edit
cd /path/to/project
cargo add <package you want to add to your rust project>
```
To run a project, either run
```bash
cargo run && ./main
```
or 
```bash
cargo build && ./main
```
or
```
rustc src/main.rs && ./main
```
