//run using cd /Users/jakeireland/scripts/rust/rusty_ls/ && cargo run /Users/jakeireland/scripts/

// first started here: https://github.com/jakewilliami/scripts/commit/c1fa3f8cd30e3782d50893fdc1d5d0333f59e234#diff-0c28a566862bd749bb1337e0c99d4f09315c6d8350dcf08dbcb18e29c498240b

use std::fs::read_to_string;
use std::collections::HashMap;
// use std::iter::Iterator;
use json;

// fn get_languages() -> Result<()> {
	// let parsed = json::parse("/Users/jakeireland/projects/scripts/bash/colours/textcolours.json");
	// return parsed;
// }

// fn print_type_of<T>(_: &T) {
//     println!("{}", std::any::type_name::<T>())
// }

// Result<json::value::JsonValue, json::error::Error>
pub fn parse_textcolours() -> json::JsonValue {
	let parsed =
		json::parse(&read_to_string("/Users/jakeireland/projects/scripts/bash/colours/textcolours.json").unwrap()).unwrap();
	// let parsed = get_languages();
	// let green_val = &parsed.unwrap()["BGREEN"].to_string();
	// println!("{:?}", parsed);
	
	// print_type_of(&parsed);
	// let mut map = HashMap::<Vec<String>, String>::new();
    // for line in &parsed.unwrap() {
	// 	// let s: Vec<&str> = i.split('\t').collect::<Vec<&str>>();
	// 	// let j: Vec<String> = s[0]
	// 	// let k = s[1];
	// 	let j =
    //     map.insert(j, k.to_owned());
    // }
	
	// println!("{:?}", map);
	
	return parsed;
	
}

fn construct_hashmap(text_colours: json::JsonValue) -> HashMap<String, String> {
	let mut map = HashMap::<String, String>::new();
	// println!("{:#?}", text_colours.entries());
	for line in text_colours.entries() {
		// println!("{:?}", line);
		let i: String = line.0.to_string();
		let j: String = line.1.to_string();
		map.insert(i, j);
	}
	
	return map;
}

fn get_lang_modifier<'a>(ext: &'a str, map: &'a HashMap<String, String>) -> Option<&'a String> {
	let m = match ext {
		"jl" => "JULIA",
		"rs" => "RUST",
		"c" | "h" | "h1" | "h2" | "1" | "3" | "8" | "in" => "C",
		"" | "sh" | "ahk" | "script" | "scpt" => "SHELL",
		"tex" | "sty" | "cls" => "TEX",
		"json" | "js" => "JAVASCRIPT",
		"pl" => "PERL",
		"py" | "pyc" | "pytxcode" => "PYTHON",
		"go" => "GO",
		"java" | "jar" => "JAVA",
		"rb" => "RUBY",
		"lua" => "LUA",
		"cpp" | "cc" | "dox" | "cmake" | "template" | "dtd" => "CPP",
		"lisp" => "LISP",
		"clisp" => "COMMONLISP",
		"elisp" => "EMACSLISP",
		"r" | "rscript" => "R",
		"ex" => "ELIXIR",
		"md" | "sgml" => "MARKDOWN",
		"sed" => "SED",
		"awk" => "AWK",
		"htm" | "html" | "h5" => "HTML",
		"ipynb" => "JUPYTERNOTEBOOK",
		"m" => "MATLAB",
		"css" => "CSS",
		"hs" => "HASKELL",
		"bat" => "BATCHFILE",
		"plist" | "xml" => "MARKDOWN",
		"applescript" => "APPLESCRIPT",
		"toml" | "efi" => "MARKDOWN",
		_ => "TEXT",
	};
	
	// if ext == "jl" {
	// 	// println!("{:?}", map.get("JULIA"));
	// 	return map.get("JULIA");
	// 	// print_type_of(&map.get("JULIA"));
	// }
	// // println!("{:?}", map.get("TEXT"));
	// return map.get("JULIA");
	
	return map.get(m);
}

//#[macro_use]
// extern crate structopt;

// use std::{fs, str}; // env
// use std::fs::metadata;
// use walkdir::{DirEntry, WalkDir};

//use std::path::Path;
// use std::error::Error;
// use std::process;
// use structopt::StructOpt;
// use std::path::PathBuf;

// #[derive(StructOpt, Debug)]
// struct Opt {
// 	/// Output file
// 	#[structopt(default_value = ".", parse(from_os_str))]
// 	path: PathBuf,
// }
//
// fn main() {
// 	let opt = Opt::from_args();
// 	if let Err(ref e) = run(&opt.path) {
// 			println!("{}", e);
// 			process::exit(1);
// 	}
// }
//
// fn run(dir: &PathBuf) -> Result<(), Box<dyn Error>> {
// 	if dir.is_dir() {
// 		for entry in fs::read_dir(dir)? {
// 				let entry = entry?;
// 				let file_name = entry
// 						.file_name()
// 						.into_string()
// 						.or_else(|f| Err(format!("Invalid entry: {:?}", f)))?;
// 				println!("{}", file_name);
// 		}
// 	}
// 	Ok(())
// }

//cd ~/scripts/rust/ && \
//rustc ls.rs && \
//./ls && \
//cd ./../

// use std::{fs, str}; // env
// use std::fs;
// use std::path;

fn read_directory(dir: String) { // -> std::io::Result<()>
	let i = 0;
    let paths = std::fs::read_dir(dir).unwrap();

    for path in paths {
		let path = path.unwrap();
		let attr = std::fs::metadata(path.path());
		if attr.unwrap().is_dir() {
			let i = i + 1;
			if i < 1 {
				let inner_path = path.path().into_os_string().into_string().unwrap();
				read_directory(inner_path);
			}
			else {
				std::process::exit(0x0100);
			}
		}
		else {
        	println!("Name: {}", path.path().display());
		}
    }
}

fn main() {
	// let text_colours: json::JsonValue = parse_textcolours();
	// let map: HashMap<String, String> = construct_hashmap(text_colours);
	// get_lang_modifier("jl", map)
	
	let dir = "/Users/jakeireland/Desktop/".to_string();
	read_directory(dir);
}



// fn walk_dir() -> Result<()> {
//     let current_dir = env::current_dir()?;
//     println!(
//         "Entries modified in the last 24 hours in {:?}:",
//         current_dir
//     );
//
//     for entry in fs::read_dir(current_dir)? {
//         let entry = entry?;
//         let path = entry.path();
//
//         let metadata = fs::metadata(&path)?;
//         let last_modified = metadata.modified()?.elapsed()?.as_secs();
//
//         if last_modified < 24 * 3600 && metadata.is_file() {
//             println!(
//                 "Last modified: {:?} seconds, is read only: {:?}, size: {:?} bytes, filename: {:?}",
//                 last_modified,
//                 metadata.permissions().readonly(),
//                 metadata.len(),
//                 path.file_name().ok_or("No filename")?
//             );
//         }
//     }
//
//     Ok(())
// }

// fn is_not_hidden(entry: &DirEntry) -> bool {
//     entry
//          .file_name()
//          .to_str()
//          .map(|s| entry.depth() == 0 || !s.starts_with("."))
//          .unwrap_or(false)
// }
//
// fn main() {
//     WalkDir::new(".")
//         .into_iter()
//         .filter_entry(|e| is_not_hidden(e))
//         .filter_map(|v| v.ok())
//         .for_each(|x| println!("{}", x.path().display()));
// }
