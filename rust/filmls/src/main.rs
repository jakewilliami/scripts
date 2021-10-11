use std::{env, fs};
use std::path::PathBuf;
use std::collections::HashMap;

use clap::{Arg, App};
use colored::*;
use regex::Regex;
// use itertools::Itertools;

fn main() {
    let matches = App::new("filmls")
                      .version("1.0")
                      .author("Jake W. Ireland. <jakewilliami@icloud.com>")
                      .about("A command line interface for listing films in order of date")
					  .arg(Arg::with_name("DIR")
					  		.help("Takes in an input directory")
							.takes_value(true)
							.required(false)
							.multiple(false)
					  ).get_matches();
	
	// If there is no directory provided, we will use the current directory
	let mut dirname = env::current_dir().expect("Cannot get current directory");
	if matches.is_present("DIR") {
		let input = matches.value_of("DIR");
		dirname = PathBuf::from(input.unwrap());
	}
	
	// This regex will match the year at the end of the film name
	let re = Regex::new(r"^.*\((\d{4})\).*$").unwrap();	
	// We want to store films in a hashmap with <film name -> year> so that
	// we can sort it by year
	let mut film_map = HashMap::<String, isize>::new();
	// read the directory
	// Ensure it is sorted by title before we sort by date
	// We need to do this because the order in which `read_dir` returns entries is not guaranteed. 
	// If reproducible ordering is required the entries should be explicitly sorted.
	let mut films: Vec<_> = fs::read_dir(dirname)
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
	
}

// fn find_key_for_value<'a>(map: &'a HashMap<i32, &'static str>, value: &str) -> Option<&'a i32> {
//     map.iter()
//         .find_map(|(key, &val)| if val == value { Some(key) } else { None })
// }
