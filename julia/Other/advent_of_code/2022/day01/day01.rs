use std::fs::File;
use std::io::{prelude::*, BufReader};

fn main() {
	// parse input
	let file = File::open("data01.txt").expect("no such file");
	let buf = BufReader::new(file);
	let mut data = Vec::new();
	let mut sum = 0;
	for l in buf.lines() {
		let s = l.expect("Could not parse line");
		if s.trim().is_empty() {
			data.push(sum);
			sum = 0;
		} else {
			let i = s.parse::<isize>();
			if let Ok(i) = i {
				sum += i;
			}
		}
	}
	data.sort();

	// part 1
	let part1_solution = part1(&data);
	println!("Part 1: {}", part1_solution);

	// part 2
	let part2_solution = part2(&data);
	println!("Part 2: {}", part2_solution);
}

// Part 1
fn part1(data: &Vec<isize>) -> isize {
	data.last().copied().unwrap()
}

// Part 2
fn part2(data: &Vec<isize>) -> isize {
	data[..3].into_iter().sum()
}
