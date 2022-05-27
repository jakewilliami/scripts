use std::fs::File;
use std::io::{prelude::*, BufReader};

fn main() {
	// parse input
	let file = File::open("data3.txt").expect("No such file");
	let buf = BufReader::new(file);
	let data: Vec<_> = buf.lines()
		.map(|l| l.expect("Could not parse line"))
		.collect();
	let test_data: Vec<String> = vec!["00100", "11110", "10110", "10111", "10101", "01111", "00111", "11100", "10000", "11001", "00010", "01010"].iter().map(|s| s.to_string()).collect();
	
	// part 1
	assert_eq!(part1(&test_data), 198);
	let part1_solution = part1(&data);
	println!("Part 1: {}", part1_solution);
	
	// part 2
	assert_eq!(part2(&test_data), 230);
	let part2_solution = part2(&data);
	println!("Part 2: {}", part2_solution);
	
}

// Part 1

fn part1(data: &Vec<String>) -> isize {
	// Find most common bits in each position
	let gamma_rate_str = find_populist_bitstring(&data);
	let gamma_rate = isize::from_str_radix(&gamma_rate_str, 2).unwrap();
	
	// The epsilon rate is the least common bits in each position.  We can compute this by taking the
	// bitwise negation of the value with the most common bits.  We also need to bit shift by the 
	// length of the string, otherwise we have more bits than necessary and this changes our final
	// value: https://stackoverflow.com/a/71248916/12069968
	let epsilon_rate = !gamma_rate & (1isize << &gamma_rate_str.len()).wrapping_sub(1);
	
	// We return the product of the two rates as our answer
	return gamma_rate * epsilon_rate;
}

fn find_populist_bitstring(data: &Vec<String>) -> String {
	let nbits = data[0].len(); // .chars().count()
	let mut res = String::new();
	let (mut ones, mut zeros) = (0, 0);
	for i in 0..nbits {
		for bitstr in data {
			let bits: Vec<_> = bitstr.chars().collect();
			if bits[i] == '1' {
				ones += 1;
			} else if bits[i] == '0' {
				zeros += 1;
			} else {
				unreachable!()
			}
		}
		assert!(ones != zeros);
		let res_char = if ones > zeros { '1' } else { '0' };
		res.push(res_char);
		ones = 0;
		zeros = 0;
	}
	return res;
}

#[allow(dead_code)]
fn invert_bitstring(bitstr: &String) -> String {
	let mut res = String::new();
	let bits: Vec<_> = bitstr.chars().collect();
	for i in 0..bits.len() {
		let c = match bits[i] {
			'1' => Some('0'),
			'0' => Some('1'),
			_ => None,
		};
		assert!(!c.is_none());
		res.push(c.unwrap());
	}
	return res;
}

// Part 2

enum RatingCriteria {
	OxygenGenerator,
	CO2Scrubber,
}

fn part2(data: &Vec<String>) -> isize {
	let oxygen_generator_rating_str = get_bit_criteria(data, RatingCriteria::OxygenGenerator);
	let co2_scrubber_rating_str = get_bit_criteria(data, RatingCriteria::CO2Scrubber);
	
 	let oxygen_generator_rating = isize::from_str_radix(&oxygen_generator_rating_str, 2).unwrap();
	let co2_scrubber_rating = isize::from_str_radix(&co2_scrubber_rating_str, 2).unwrap();
	
	return oxygen_generator_rating * co2_scrubber_rating;
}

fn get_bit_criteria(data: &Vec<String>, rating_criteria: RatingCriteria) -> String {
	let nbits = data[0].len();
	let mut data_chars: Vec<Vec<char>> = data.iter().map(|bitstr| {
		bitstr.chars().collect()
	}).collect();
	
	let mut i = 0;
	while i < nbits && data_chars.len() > 1 {
		let (mut ones, mut zeros) = (0, 0);
		for bits in &data_chars {
			if bits[i] == '1' {
				ones += 1;
			} else if bits[i] == '0' {
				zeros += 1;
			} else {
				unreachable!()
			}
		}
		let filter_by_bit = match rating_criteria {
			RatingCriteria::OxygenGenerator => {
				if ones >= zeros { '1' } else { '0' } // keep most common
			},
			RatingCriteria::CO2Scrubber => {
				if ones >= zeros { '0' } else { '1' }
			},
		};
		data_chars.retain(|bits| { bits[i] == filter_by_bit }); // filter in place
		i += 1;
	}
	assert!(data_chars.len() == 1);
	return data_chars[0].iter().collect();
}

