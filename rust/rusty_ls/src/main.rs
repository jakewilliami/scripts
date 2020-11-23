//run using cd /Users/jakeireland/scripts/rust/rusty_ls/ && cargo run /Users/jakeireland/scripts/

// first started here: https://github.com/jakewilliami/scripts/commit/c1fa3f8cd30e3782d50893fdc1d5d0333f59e234#diff-0c28a566862bd749bb1337e0c99d4f09315c6d8350dcf08dbcb18e29c498240b

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

fn main() {
	let dir = "/Users/jakeireland/Desktop/".to_string();
	read_directory(dir);
}

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
