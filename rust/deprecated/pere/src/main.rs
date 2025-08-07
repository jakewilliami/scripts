// my modules
// mod languages;
mod hex2iterm256;

// stdlib imports
use std::collections::HashMap;
use std::fs::metadata;
use std::ffi::OsStr;
use std::path::Path;

// crates imports
extern crate clap;
use clap::{Arg, App, SubCommand};
// extern crate colors_transform;
// use colors_transform::{Rgb, Color, Hsl};
extern crate walkdir;
use walkdir::WalkDir;
extern crate serde_yaml;
use serde_yaml::Value;

// TODO: ensure convert ext to lowercase
// TODO: something to do with dir read permissions?

fn print_type_of<T>(_: &T) {
    println!("{}", std::any::type_name::<T>())
}

// static BASE_DIR: &str = "/Users/jakeireland/projects/";
static DEFAULT_DEPTH: usize = 2;
static LANGUAGE_FILE: &str = "/Users/jakeireland/projects/scripts/rust/pere/src/languages.yml";
static TEXT_COLOUR: &str = "\u{001b}[0;38m";

fn main () {
	// defaults
	// let dirname: &str = ".";
	// let level: usize = 3;
	
	let matches = App::new("pere")
                      .version("1.0")
                      .author("Jake W. Ireland. <jakewilliami@icloud.com>")
                      .about("Lists directories and files how I like.  Name short for перечислять or (perechislyat'); that is, to enumerate/list.\n\nThe <DIR> argument defaults to your current directory.")
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
								// .short("d")
								// .long("dir")
								.index(1)
								.help("Descend starting at dir.")
								// .takes_value(true)
								.required(false)
								.multiple(false)
							)
							.arg(Arg::with_name("ALL")
								.short("a")
								.long("all")
								// .value_name("FILE")
								.help("Descend all levels from specified directory")
								.takes_value(false)
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
	// 	parse_language_data();
	// };
	//
	// if matches.is_present("STATUS") {
	// 	status::get_git_status();
	// };
	
	// // https://github.com/github/linguist/blob/master/lib/linguist/languages.yml
	// let language_data: serde_yaml::Mapping = parse_languages(LANGUAGE_FILE);
	// // for i in language_data.into_iter() {
	// 	// println!("{:?}", i.0);
	// 	// println!("{:?}", language_data[i]["extensions"]);
	// // }
	// let language_names = language_data.into_iter().map(|i| i.0).collect::<Vec<_>>();
	//
	// let mut map = HashMap::<String, String>::new();
	//
	// // for l in language_data.into_iter() {
	// // 	let lname: String = l.0;
	// // 	let ccode: String = l[lname][extensions];
	// // 	println!("{:?}", ccode);
	// // }
	
	// default to current directory
	let dirname: &str = matches.value_of("DIR").unwrap_or(".");
	// let level: usize = DEFAULT_DEPTH
	// let level: usize = matches.value_of("LEVEL").unwrap_or(DEFAULT_DEPTH).parse().unwrap();
	// let level: usize = matches.value_of("LEVEL").unwrap_or("")
	
	let level: usize;
	
	if matches.is_present("LEVEL") {
		level = matches.value_of("LEVEL").unwrap().parse().unwrap();
	} else {
		level = DEFAULT_DEPTH;
	}
	
	// if matches.is_present("DIR") {
	// }
	
	let colmap: HashMap::<String, String> = construct_language_map(LANGUAGE_FILE);
	
	if matches.is_present("ALL") {
		// if all is present the we no longer care about the level argument
		// walkdir all the way
		for entry in WalkDir::new(dirname)
			.into_iter()
			.filter_map(|e| e.ok()) {
			
			if entry.depth() == 0 {
				continue
			}
			
			let pathname = entry.path();
			let isdir: bool = metadata(pathname).unwrap().is_dir();
			println!("{:?}", pathname);
	    	// println!("{}", entry?.path().display());
		}
	} else {
		for entry in WalkDir::new(dirname)
			.max_depth(level)
			.into_iter()
			.filter_map(|e| e.ok()) {
			
			if entry.depth() == 0 {
				continue
			}
			// println!("{:?}", print_type_of(&entry));
			let pathname = entry.path();
			// let isdir: bool = metadata(pathname).unwrap().is_dir();
			// println!("{:?}", pathname);
			parse_path(entry, &colmap);
	    	// println!("{}", entry?.path().display());
		}
	}
	
	
	// for entry in WalkDir::new(DIRNAME).into_iter().filter_map(|e| e.ok()) {
	// 	let pathname = entry.path();
	// 	let isdir: bool = metadata(pathname).unwrap().is_dir();
	// 	println!("{:?}", isdir);
    // 	// println!("{}", entry?.path().display());
	// }
	
	// println!("{:?}", language_names);
	// println!("{:?}", language_data["."]["extensions"]);
	
	
}

