use std::process::{Command, Stdio};
use colored::*;
use regex::Regex;

pub fn get_git_log(n: usize) {
	let log: String = git_log(n);
	let colourised: Vec<String> = colourise_git_log(log);
	
	// for i in colourised.split_terminator("\n") {
	// 	println!("{}", i.replace("\"", ""));
	// }
	for l in colourised {
		println!("{}", l);
	}
}

fn colourise_git_log(log: String) -> Vec<String> {
	let re_named = Regex::new(r"<(?P<author>[^>]*)>").unwrap();
	let re = Regex::new(r"<([^>]*)>").unwrap();
	let mut out_log: Vec<String> = Vec::new();
	for l in log.split_terminator("\n") {
		let cleaned_l: String = l.replace("\"", "");
		let auth = re_named
			.captures(&cleaned_l)
			.unwrap()
			.name("author") // using named groups
			.unwrap()
			.as_str()
			.to_string();
			// .unwrap();
		// let re2 = Regex::new(r"<(?P<author>[^>]*)>").unwrap();
		// let new_auth = re2.replace(&cleaned_l, "<$author>".red());
		// TODO: do I need to use more regex here?  Can I not replace the regex to just match with the author's name (which we already obtained)?
		if auth == "jakewilliami" || auth == "Jake Ireland" || auth == "Jake W. Ireland" {
			// let re = Regex::new(r"<([^>]*)>").unwrap();
			let colourised_l = &re.replace(&cleaned_l, |caps: &regex::Captures| {
	    		format!("{}{}{}{}",
					"".normal().white(), // need this to clear the current line of any colours
					"<".truecolor(192, 207, 227), // this is the light blue colour I have, defined by \e[0m\e[36m$&\e[39m\e[0m
					&caps[1].truecolor(192, 207, 227),
					">".truecolor(192, 207, 227)
				)
			});
			out_log.push(colourised_l.to_string());
		} else {
			out_log.push(cleaned_l.to_string());
		}
		// let auth_colourised = new_auth.red();
		// l = &re2.replace(&l, "$author");
	}
	// let matched = re.find("phone: 111-222-3333").unwrap();
	return out_log;
}

fn git_log(n: usize) -> String {
	let mut n_str = String::new();
	n_str.push_str("-");
	n_str.push_str(&n.to_string().to_owned());
	
    let mut cmd = Command::new("git");
	cmd.arg("log");
	// cmd.arg("-c"); // fails when told to use color (need the --color flag)
	// cmd.arg("color.log=always");
	// cmd.arg("-C"); // fails when given a directory
	// cmd.arg(dir);
	cmd.arg("--color");
	cmd.arg("--no-merges");
	cmd.arg("--pretty=format:\"%C(bold yellow)%h%Creset -%C(bold green)%d%Creset %s %C(bold red)(%cr)%Creset %C(bold blue)<%an>%Creset\"");
	cmd.arg("--abbrev-commit");
	cmd.arg(&n_str);
		// .stdout(Stdio::piped())
		// 	.spawn()
		// 	.unwrap();
	// let colourised = Command::new("perl")
	// 	.arg("-pe")
	// 	.arg("
	//        ' if (/<([^>]*)>/)
	//            {
	//            if ( $1 eq \"jakewilliami\"  ||  $1 eq \"Jake Ireland\" || $1 eq \"Jake W. Ireland\" )
	//                { s/<$1>/\e[0m\e[36m$&\e[39m\e[0m/; }
	//            else
	//                { s/<$1>/\e[1m\e[34m$&\e[39m\e[0m/; }
	//        } '
	// ");
	// let cmd2 = Command::new("grep").arg("etc")
    //      .stdin(cmd.stdout.unwrap())
    //      .output()
    //      .unwrap_or_else(|e| { panic!("failed to execute process: {}", e) });
	// println!("{:?}", cmd);
	let output = cmd
		.stdout(Stdio::piped())
		.output()
		.expect("Failed to execute `git log`");
	
	if output.status.success() {
		let git_log = String::from_utf8_lossy(&output.stdout)
			.into_owned();
		// println!("{:?}", git_status);
		return git_log;
	} else {
		println!("An error has occured.  It is likely that you aren't in a git repository, or you may not have `git` installed.");
		return "".to_string();
	}
}
