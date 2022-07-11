<h1 align="center">
Scripts for Rust
</h1>


## Description
I have created a separate directory for [Rust](https://www.wikiwand.com/en/Rust_(programming_language)) in order to make gitignores a little bit easier (as I don't want to count the `make` files in my language breakdown&mdash;see also `gl -l`).

I have been wanting to work with Rust [for a while now](https://github.com/jakewilliami/scripts/issues/21); I must have come across it at a similar time to Julia.

I have renamed `rusty_ls/main.rs` to `rusty_ls/ls.rs`.  I first started using Rust in early October, 2019.  `rusty_ls` is my starting project (as I have tried to do in python and c), and `pere` (short for *перечислять* [*perechislyat'*]) is my second attempt at the project.

## Getting Started
On macOS, run
```bash
brew install rust
```
On Fedora:
```bash
sudo dnf install rust
```
On Debian:
```bash
sudo apt install rustc
```
And on Arch:
```bash
sudo pacman -S rust
```

Alternatively you can install [`rustup`](https://rustup.rs/).  To do so on my macOS machine, I had to run the following[[1]](https://github.com/rust-lang/cargo/issues/6757#issuecomment-478042168):
```bash
sudo chown -R $(whoami) /Users/jakeireland/.cargo/
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
As I was having permission errors with my `rustup` install.  (So installing `rustup`, I had to `brew uninstall rust` first.  I still had access to the `cargo` and `rustc` binaries after installing `rustup`.

For Rust Language support, download `rustup` (cannot be downloaded alongside Rust; must use `rustup` to download Rust), and follow install instructions for `rls` [here](https://github.com/rust-lang/rls).

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
cargo run src/main.rs
```
or 
```bash
cargo build && ./target/debug/main
```
or
```
rustc src/main.rs && ./main
```

### Cargo Utilities

Similar to `cargo-edit`, there are some really nice Cargo utilities such as `cargo-fmt`, `cargo-outdated`, `cargo-tree`, `cargo-readme`, and `cargo-benchcmp`.

`cargo-tree` has a really nice feature that can list, for each dependency, why it is there: `cargo tree --features serde_json -p libc -i`.

## Binary Size

https://github.com/johnthagen/min-sized-rust
