// my modules
mod languages;
// mod recurse;

// stdlib imports
use std::collections::HashMap;
use std::fs::metadata;

// crates imports
extern crate clap;
use clap::{Arg, App, SubCommand};
extern crate colors_transform;
use colors_transform::{Rgb, Color, Hsl};
extern crate walkdir;
use walkdir::WalkDir;
// extern crate serde_yaml;
// use serde_yaml;

// TODO: ensure convert ext to lowercase

// static BASE_DIR: &str = "/Users/jakeireland/projects/";
static LANGUAGE_FILE: &str = "/Users/jakeireland/projects/scripts/rust/pere/src/languages.yml";
static DIRNAME: &str = ".";

fn main () {
	let matches = App::new("pere")
                      .version("1.0")
                      .author("Jake W. Ireland. <jakewilliami@icloud.com>")
                      .about("Lists directories and files how I like.  Name short for перечислять or (perechislyat'); that is, to enumerate/list.")
							// .arg(Arg::with_name("help")
							// 	.short("h")
							// 	.long("help")
							// 	// .value_name("FILE")
							// 	.help("Shows help (present output).")
							// 	.takes_value(false)
							// 	.required(false)
							// 	.multiple(false)
						   	// )
							.arg(Arg::with_name("DIR")
								.short("d")
								.long("dir")
								.help("Descend starting at dir.")
								.takes_value(true)
								.required(false)
								.multiple(false)
							)
							.arg(Arg::with_name("LEVEL")
								.short("L")
								.long("level")
								// .value_name("FILE")
								.help("Descend only level directories deep.")
								.takes_value(true)
								.required(false)
								.multiple(false)
						   	)
							// .subcommand(SubCommand::with_name("test")
							// 			.about("controls testing features")
							// 			.version("1.3")
							// 			.author("Someone E. <someone_else@other.com>")
							// 			.arg_from_usage("-d, --debug 'Print debug information'"))
							.get_matches();

	// let arg = matches.value_of("config");
	//
	// println!("{:?}", matches);

	// if matches.is_present("LANGUAGES") {
	// 	// This parses _and_ prints the language output
	// 	languages::parse_language_data();
	// };
	//
	// if matches.is_present("STATUS") {
	// 	status::get_git_status();
	// };
	
	// https://github.com/github/linguist/blob/master/lib/linguist/languages.yml
	let language_data: serde_yaml::Mapping = languages::parse_languages(LANGUAGE_FILE);
	// for i in language_data.into_iter() {
		// println!("{:?}", i.0);
		// println!("{:?}", language_data[i]["extensions"]);
	// }
	let language_names = language_data.into_iter().map(|i| i.0).collect::<Vec<_>>();
	
	let mut map = HashMap::<String, String>::new();
	
	// for l in language_data.into_iter() {
	// 	let lname: String = l.0;
	// 	let ccode: String = l[lname][extensions];
	// 	println!("{:?}", ccode);
	// }
	
	for entry in WalkDir::new(DIRNAME).into_iter().filter_map(|e| e.ok()) {
		let pathname = entry.path();
		let isdir: bool = metadata(pathname).unwrap().is_dir();
		println!("{:?}", isdir);
    	// println!("{}", entry?.path().display());
	}
	
	
	// println!("{:?}", language_names);
	// println!("{:?}", language_data["."]["extensions"]);
	
	
}
