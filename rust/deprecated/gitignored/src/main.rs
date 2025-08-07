use std::path::PathBuf;
use std::process::{Command, Stdio};
use std::ffi::OsString;

fn main() {
	let curr_dir: PathBuf = std::env::current_dir().unwrap();
	let topmost_repo = topmost(&curr_dir.into_os_string()).unwrap();
	let ignored = find_ignored(topmost_repo).unwrap();
	for i in ignored.lines() {
		println!("{}", i);
	}
}

fn find_ignored(topmost_dir: String) -> Option<String> {
	// git ls-files '*.gitignore'
	let mut cmd = Command::new("git");
	cmd.arg("-C");
	cmd.arg(topmost_dir);
	cmd.arg("ls-files");
	cmd.arg("*.gitignore");
	let output = cmd
		.stdout(Stdio::piped())
		.output()
		.expect("Failed to execute `git ls-files`");
	
	if output.status.success() {
		let ignored_files = String::from_utf8_lossy(&output.stdout)
			.into_owned();
		return Some(ignored_files);
	} else {
		println!("An error has occured.  It is likely that you aren't in a git repository, or you may not have `git` installed.");
		return None;
	}
} 

fn topmost(dir: &OsString) -> Option<String> {
	// git rev-parse --show-toplevel
	let mut cmd = Command::new("git");
	cmd.arg("-C");
	cmd.arg(dir);
	cmd.arg("rev-parse");
	cmd.arg("--show-toplevel");
	let output = cmd
		.stdout(Stdio::piped())
		.output()
		.expect("Failed to execute `git rev-parse`");
	
	if output.status.success() {
		let mut toplevel_repo = String::from_utf8_lossy(&output.stdout)
			.into_owned();
		toplevel_repo.pop(); // remove trailing newline
		return Some(toplevel_repo);
	} else {
		println!("An error has occured.  It is likely that you aren't in a git repository, or you may not have `git` installed.");
		return None;
	}
}
