use std::fs::File;
use std::io::{prelude::*, BufReader};

// Size of input
const N: usize = 2000;

fn main() {
	// parse input
	let file = File::open("data1.txt").expect("no such file");
	let buf = BufReader::new(file);
	let mut data = [0; N];
	for (i, l) in buf.lines().enumerate() {
		let x = l.expect("Could not parse line").parse::<isize>();
		if let Ok(x) = x {
			data[i] = x;
		}
	}

	// part 1
	let part1_solution = part1(&data);
	println!("Part 1: {}", part1_solution);

	// part 2
	let part2_solution = part2(&data);
	println!("Part 2: {}", part2_solution);
}

// Part 1

fn part1(data: &[isize; N]) -> usize {
	(1..data.len())
		.filter(|i| {
			data[*i - 1] < data[*i]
		})
		.count()
}

// Part 2

fn part2(data: &[isize; N]) -> usize {
	(3..data.len())
		.filter(|i| {
			(data[*i - 1] + data[*i - 2] + data[*i - 3]) < (data[*i] + data[*i - 1] + data[*i - 2])
		})
		.count()
}
