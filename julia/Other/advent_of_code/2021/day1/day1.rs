use std::fs::File;
use std::io::{prelude::*, BufReader};

fn main() {
	// parse input
	let file = File::open("data1.txt").expect("no such file");
	let buf = BufReader::new(file);
	let data: Vec<isize> = buf.lines()
		.map(|l| l.expect("Could not parse line").parse::<isize>().unwrap())
		.collect();
	
	// part 1
	let part1_solution = part1(&data);
	println!("Part 1: {}", part1_solution);
	
	// part 2
	let part2_solution = part2(&data);
	println!("Part 2: {}", part2_solution);
}

// Part 1

fn part1(data: &Vec<isize>) -> usize {
	let mut cnt: usize = 0;
	for i in 1..data.len() {
		if data[i - 1] < data[i] {
			cnt += 1;
		}
	}
	return cnt;
}

// Part 2

fn part2(data: &Vec<isize>) -> usize {
	let mut cnt: usize = 0;
	for i in 3..data.len() {
		let a = data[i - 1] + data[i - 2] + data[i - 3];
		let b = data[i] + data[i - 1] + data[i - 2];
		if a < b {
			cnt += 1;
		}
	}
	return cnt;
}
