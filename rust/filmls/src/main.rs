use std::{env, fs, io};
use std::path::{Path, PathBuf};
use std::ffi::OsStr;
use std::collections::HashMap;
use std::convert::TryInto;

use clap::{Arg, App};
use colored::*;
use regex::Regex;


// Set constant directories
const NAS_MEDIA_DIR: &str = "/mnt/Primary/Media/";
const MAC_MEDIA_DIR: &str = "/Volumes/Media/";
const FILMS_DIR_NAME: &str = "Films";
const SERIES_DIR_NAME: &str = "Series";


// Conditionally compiling functions for obtaining media directoried
// Source: https://doc.rust-lang.org/rust-by-example/attribute/cfg.html, https://doc.rust-lang.org/reference/conditional-compilation.html#target_os

#[cfg(any(target_os = "freebsd", target_os = "linux"))]
fn get_media_dir() -> PathBuf {
	std::path::PathBuf::from(NAS_MEDIA_DIR)
}

#[cfg(target_os = "macos")]
fn get_media_dir() -> PathBuf {
	std::path::PathBuf::from(MAC_MEDIA_DIR)
}

// Fallback on current dir
#[cfg(any(target_family = "windows", target_family = "wasm"))]
fn get_media_dir() -> PathBuf {
	std::env::current_dir().expect("Cannot get current directory")
}


// Define media source types

// Source: https://blog.filestack.com/thoughts-and-knowledge/complete-list-audio-video-file-formats/
const MEDIA_TYPES: [&str; 18] = ["mkv", "avi", "mp4", "webm", "mpg", "mp2", "mpeg", "mpe", "mpv", "ogg", "m4p", "m4v", "wmv", "mov", "qt", "flv", "swf", "avdchd"];
// Source: https://github.com/seanap/Plex-Audiobook-Guide/blob/master/Scripts/BookCopy.sh
const _AUDIOBOOK_TYPES: [&str; 20] = ["m4b", "mp3", "mp4", "m4a", "ogg", "pdf", "epub", "azw", "azw3", "azw4", "doc", "docx", "m4v", "djvu", "opf", "odt", "pdx", "wav", "mobi", "xls"];


// Main function

