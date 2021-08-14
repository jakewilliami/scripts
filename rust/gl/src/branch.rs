use std::process::{Command, Stdio};

pub fn get_branch_names() {
	let branch_names: Option<String> = branch_names();
	if !branch_names.is_none() {
		let mut stripped_branch_names = branch_names.unwrap();
		if stripped_branch_names.ends_with('\n') {
			stripped_branch_names.pop();
			if stripped_branch_names.ends_with('\r') {
            	stripped_branch_names.pop();
        	}
		}
		for b in stripped_branch_names.split_terminator('\n') {
			println!("{}", b);
		}
	}
}

pub fn current_branch() -> Option<String> {
	let mut cmd = Command::new("git");
	cmd.arg("rev-parse");
	cmd.arg("--abbrev-ref");
	cmd.arg("HEAD");
	let output = cmd
		.stdout(Stdio::piped())
		.output()
		.expect("Failed to execute `git branch`");
	
	if output.status.success() {
		let mut current_branch_name = String::from_utf8_lossy(&output.stdout).into_owned();
		if current_branch_name.ends_with('\n') {
			current_branch_name.pop();
			if current_branch_name.ends_with('\r') {
            	current_branch_name.pop();
        	}
		}
		return Some(current_branch_name);
	} else {
		return None
	}
}

fn branch_names() -> Option<String> {
	let mut cmd = Command::new("git");
	cmd.arg("branch");
	cmd.arg("--color");
	let output = cmd
		.stdout(Stdio::piped())
		.output()
		.expect("Failed to execute `git branch`");
	
	if output.status.success() {
		let branch_names = String::from_utf8_lossy(&output.stdout).into_owned();
		return Some(branch_names);
	} else {
		return None
	}
}

/* This code is old and tired, as I misunderstood the output of `git branch`
pub fn current_branch_name() -> Option<String> {
    let mut cmd = Command::new("git");
	cmd.arg("branch");
	cmd.arg("--color");
	let output = cmd
		.stdout(Stdio::piped())
		.output()
		.expect("Failed to execute `git branch`");
	
	if output.status.success() {
		let git_log = String::from_utf8_lossy(&output.stdout);
		// .chars();
		// let mut git_log = &output.stdout.chars();
		// chars.rev().nth(1); // n - 1 to get n characters from end
		// skip the first two characters of the string, as that is a star and a space
		// e.g., "* master", but we just want "master"
		 // git_log.next();
		 // git_log.next();
			
		// println!("{:?}", git_status);
		for l in git_log.split_terminator("\n") {
			// let mut l_chars = l.chars();
			let first_c = &l.chars().nth(0).unwrap();
			if *first_c == '*' {
				// return (&l[2..]).to_string();
				// let mut l_chars = &l.chars
				// l_chars.next();
				// l_chars.next();
				// in case, for some weird reason, start does not start at the second index, we account for that
				let start: usize = l.char_indices().map(|(i, _)| i).nth(2).unwrap();
				return Some(l[start..].to_string());
			}
			// return (&l[2..]).to_string();
			// return " ".to_string();
		}
		// return "".to_string();
		return None;
		// return git_log
		// return (&git_log[2..]).to_string();
	} else {
		println!("An error has occured.  It is likely that you aren't in a git repository, or you may not have `git` installed.");
		// return "".to_string();
		return None;
	}
}
*/
