use std::fs::read_to_string;
use std::collections::HashMap;
// use std::iter::Iterator;
use json;
use std::process::{Command, Stdio};
use regex::Regex;
// use std::char::ToUppercase;

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

#[warn(dead_code)]
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

// -> Result<std::process::Output, std::io::Error>
fn get_languages() -> String {
// pub fn get_languages() -> std::borrow::Cow<'static, str> {
	let mut cmd = Command::new("github-linguist");
	let output = cmd
		.stdout(Stdio::piped())
		.output()
		.expect("Failed to execute `github-linguist`");
		// .unwrap();
		
	// let status = cmd
	// 	.status()
	// 	.expect("Failed to execute `github-linguist`");
	
	if output.status.success() {
		// println!("{:?}", status);
		// status: ExitStatus(ExitStatus(0))
			// .stdin(Stdio::null());
		// print_type_of(&github_linguist)
	
		// need this because output is a vector of i32 for some reason
		// use this line if you need valid utf8
		// let github_linguist = String::from_utf8(output.stdout)
		// 	.unwrap();
		// I was having ownership issues with this
		let github_linguist = String::from_utf8_lossy(&output.stdout)
			.into_owned();
	
		// println!("{:?}", output);
		// println!("{:?}", github_linguist);
		// print_type_of(&github_linguist);
		// let language_data =
		return github_linguist;
	
		// return github_linguist;
	} else {
		println!("An error has occured.  It is likely that you aren't in the top-most level of a GitHub repository.  Or you need to install `github-linguist` via Ruby.");
		// return String::from_utf8_lossy(b"");
		return "".to_string();
	}
}

pub fn parse_language_data() {
	let text_colours: json::JsonValue = parse_textcolours();
	let map: HashMap<String, String> = construct_hashmap(text_colours);
	let lang_data = get_languages();
	let languages = lang_data
		.split('\n')
		.filter(|s| !s.is_empty())
		.collect::<Vec<&str>>();
	
	for lang in languages {
		// lang.is_empty() && continue;
		let re = Regex::new("%[ ]+").unwrap();
		let mat: Vec<&str> = re.split(lang)
			.collect();
		let prop = format!("{}{}", mat[0], "%");
		let lang_name = mat[1];
		// This is where we transform the language obtained by git-linguist
		// To better match the languages in the language hashmap (i.e., the json file)
		let lang_name_transformed = lang_name
			.to_uppercase()
			.replace(&[' ', '-'][..], "")
			.replace('+', "P")
			.replace('#', "SHARP");
		let modifier = match map.get(&lang_name_transformed) {
			Some(x) => x,
			None => map.get("TEXT").unwrap(),
		};
		// println!("{:?}", lang_name);
		println!("{0: <0}{1: <8}{2: <0}\u{001b}[0;38m", modifier, prop, lang_name);
	}
		
	// println!("{:?}", languages);
}