fn main() {
    let matches = App::new("filmls")
                      .version("1.4")
                      .author("Jake W. Ireland. <jakewilliami@icloud.com>")
                      .about("A command line interface for listing films in order of date")
					  .arg(Arg::with_name("FILMS")
							.help("Look in the film directory.  You can use this flag with -c.")
							.short("f")
							.long("films")
							.takes_value(false)
							.required(false)
							.multiple(false)
					  )
					  .arg(Arg::with_name("SERIES")
							.help("Look in the series directory.  You can use this flag with -c.")
							.short("s")
							.long("series")
							.takes_value(false)
							.required(false)
							.multiple(false)
					  )
					  .arg(Arg::with_name("COUNT")
							.help("Count the number of films or series in a directory.  Choose -f or -s for the programme to find the directory for you, otherwise specify a directory.")
							.short("c")
							.long("count")
							.takes_value(false)
							.required(false)
							.multiple(false)
					  )
					  .arg(Arg::with_name("TITLES")
							.help("Check if series have titles for each episode")
							.short("t")
							.long("titles")
							.takes_value(false)
							.required(false)
							.multiple(false)
					  )
					  .arg(Arg::with_name("CONSEC_SEASONS")
							.help("Check if series have consecutive seasons")
							.short("S")
							.long("consecutive-seasons")
							.takes_value(false)
							.required(false)
							.multiple(false)
					  )
					  .arg(Arg::with_name("COMPLETE_EPS")
							.help("Check if series have all episodes in each season")
							.short("e")
							.long("complete-episodes")
							.takes_value(false)
							.required(false)
							.multiple(false)
					  )
					  .arg(Arg::with_name("DIR")
					  		.help("Takes in an input directory.  Omitting this parameter will attempt to find the media directory.")
							.takes_value(true)
							.required(false)
							.multiple(false)
					  ).get_matches();
	
	// If there is no directory provided, we will use either a predefined media directory, or the current directory
	let mut dirname = get_media_dir();
	if matches.is_present("DIR") { 
		let input = matches.value_of("DIR");
		dirname = PathBuf::from(input.unwrap());
	}
	
	//// List films
	// If no arguments are passed, will list
	if matches.args.len() == 0 {
		// Get films directory if none provided
		let mut films_dir = dirname.clone();
		films_dir.push(FILMS_DIR_NAME);
		
		// This regex will match the year at the end of the film name
		let re = Regex::new(r"^.*\((\d{4})\).*$").unwrap();	
		// We want to store films in a hashmap with <film name -> year> so that
		// we can sort it by year
		let mut film_map = HashMap::<String, isize>::new();
		// read the directory
		// Ensure it is sorted by title before we sort by date
		// We need to do this because the order in which `read_dir` returns entries is not guaranteed. 
		// If reproducible ordering is required the entries should be explicitly sorted.
		let mut films: Vec<_> = fs::read_dir(&films_dir)
			.expect("Cannot read directory")
	        // .map(|res| res.map(|e|
			.map(|e| 
				e.expect("Cannot retreive file information")
					.path()
					// .expect("Cannot retreive file information")
					.file_name()
					.expect("Cannot get file name from file")
					.to_str()
					.unwrap()
					.to_string()
			)
	        .collect();
	
		films.sort();
		
		for film_name in films {
			// let film = film.expect("Cannot unwrap film information");
	        // let film_path = film.path();
			// let film_name = film.file_name()
				// .expect("Cannot get file name from film")
				// .to_str()
				// .unwrap()
				// .to_string();
			
			// initilaise the film to be zero
			// this way, the film will be first if there is no year
			let mut film_year: isize = 0;
			// if there's a match, update the year of the film
			// if film_name.contains(&re) {
			if re.is_match(&film_name) {
				let caps = re.captures(&film_name).unwrap();
				// film_year = film_name.captures(&re)
				film_year = caps.get(1)
					.unwrap()
					.as_str()
					.parse::<isize>()
					.unwrap();
			}
			// Update the hashmap
			film_map.insert(film_name, film_year);
		}
		
		/*
		// iterate over the sorted values (i.e., years) of the hashmap
		for val in film_map.values().sorted() {
			// key = find_key_for_value(&film_map, val).unwrap();
			
			// we need to do it like this so that if we have "Robin Hood (1997)" 
			// and "Robin Hood (2018)", we choose them both at the same time, but
			// print the earliest one first.  It's kind of like sorting by date
			// and then alphabetically
			for key in film_map.keys().sorted() {
				if film_map[key] == *val {
					println!("{}", key);
					break;
				}
			}
		}
		*/
		
		// Convert film info to vector of tuples (which is inherently ordered)
		// and sort said vector by the year
		let mut film_vec: Vec<_> = film_map.iter().collect();
		film_vec.sort_by(|a, b| b.1.cmp(a.1));
		
		for f in film_vec.into_iter().rev() {
			println!("{}", f.0.blue().bold());
		}
	} // end default arg
	
	//// Count films
	if matches.is_present("COUNT") && matches.is_present("FILMS") {
		let mut films_dir = dirname.clone();
		films_dir.push(FILMS_DIR_NAME);
		let cnt = count_media_files(&films_dir);
		println!("{}{}{}", "You have ".italic(), cnt.to_string().bold(), " films in your Plex Media Server.".italic());
	}
	
	//// Count series
	if matches.is_present("COUNT") && matches.is_present("SERIES") {
		let mut series_dir = dirname.clone();
		series_dir.push(SERIES_DIR_NAME);
		let season_re = Regex::new(r"^Season\s\d+$").unwrap();
		let mut cnt = 0;
		let series: Vec<_> = fs::read_dir(&series_dir)
			.expect(format!("Cannot read directory: {:?}", series_dir).as_str())
			.map(|e| 
				e.expect("Cannot retreive file information")
				 .path()
			)
	        .collect();
		for path in series {
			if path.is_dir() {
				let contents: Vec<_> = fs::read_dir(&path)
					.expect("Cannot read directory")
			        // .map(|res| res.map(|e|
					.map(|e| 
						e.expect("Cannot retreive file information")
							.path()
							// .expect("Cannot retreive file information")
							.file_name()
							.expect("Cannot get file name from file")
							.to_str()
							.unwrap()
							.to_string()
					)
			        .collect();
				/*
				let contents: Vec<_> = fs::read_dir(&path)
					.expect(format!("Cannot read directory: {:?}", series_dir).as_str())
					.map(|e| 
						e.expect("Cannot retreive file information")
						 .path()
						 .file_name()
						 .expect(format!("Cannot read file name from file {:?}", e).as_str())
						 .to_str()
						 .expect(format!("Cannot stringify file name {:?}", e).as_str())
					)
			        .collect();*/
				if contents.iter().any(|d| season_re.is_match(d)) {
					cnt += 1;
				}
			}
		}
		println!("{}{}{}", "You have ".italic(), cnt.to_string().bold(), " television series in your Plex Media Server.".italic());
	}
	
	
	//// Season utility functions
	
	//// Check if season episodes have titles
	if matches.is_present("TITLES") {
		let mut series_dir = dirname.clone();
		series_dir.push(SERIES_DIR_NAME);
		let season_re = Regex::new(r"^Season\s\d+$").unwrap();
		let ep_re = Regex::new(r"^(.*)\s\-\sS(\d+)E(\d+)(?:\s\-\s.*)\.(.*)$").unwrap();
		// Construct a hashmap for storing results
		let mut missing_ep_names_map = HashMap::<String, Vec<isize>>::new();
		// Get series available
		let series: Vec<_> = fs::read_dir(&series_dir)
			.expect(format!("Cannot read directory: {:?}", series_dir).as_str())
			.map(|e| 
				e.expect("Cannot retreive file information")
				 .path()
			)
	        .collect();
		// Search through series
		for path in series {
			let series_name_outer = &path.file_name().unwrap().to_str().unwrap().to_string();
			if path.is_dir() {
				missing_ep_names_map.insert(series_name_outer.to_string(), vec![]);
				let contents: Vec<_> = fs::read_dir(&path)
					.expect("Cannot read directory")
					.map(|e| 
						e.expect("Cannot retreive file information")
							.path()
							.file_name()
							.expect("Cannot get file name from file")
							.to_str()
							.unwrap()
							.to_string()
					)
			        .collect();
				// Search through series' seasons
				for season_dir in contents.iter().filter(|d| season_re.is_match(d)) {
					let mut season_dir_path = path.clone();
					season_dir_path.push(&season_dir);
					let season_content: Vec<_> = fs::read_dir(&season_dir_path)
						.expect("Cannot read directory")
						.map(|e| {
							e.expect("Cannot retrieve file information")
								.path().file_name().expect("Cannot get file name from file")
								.to_str().unwrap().to_string()
						}).collect();
					// Search through episodes
					for ep in season_content {
						if ep_re.is_match(&ep) {
							let caps = ep_re.captures(&ep).unwrap();
							// Check if episode has fifth group (implying it must have a fourth pertaining to ep name)
							if caps.get(5).is_none() {
								let series_name = caps.get(1).unwrap().as_str().to_string();
								let season_num = caps.get(2).unwrap().as_str().parse::<isize>().unwrap();
								if let Some(v) = missing_ep_names_map.get_mut(&series_name) {
								   (*v).push(season_num);
								}
								break;
							}
						}
					}
				}
			}
		}
		// Display results
		for (s, v) in missing_ep_names_map.iter() {
			if !v.is_empty() {
				println!("{}", &s.blue().bold())
			} /*else {
				println!("{}", &s.green())
			}*/
			let mut w = v.clone();
			w.sort();
			for si in w.iter() {
				println!("\t{}{}", "Season ".blue(), si.to_string().blue())
			}
		}
	}
	
	
	//// Alert on non-consecutive seasons
	if matches.is_present("CONSEC_SEASONS") {
		let mut series_dir = dirname.clone();
		series_dir.push(SERIES_DIR_NAME);
		let season_re = Regex::new(r"^Season\s(\d+)$").unwrap();
		// Construct a hashmap for storing results
		let mut missing_seasons_map = HashMap::<String, Vec<isize>>::new();
		// Get series available
		let series: Vec<_> = fs::read_dir(&series_dir)
			.expect(format!("Cannot read directory: {:?}", series_dir).as_str())
			.map(|e| 
				e.expect("Cannot retreive file information")
				 .path()
			)
	        .collect();
		// Search through series
		for path in series {
			let series_name_outer = &path.file_name().unwrap().to_str().unwrap().to_string();
			if path.is_dir() {
				missing_seasons_map.insert(series_name_outer.to_string(), vec![]);
				let contents: Vec<_> = fs::read_dir(&path)
					.expect("Cannot read directory")
					.map(|e| 
						e.expect("Cannot retreive file information")
							.path()
							.file_name()
							.expect("Cannot get file name from file")
							.to_str()
							.unwrap()
							.to_string()
					)
			        .collect();
				// Collect the season numbers within the series
				let season_numbers: Vec<isize> = contents.iter().filter_map(|d| {
					if season_re.is_match(d) {
						let caps = season_re.captures(&d).unwrap();
						if let Some(season_num) = caps.get(1) {
							Some(season_num.as_str().parse::<isize>().unwrap())
						} else {
							None
						}
					} else {
						None
					}
				}).collect();
				// Check if these are consecutive
				let max_se_num = season_numbers.iter().max().expect("Cannot determine maximum season number");
				// let is_consecutive = (1..=max_se_num).iter().all(|n| season_numbers.contains(n));
				for i in 1..=*max_se_num {
					if !season_numbers.contains(&i) {
						if let Some(v) = missing_seasons_map.get_mut(series_name_outer) {
							   (*v).push(i);
						}
					}
				}
			}
		}
		// Display results
		for (s, v) in missing_seasons_map.iter() {
			if !v.is_empty() {
				println!("{}", &s.blue().bold())
			} /*else {
				println!("{}", &s.green())
			}*/
			let mut w = v.clone();
			w.sort();
			for si in w.iter() {
				println!("\t{}{}", "Missing Season ".blue(), si.to_string().blue())
			}
		}
	}
	
	if matches.is_present("COMPLETE_EPS") { todo!() }
}

// fn find_key_for_value<'a>(map: &'a HashMap<i32, &'static str>, value: &str) -> Option<&'a i32> {
//     map.iter()
//         .find_map(|(key, &val)| if val == value { Some(key) } else { None })
// }

fn get_extension_from_filename(filename: &Path) -> Option<&str> {
	filename.extension()
		.and_then(OsStr::to_str)
}

fn count_media_files(dir: &Path) -> usize {
	fn recurse_files_count_if_media(dir: &Path, cnt: &mut isize) -> io::Result<()> {
	    if dir.is_dir() {
			for entry in fs::read_dir(dir)? {
	            let entry = entry?;
				let path = entry.path();
				if path.is_dir() {
    	            recurse_files_count_if_media(&path, cnt)?;
    	        } else {
					let ext = get_extension_from_filename(&path);
					if ext.is_some() && MEDIA_TYPES.contains(&ext.unwrap()) {
	    	            *cnt += 1;
					}
    	        }
    	    }
    	}
		Ok(())
	}
	let mut cnt = 0;
	recurse_files_count_if_media(dir, &mut cnt);
	cnt.try_into().unwrap()
}
