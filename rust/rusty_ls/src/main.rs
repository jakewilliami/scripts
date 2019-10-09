//run using cd /Users/jakeireland/bin/scripts/rust/rusty_ls/ && cargo run /Users/jakeireland/bin/scripts/

//#[macro_use]
extern crate structopt;

use std::fs;
//use std::path::Path;
use std::error::Error;
use std::process;
use structopt::StructOpt;
use std::path::PathBuf;

#[derive(StructOpt, Debug)]
struct Opt {
	/// Output file
	#[structopt(default_value = ".", parse(from_os_str))]
	path: PathBuf,
}

fn main() {
	let opt = Opt::from_args();
	if let Err(ref e) = run(&opt.path) {
			println!("{}", e);
			process::exit(1);
	}
}

fn run(dir: &PathBuf) -> Result<(), Box<dyn Error>> {
	if dir.is_dir() {
		for entry in fs::read_dir(dir)? {
				let entry = entry?;
				let file_name = entry
						.file_name()
						.into_string()
						.or_else(|f| Err(format!("Invalid entry: {:?}", f)))?;
				println!("{}", file_name);
		}
	}
	Ok(())
}

//cd ~/bin/scripts/rust/ && \
//rustc ls.rs && \
//./ls && \
//cd ./../