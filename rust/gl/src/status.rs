use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};

static BASE_DIR: &str = "/Users/jakeireland/projects/";

pub fn get_status(dir: &PathBuf) -> String {
    let mut cmd = Command::new(format!("git -C {} status --short --branch", dir.as_path().display().to_string()));
	println!("{:?}", cmd);
	let output = cmd
		.stdout(Stdio::piped())
		.output()
		.expect("Failed to execute `git status`");
	
	if output.status.success() {
		let git_status = String::from_utf8_lossy(&output.stdout)
			.into_owned();
		// println!("{:?}", git_status);
		return git_status;
	} else {
		println!("An error has occured.  It is likely that you aren't in a git repository, or you may not have `git` installed.");
		return "".to_string();
	}
}

pub fn parse_global() {
    let input = std::fs::read_to_string(format!("{}/scripts/rust/gl/src/global.txt", BASE_DIR))
        .expect("Something went wrong reading the input file");
    let v: Vec<&str> = input
        .split('\n')
        .filter(|s| !s.is_empty())
        .collect::<Vec<&str>>();
	
	// let path: PathBuf = [r"C:\", "windows", "system32.dll"].iter().collect();
	
	for r in v {
		let constructed_path: &str = &format!("{}/{}/", BASE_DIR, r);
		let git_repo: PathBuf = PathBuf::from(constructed_path);//.as_os_str();
		// println!("{:?}", git_repo);
		println!("{:?}", get_status(&git_repo));
	};
}
