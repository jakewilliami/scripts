// use std::fs::read_to_st;
use std::path::{Path, PathBuf};
// use std::ffi::OsString;

const DOTFILE_LIST: &str = "/Users/jakeireland/projects/scripts/rust/dotf/src/dotfiles.txt";
const DOTFILES_DEST: &str = "/Users/jakeireland/projects/scripts/bash/dotfiles/";

fn main() {
	let dotfiles_as_str = std::fs::read_to_string(DOTFILE_LIST)
		.expect(&format!("Could not read file `{}`", DOTFILE_LIST));
	let dotfiles = dotfiles_as_str
		.lines()
		.collect::<Vec<&str>>();
	// iterate over dotfiles and copy them as required
	for dotfile in dotfiles {
		let fname = basename(&dotfile);
		println!("Copying {} to dotfiled directory", fname);
		let copy_res = std::fs::copy(dotfile, DOTFILES_DEST);
	}
}

fn basename(path_str: &str) -> String {
	let path = Path::new(&path_str);
	let path_basename = PathBuf::from(
		path.file_name().unwrap()
	);
	let basename_str: String = path_basename
		.into_os_string()
		.into_string()
		.unwrap();
	
	return basename_str;
}


