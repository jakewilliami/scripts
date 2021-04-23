use std::collections::HashMap;
use std::iter::Iterator;
// use std::path::{Path, PathBuf};
// use std::env;

// TODO
// check that a tab follows every }
// parse options like a good boy (like a good command line tool)

extern crate clap;
use clap::{Arg, App, SubCommand};



// #[warn(dead_code)]
// fn get_home_dir() {
//   let mut path: PathBuf = get_app_dir();
//   path.push(".config");
//   path.set_file_name("properties");
//   path.set_extension("ini");
//   let str_path = path.to_str().unwrap();
//   if str_path.len() != 0 && path_exists(&path) {
//     println!("Path {} exists", str_path);
//   }
// }

// #[warn(deprecated)]
// fn get_app_dir() -> PathBuf {
//     let dir: PathBuf = match env::home_dir() {
//         Some(path) => PathBuf::from(path),
//         None => PathBuf::from(""),
//     };
//     dir
// }
//
// pub fn path_exists(path: &PathBuf) -> bool {
//     return Path::new(&path).exists();
// }

fn find_value(map: &HashMap<Vec<String>, String>, value: String) -> Option<&str> {
    map.iter().find_map(|(key, val)| {
        if key.contains(&value) {
            Some(val.as_str())
        } else {
            None
        }
    })
}

fn main() {
	let args: Vec<String> = std::env::args().collect();

	let matches = App::new("emacs-help")
                       .version("v1.1")
                       .author("Jake W. Ireland. <jakewilliami@icloud.com>")
                       .about("A simply utility to help me with emacs commands")
						// .arg(Arg::with_name("help")
						// 	.short("h")
						// 	.long("help")
						// 	// .value_name("FILE")
						// 	.help("Shows help (present output).")
						// 	.takes_value(false)
						// 	.required(false)
						// 	.multiple(false)
					   	// )
						.arg(Arg::with_name("ALL")
							.short("a")
							.long("all")
							// .value_name("FILE")
							.help("Displays all help options")
							.takes_value(false)
							.required(false)
							.multiple(false)
					   	)
						.get_matches();

	// let srcfile = file!();
	// let srcdir = std::fs::read_dir(srcfile);
	// let helpfile = srcdir.unwrap().path().join("help.txt");
	let helpfile: &str = "/Users/jakeireland/projects/scripts/rust/emacs-help/src/help.txt";
	let helpdata = std::fs::read_to_string(helpfile)
		.expect(&format!("Something went wrong reading the help file at {}", helpfile).as_str());

	// let helpdata = std::fs::read_to_string(helpfile)
				// .expect(&format!("Something went wrong reading the help file at {}", helpfile).as_str());

	// read helpdata as vector
	let v: Vec<&str> = helpdata
		.split('\n')
		.filter(|s| !s.is_empty())
		.collect::<Vec<&str>>();
	// println!{"{:?}", v}
	// let hashm = v
	// // .map(|i| (i + i, i * i)) // equiv to Julia's Dict(i+i => i*i for i in range(1, 5))
	// .map(|i| i.split('\t'))
	// .collect::<std::collections::HashMap<_, _>>();

	// construct hashmap
	let mut map = HashMap::<Vec<String>, String>::new();
    for i in v {
		let s: Vec<&str> = i.split('\t').collect::<Vec<&str>>();
		// println!{"{:?}", s};
		// let tempj = s[0];
		let j: Vec<String> = s[0]
			.replace(&['{', '}'][..], "") // replace multiple at once; https://users.rust-lang.org/t/24554/2
			.split(", ")
			.map(str::to_owned)
			.collect::<Vec<String>>();
		let k = s[1];
        map.insert(j, k.to_owned());
    }
	// println!{"{:?}", hashm}
	
	// let args: Vec<String> = std::env::args().collect();
	
	// let f = args.map(|a| map.find(|&&i| i == a));
	// let f = map(|a| find_key_for_value(&map, a)).collect();
	// let a = &args[1];
	// println!("{:?}", a);
	// let f = map
	// 	.iter()
    //     .find_map(|(key, &val)| if &val == a { Some(key) } else { None });

	// if args.contains(&"all".to_string()) {
		// println!("{:?}", input);
		// for line in helpdata.split('\n').filter(|s| !s.is_empty()) {
			// println!("{}", line);
		// }
		// return;
	// }


	
	// println!("{:?}", get_app_dir());

	if matches.is_present("ALL") {
		// println!("{:?}", input);
		for line in helpdata.split('\n').filter(|s| !s.is_empty()) {
			println!("{}", line);
		}
	} else {
		// suppose we haven't got the command line argument
		let n = args.len();
		for i in 1..n {
			let a = &args[i];
			let f = find_value(&map, a.to_string());
			
			if f != None {
				println!("{}: {}", a, f.unwrap());
			}
			else {
				println!("{:?}", f)
			}
		}
	};
		
	return;
}

