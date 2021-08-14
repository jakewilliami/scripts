mod languages;
mod status;
mod log;

use std::env;

extern crate clap;
use clap::{Arg, App, SubCommand};

// needed for log.rs
extern crate colored;
extern crate regex;

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
								.short("n")
								.long("number")
								// .value_name("FILE")
								.help("Given a number, will print the last n commits nicely.")
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
		let n: usize = matches.value_of("LOGNUMBER").unwrap()
			.parse().unwrap();
		log::get_git_log(n);
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
	
	// ArgMatches { args: {}, subcommand: None, usage: Some("USAGE:\n    gl [FLAGS]") }
	
	// println!("{:?}", git_languages);
	
	return;
}
