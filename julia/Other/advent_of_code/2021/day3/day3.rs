use std::fs::File;
use std::io::{prelude::*, BufReader};

fn main() {
	// parse input
	let file = File::open("data3.txt").expect("No such file");
	let buf = BufReader::new(file);
	let data: Vec<_> = buf.lines()
		.map(|l| l.expect("Could not parse line"))
		.collect();
	
	// part 1
	let part1_solution = part1(&data);
	println!("{:?}", part1_solution);
}

// Part 1

fn part1(data: &Vec<String>) -> isize {
	let gamma_rate_str = find_populist_bitstring(&data);
	let epsilon_rate_str = invert_bitstring(&gamma_rate_str);
	
	let gamma_rate = isize::from_str_radix(&gamma_rate_str, 2).unwrap();
	let epsilon_rate = isize::from_str_radix(&epsilon_rate_str, 2).unwrap();
	
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

