use std::process::{Command, Stdio};

pub fn get_git_log(n: usize) {
	let log: String = git_log(n);
	
	
	for i in log.split_terminator("\n") {
		println!("{}", i.replace("\"", ""));
	}
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
