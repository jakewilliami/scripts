// extern crate colored;
// use colored::*;
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};
use std::ffi::OsString;
use std::str;

static BASE_DIR: &str = "/Users/jakeireland/projects/";

pub fn get_git_status() {
	// let red = "\u001b[0;31m";
	let curr_dir: PathBuf = std::env::current_dir().unwrap();
	let status: String = git_status(&curr_dir.into_os_string());
	// println!("{:?}", status);
	// THE FOLLOWING IS OUTDATED CODE, BEFORE I COULD CAPTURE THE COLOUR OUTPUT
	// for (i, s) in status.split_terminator('\n').enumerate() {
	// 	let mut print_str = String::new();
	// 	if i == 0 {
	// 		// ## master...origin/master
	// 		let s_split: Vec<&str> = s.split_terminator("...").collect();
	// 		let branch_name = &s_split[0][3..].green().to_string(); // e.g., master
	// 		let rest_of_line: Vec<&str> = s_split[1].split_terminator("/").collect();
	// 		// let origin_and_branch: Vec<&str> = rest_of_line.;
	//
	// 		let origin_and_branch = &s_split[1].red().to_string(); // e.g., origin/master
	//
	// 		print_str.push_str(&s_split[0][..3]);
	// 		print_str.push_str(branch_name);
	// 		print_str.push_str("...");
	//
	// 		print_str.push_str(origin_and_branch);
	// 	} else {
	// 		print_str.push_str(&s[..2].red().to_string());
	// 		print_str.push_str(&s[2..]);
	// 	}
	// 	println!("{}", print_str);
	// }
	println!("{}", status.trim_end())
}

fn git_status(dir: &OsString) -> String {
	// let mut os_string: OsString = "git -C ".into();
    // os_string.push(&dir);
    // os_string.push(" status --short --branch");
    // let mut cmd = Command::new(os_string);
	// println!("{:?}", cmd);
	let mut cmd = Command::new("git");
	cmd.arg("-c");
	cmd.arg("color.status=always");
	cmd.arg("-C");
	cmd.arg(dir);
	cmd.arg("status");
	cmd.arg("--short");
	cmd.arg("--branch");
	// println!("{:?}", cmd);
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

fn git_diff_exit_code(dir: &OsString) {
	// git diff-index --quiet HEAD --;
	let mut cmd = Command::new("git");
	// cmd.arg("-c");
	// cmd.arg("color.diff-index=always");
	cmd.arg("-C");
	cmd.arg(dir);
	cmd.arg("diff-index");
	cmd.arg("--quiet");
	cmd.arg("HEAD");
	cmd.arg("--");

	let output = cmd
		.stdout(Stdio::piped())
		.output()
		.expect("Failed to execute `git status`");
		
	
	// return output.status;
	
	// if output.status.success() {
	// 	let git_status = String::from_utf8_lossy(&output.stdout)
	// 		.into_owned();
	// 	// println!("{:?}", git_status);
	// 	return git_status;
	// } else {
	// 	println!("An error has occured.  It is likely that you aren't in a git repository, or you may not have `git` installed.");
	// 	return "".to_string();
	// }
}

pub fn global_status() {
	let mut input_file: OsString = BASE_DIR.into();
	input_file.push("/scripts/rust/gl/src/global.txt");
    let input = std::fs::read_to_string(input_file)
        .expect("Something went wrong reading the input file");
    let v: Vec<&str> = input
        .split('\n')
        .filter(|s| !s.is_empty())
		.filter(|s| s.get(..1).unwrap() != "#")
        .collect::<Vec<&str>>();
	
	// let path: PathBuf = [r"C:\", "windows", "system32.dll"].iter().collect();
	
	// println!("{:?}", v);
	
	for r in v {
		let mut constructed_path: OsString = BASE_DIR.into();
		constructed_path.push("/");
		constructed_path.push(r);
		constructed_path.push("/");
		// println!("Going to {:?}", constructed_path);
		// let git_repo: PathBuf = PathBuf::from(constructed_path);//.as_os_str();
		// let git_repo: PathBuf = PathBuf::from(format!());//.as_os_str();
		// println!("{:?}", git_repo);
		// println!("{:?}", git_status(&constructed_path));
		let status = git_status(&constructed_path);
		// let split_status = status.split_terminator('\n');
		let length_of_output: usize = status.split_terminator('\n').count(); // can also use .len()
		if length_of_output == (1 as usize) {
			// nothing to report
			continue;
		}
		println!("We are looking at {}", constructed_path.to_str().unwrap());
		println!("{}", status);
		// THE FOLLOWING IS OUTDATED, WHEN I DIDN'T REALISE WE COULD CAPTURE THE COLOUR OUTPUT OF STATUS
		// println!("We are looking at {}", r);
		// for (i, s) in status.split_terminator('\n').enumerate() {
		// 	let mut print_str = String::new();
		// 	if i == 0 {
		// 		// ## master...origin/master
		// 		let s_split: Vec<&str> = s.split_terminator("...").collect();
		// 		print_str.push_str(&s_split[0][..3]);
		// 		print_str.push_str(&s_split[0][3..].green().to_string());
		// 		print_str.push_str("...");
		// 		print_str.push_str(&s_split[1].red().to_string());
		// 	} else {
		// 		print_str.push_str(&s[..2].red().to_string());
		// 		print_str.push_str(&s[2..]);
		// 	}
		// 	if i == (length_of_output - 1) {
		// 		print_str.push_str("\n");
		// 	}
		// 	println!("{}", print_str);
		// }
	};
}

// 25 function parse_git_dirty {
// 26     status=$(git status 2>&1 | tee)
// 27     dirty=$(echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?")
// 28     untracked=$(echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?")
// 29     ahead=$(echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?")
// 30     newfile=$(echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?")
// 31     renamed=$(echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?")
// 32     deleted=$(echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?")
// 33     bits=''
// 34     if [ "${renamed}" == "0" ]; then
// 35         bits=">${bits}"
// 36     fi
// 37     if [ "${ahead}" == "0" ]; then
// 38         bits="*${bits}"
// 39     fi
// 40     if [ "${newfile}" == "0" ]; then
// 41         bits="+${bits}"
// 42     fi
// 43     if [ "${untracked}" == "0" ]; then
// 44         bits="?${bits}"
// 45     fi
// 46     if [ "${deleted}" == "0" ]; then
// 47         bits="x${bits}"
// 48     fi
// 49     if [ "${dirty}" == "0" ]; then
// 50         bits="!${bits}"
// 51     fi
// 52     if [ ! "${bits}" == "" ]; then
// 53         echo " ${bits}"
// 54     else
// 55         echo ""
// 56     fi
// 57 }

// use s.trim_end() instead
// fn trim_newline(s: &mut String) {
// 	if s.ends_with('\n') {
// 		s.pop();
// 		// account for windows
// 		if s.ends_with('\r') {
// 			s.pop();
// 		}
// 	}
// }