fn parse_path(p: walkdir::DirEntry, colmap: &HashMap::<String, String>) {
	let depth: usize = p.depth();
	let indent: String = "\t".repeat(depth - 1);
	let pname: &OsStr = p.file_name();
	// let isdir: bool = metadata(p.path()).unwrap().is_dir();
	let isdir: bool = p.file_type().is_dir();
	let ext: Option<&OsStr> = if isdir {Path::new(&pname).extension()} else {None};
	// let ext: Option<&OsStr> = Path::new(&pname).extension();
	// print_type_of(&pname);
	// println!("{}We are at depth {:?} for file {:?}, which is dir {:?}, with extension {:?}", indent, depth, pname, isdir, ext);
	
	
}

fn parse_languages(datafile: &str) -> serde_yaml::Mapping {
	let f = std::fs::File::open(datafile).unwrap();
	let data: serde_yaml::Mapping = serde_yaml::from_reader(f).unwrap();
	
	return data;
}

fn construct_language_map(datafile: &str) -> HashMap::<String, String> {
	// https://github.com/github/linguist/blob/master/lib/linguist/languages.yml
	let language_data: &serde_yaml::Mapping = &parse_languages(datafile);
	// let language_names: Vec<serde_yaml::Value> = language_data.into_iter().map(|i| i.0).collect::<Vec<_>>();
	
	// print_type_of(&language_names);
	
	let mut colmap = HashMap::<String, String>::new();
	
	// We want to construct a hashmap with extensions in the keys, so that we can quickly reference it
	// We actually don't care about the name of the lanuguage
	// In previous implementations we would care about the name, to reference out textcolours.json, but now we only care about extension and hex colour code.
	for l in language_data.into_iter() {
		// let mut ext_hex_map = HashMap::<&serde_yaml::Value, &serde_yaml::Value>::new();
		// let exts = &l.1["extensions".to_string()].to_vec();
		let default_exts = &serde_yaml::Value::Sequence(vec![]);
		let exts = l.1.get("extensions").unwrap_or(default_exts);
		let lname: &str = l.0.as_str().unwrap();
		// let lname: serde_yaml::Mapping = &1.0;
		let default_ccode = &serde_yaml::Value::String(TEXT_COLOUR.to_string());
		let hexcode = l.1.get("color").unwrap_or(default_ccode);
		let rgbcode = Rgb::from_hex_str(hexcode.as_str().unwrap()).unwrap();
		// print_type_of(exts);
		
		for e in exts.as_sequence().unwrap() {
			println!("{:?} => {:?}", e, rgbcode);
			colmap.insert(
				e.as_str().unwrap().to_string(),
				ccode.to_string()
			);
		}
		// print_type_of(&l.0);
		// println!("{:?} => {:?}", l.0.as_str().unwrap(), exts);
		// colmap.insert(lname, exts);
	}
	
	return colmap;
}

// (String("xBase"), Mapping(Mapping { map: {String("type"): String("programming"), String("color"): String("#403a40"), String("aliases"): Sequence([String("advpl"), String("clipper"), String("foxpro")]), String("extensions"): Sequence([String(".prg"), String(".ch"), String(".prw")]), String("tm_scope"): String("source.harbour"), String("ace_mode"): String("text"), String("language_id"): Number(PosInt(421))} }))