// fn in_gen() {
// 	input
//         .lines()
//         .map(|line| {
//             let v: Vec<&str> = line.split(" ").collect();
//             let bounds: Vec<&str> = v[0].split("-").collect();
//             Password{
//                 num1: bounds[0].parse().unwrap(),
//                 num2: bounds[1].parse().unwrap(),
//                 letter: v[1].chars().next().unwrap(),
//                 password: String::from(v[2])
//             }
//         })
//         .collect()
// }
//
// pub fn solve_part1(passwords: &[Password]) -> u32 {
//     passwords
//         .iter()
//         .fold(0, |count, entry| {
//             let letter_count = entry.password.matches(entry.letter).count() as u32;
//             count + if letter_count >= entry.num1 && letter_count <= entry.num2 {
//                 1
//             } else {
//                 0
//             }
//         })
// }
//
// pub fn solve_part2(passwords: &[Password]) -> u32 {
//     passwords
//         .iter()
//         .fold(0, |count, entry| {
//             let bytes = entry.password.as_bytes();
//             count + if (bytes[entry.num1 as usize - 1] as char == entry.letter) ^
//                        (bytes[entry.num2 as usize - 1] as char == entry.letter) {
//                 1
//             } else {
//                 0
//             }
//         })
// }
//
// pub fn solve_part1_no_generator(input: &str) -> u32 {
//     input
//         .lines()
//         .fold(0, |count, line| {
//             // let v: Vec<&str> = line.split(" ").collect();
//             // let bounds: Vec<&str> = v[0].split("-").collect();
//             // let min = bounds[0].parse().unwrap();
//             // let max = bounds[1].parse().unwrap();
//             // let letter = v[1].chars().next().unwrap();
//             // let password = String::from(v[2]);
//             let mut v = line.split(" ");
//             let mut bounds = v.next().unwrap().split("-");
//             let min = bounds.next().unwrap().parse().unwrap();
//             let max = bounds.next().unwrap().parse().unwrap();
//             let letter = v.next().unwrap().chars().next().unwrap();
//             let password = String::from(v.next().unwrap());
//             let letter_count = password.matches(letter).count() as u32;
//             count + if letter_count >= min && letter_count <= max {
//                 1
//             } else {
//                 0
//             }
//         })
// }
//
// #[aoc(day2, part2, no_generator)]
// pub fn solve_part2_no_generator(input: &str) -> u32 {
//     input
//         .lines()
//         .fold(0, |count, line| {
//             // let v: Vec<&str> = line.split(" ").collect();
//             // let bounds: Vec<&str> = v[0].split("-").collect();
//             // let index1: usize = bounds[0].parse().unwrap();
//             // let index2: usize = bounds[1].parse().unwrap();
//             // let letter = v[1].chars().next().unwrap();
//             // let password = String::from(v[2]);
//             let mut v = line.split(" ");
//             let mut bounds = v.next().unwrap().split("-");
//             let index1: usize = bounds.next().unwrap().parse().unwrap();
//             let index2: usize = bounds.next().unwrap().parse().unwrap();
//             let letter = v.next().unwrap().chars().next().unwrap();
//             let password = String::from(v.next().unwrap());
//             let bytes = password.as_bytes();
//             count + if (bytes[index1 - 1] as char == letter) ^
//                        (bytes[index2 - 1] as char == letter) {
//                 1
//             } else {
//                 0
//             }
//         })
// }
