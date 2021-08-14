mod languages;
mod status;
mod log;
mod branch;
mod repo;
mod commitcount;

use std::env;

extern crate clap;
use clap::{Arg, App, SubCommand, value_t};

// needed for log.rs
extern crate colored;
extern crate regex;

// needed for commitcount
extern crate chrono;
// use chrono::prelude::*;

// TODO list (delete help commands as I go)
// -i | --issues		Prints currently open issues in present repository.
// -t | --tags | --labels	Lists this repository's issues' tags/labels .
// -f | --filtered-issues	Prints filtered issues by tag.  By default, prints issues tagged with "enhancement" unless stated otherwise.
// -e | --exclude-issues	Prints issues excluding issues that are tagged with "depricated" and "pdfsearch" unless stated otherwise.
// Also, I have notes on github-linguist which I could add to this app, maybe under a `help` subcommand?

fn main() {
	// map
	// 	.iter()
	// 	.map(|(key, val)| key);
	
	// println!("{:?}", map == text_colours);
	// println!("{:?}", map);
	
	let args: Vec<String> = env::args().collect();
	// println!("{:?}", args);
	
	let matches = App::new("gl")
                            .version("2.0")
                            .author("Jake W. Ireland. <jakewilliami@icloud.com>")
                            .about("Git log and other personalised git utilities.  By default (i.e., without any arguments), it will print the last 10 commits nicely.")
							// .arg(Arg::with_name("help")
							// 	.short("h")
							// 	.long("help")
							// 	// .value_name("FILE")
							// 	.help("Shows help (present output).")
							// 	.takes_value(false)
							// 	.required(false)
							// 	.multiple(false)
						   	// )
							.arg(Arg::with_name("LOGNUMBER")
								// TODO: as well as -n we should also be able to do -10, -100, -3, etc
								// .short("n")
								// .long("number")
								// .value_name("FILE")
								.help("Given a number, will print the last n commits nicely.")
								// .index(1)
								// .default_value("10")
								.takes_value(true)
								.required(false)
								.multiple(false)
						   	)
							.arg(Arg::with_name("LANGUAGES")
								.short("l")
								.long("languages")
								// .value_name("FILE")
								.help("Prints language breakdown in present repository.")
								.takes_value(false)
								.required(false)
								.multiple(false)
						   	)
							.arg(Arg::with_name("STATUS")
								.short("s")
								.long("status")
								// .value_name("FILE")
								.help("Prints current git status minimally.")
								.takes_value(false)
								.required(false)
								.multiple(false)
						   	)
							.arg(Arg::with_name("GLOBAL")
								.short("g")
								.long("global")
								// .value_name("FILE")
								.help("Gets git status for any dirty repositories, defined from file")
								.takes_value(false)
								.required(false)
								.multiple(false)
						   	)
							.arg(Arg::with_name("BRANCH")
								.short("b")
								.long("branch")
								// .value_name("FILE")
								.help("Prints the current branch name")
								.takes_value(false)
								.required(false)
								.multiple(false)
						   	)
							.arg(Arg::with_name("BRANCHES")
								.short("B")
								.long("branches")
								// .value_name("FILE")
								.help("Prints all branches in the current repository")
								.takes_value(false)
								.required(false)
								.multiple(false)
						   	)
							.arg(Arg::with_name("REPO")
								.short("r")
								.long("repo")
								// .value_name("FILE")
								.help("Prints the name of the current repository")
								.takes_value(false)
								.required(false)
								.multiple(false)
						   	)
							.arg(Arg::with_name("COMMITCOUNT")
								.short("c")
								.long("commit-count")
								// .value_name("FILE")
								.help("Counts the current number of commits on working branch on the current day")
								// .takes_value(true)
								.required(false)
								.multiple(false)
								.conflicts_with("COMMITCOUNTWHEN")
						   	)
							.arg(Arg::with_name("COMMITCOUNTWHEN")
								.short("C")
								.long("commit-count-when")
								// .value_name("FILE")
								.help("Counts the number of commits for a specified day.  Takes values \"today\" (see -c), \"yesterday\", or some number of days ago.")
								// TODO:
								//   If you give it 2 numbers, it will show the number of commits since the first number but before the second number (days ago).  E.g., given 5, 2, it will get the number of commits since 5 days ago, but before 2 days ago.  Given 5 and 1, it will get the number of commits in the last 5 days ago, no including anything since yesterday.  This can be done by calculating commits_since(5) - commits_since(2), etc.  To do this I need to figure out how to use multiple arguments, otherwise I will have to create a separate flag
								.takes_value(true)
								.required(false)
								// .multiple(true)
								.conflicts_with("COMMITCOUNT")
						   	)
							// .subcommand(SubCommand::with_name("test")
							// 			.about("controls testing features")
							// 			.version("1.3")
							// 			.author("Someone E. <someone_else@other.com>")
							// 			.arg_from_usage("-d, --debug 'Print debug information'"))
							.get_matches();

    // more program logic goes here...
	
	// let arg = matches.value_of("config");
	//
	// println!("{:?}", matches);
	
	// show the git log
	if matches.args.len() == 0 {
		let n: usize = 10;
		log::get_git_log(n);
		return;
	}
	if matches.is_present("LOGNUMBER") {
		// let n: usize = matches.value_of("LOGNUMBER").unwrap()
		// 	.parse().unwrap();
		let n = value_t!(matches, "LOGNUMBER", usize)
			.unwrap_or(0);
		if n != 0 {
			log::get_git_log(n);
		}
	}
	
	// show languages
	if matches.is_present("LANGUAGES") {
		// This parses _and_ prints the language output
		languages::parse_language_data();
	};
	
	// show status of git repo
	if matches.is_present("STATUS") {
		status::get_git_status();
		// for i in s.iter() {
			// println!("{}", i)
		// }
	};
	
	// show statuses of predefined git repos
	if matches.is_present("GLOBAL") {
		status::global_status();
	};
	
	// show branch name
	if matches.is_present("BRANCH") {
		let current_branch = branch::current_branch();
		if !current_branch.is_none() {
			println!("{}", current_branch.unwrap());
		}
	}
	
	// show branches
	if matches.is_present("BRANCHES") {
		branch::get_branch_names();
	}
	
	if matches.is_present("REPO") {
		let current_repo = repo::current_repository();
		if !current_repo.is_none() {
			println!("{}", current_repo.unwrap());
		}
	}
	
	// show commit count
	if matches.is_present("COMMITCOUNT") {
		commitcount::get_commit_count("today");
	}
	
	if matches.is_present("COMMITCOUNTWHEN") {
		// let since: isize;
		// let before: isize;
		let input_raw = matches.value_of("COMMITCOUNTWHEN");
		
		let input = input_raw.unwrap();
		// if &input == &"today" {
		// 	since = 0;
		// 	before = 0;
		// 	commitcount::get_commit_count(since, before, &input);
		// } else if &input == &"yesterday" {
		// 	since = 1;
		// 	before = 0;
		// 	commitcount::get_commit_count(since, before, &input);
		// } else {
		// 	println!("{:?}", input);
		// }
		commitcount::get_commit_count(&input);
	}
	
	// ArgMatches { args: {}, subcommand: None, usage: Some("USAGE:\n    gl [FLAGS]") }
	
	// println!("{:?}", git_languages);
	
	return;
}
