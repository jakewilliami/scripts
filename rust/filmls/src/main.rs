use std::{env, fs, io};
use std::path::{Path, PathBuf};
use std::ffi::OsStr;
use std::collections::HashMap;
use std::convert::TryInto;

use clap::{
	ArgAction,
	crate_version,
	Parser,
};
use colored::*;
use regex::Regex;

mod constants;
mod dir;

// Define command line interface
#[derive(Parser)]
#[command(
	name = "filmls",
	author = "Jake·W.·Ireland.·<jakewilliami@icloud.com>",
	version = crate_version!(),
)]
/// A command line interface for listing films in order of date
struct Cli {
	/// Look in the film directory.  You can use this flag with -c
	#[arg(
		short = 'f',
		long = "films",
		action = ArgAction::SetTrue,
		num_args = 0,
	)]
	films: Option<bool>,

	/// Look in the series directory.  You can use this flag with -c
	#[arg(
		short = 's',
		long = "series",
		action = ArgAction::SetTrue,
		num_args = 0,
	)]
	series: Option<bool>,

	/// Count the number of films or series in a directory.  Choose -f or -s for the programme to find the directory for you, otherwise specify a directory.
	#[arg(
		short = 'c',
		long = "count",
		action = ArgAction::SetTrue,
		num_args = 0,
	)]
	count: Option<bool>,

	/// Check if series have titles for each episode
	#[arg(
		short = 't',
		long = "titles",
		action = ArgAction::SetTrue,
		num_args = 0,
	)]
	titles: Option<bool>,

	/// Check if series have consecutive seasons
	#[arg(
		short = 'S',
		long = "consecitive-seasons",
		action = ArgAction::SetTrue,
		num_args = 0,
	)]
	consecutive_seasons: Option<bool>,

	/// Check if series have all episodes in each season
	#[arg(
		short = 'e',
		long = "complete-episodes",
		action = ArgAction::SetTrue,
		num_args = 0,
	)]
	complete_episodes: Option<bool>,

	/// Takes an input directory.  Omitting this parameter, the programme will attempt to find the media directory
	#[arg(
		action = ArgAction::Set,
		num_args = 0..=1,
	)]
	dir: Option<PathBuf>,
}

// Main function

fn main() {
	let cli = Cli::parse();

	// If there is no directory provided, we will use either a predefined media directory, or the current directory
	let mut dirname = if let Some(dirname) = cli.dir {
		dirname
	} else {
		dir::get_media_dir()
	};

	//// List films
	// If no arguments are passed, will list
	if std::env::args().len() <= 1 {
		// Get films directory if none provided
		let mut films_dir = dirname.clone();
		films_dir.push(constants::FILMS_DIR_NAME);

		// This regex will match the year at the end of the film name
		let re = Regex::new(r"^(?P<fname>.+)\s+\((?P<fyear>\d{4})\)$").unwrap();
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
				film_year = caps.name("fyear")
					.unwrap()
					.as_str()
					.parse::<isize>()
					.unwrap();
			film_map.insert(film_name, film_year);
			} else {
				eprintln!("Warning: film \"{}\" does not match regex", &film_name)
			}
			// Update the hashmap
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

	//// Count media
	if let Some(show_count) = cli.count {
		if show_count{
			// Count films
			if let Some(show_film_count) = cli.films {
				if show_film_count {
					let mut films_dir = dirname.clone();
					films_dir.push(constants::FILMS_DIR_NAME);
					let cnt = count_media_files(&films_dir);
					println!("{}{}{}", "You have ".italic(), cnt.to_string().bold(), " films in your Plex Media Server.".italic());
				}
			}

			// Count series
			if let Some(show_series_count) = cli.series {
				if show_series_count {
					let mut series_dir = dirname.clone();
					series_dir.push(constants::SERIES_DIR_NAME);
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
			}
				}
	}

	//// Season utility functions

	//// Check if season episodes have titles
	if let Some(check_titles) = cli.titles {
		if check_titles {
			let mut series_dir = dirname.clone();
			series_dir.push(constants::SERIES_DIR_NAME);
			let season_re = Regex::new(r"^Season\s\d+$").unwrap();
			// let ep_re = Regex::new(r"^(.*)\s\-\sS(\d+)E(\d+)(?:\s\-\s)(?:.*)\.(.*)$").unwrap();  // THIS WAS BUGGED - DOES NOT WORK!
			let ep_re = Regex::new(r"^(?P<sname>.+)\s\-\sS(?P<snum>\d+)E(?P<epnum>\d{2,})(\s-\s)?(?P<epname>.+)?\.(?P<ext>\w+)$").unwrap();
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
								// Check if episode has a name
								if caps.name("epname").is_none() {
									let series_name = caps.name("sname").unwrap().as_str().to_string();
									let season_num = caps.name("snum").unwrap().as_str().parse::<isize>().unwrap();
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
	}


	//// Alert on non-consecutive seasons
	if let Some(check_consecutive_seasons) = cli.consecutive_seasons {
		if check_consecutive_seasons {
			let mut series_dir = dirname.clone();
			series_dir.push(constants::SERIES_DIR_NAME);
			let season_re = Regex::new(r"^Season\s(?P<snum>\d{2,})$").unwrap();
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
							if let Some(season_num) = caps.name("snum") {
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
	}

	/*if matches.is_present("COMPLETE_EPS") {
		let mut series_dir = dirname.clone();
		series_dir.push(SERIES_DIR_NAME);
		let season_re = Regex::new(r"^Season\s\d+$").unwrap();
		let ep_re = Regex::new(r"^(.*)\s\-\sS(\d+)E(\d+)(?:\s\-\s.*)\.(.*)$").unwrap();
		// Construct a hashmap for storing results
		let mut missing_eps_map = HashMap::<String, Vec<isize>>::new();
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
							todo!("In this block, I need to get the episode capture group (3), and do a similar thing to that of the previous one, were we look for max value and find all missing values up to max.  Should print \"Series <series> has all consecutive episodes up to <max_ep>, if we don't find any missing.\"");
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
	}*/
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
					if ext.is_some() && constants::MEDIA_TYPES.contains(&ext.unwrap()) {
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
