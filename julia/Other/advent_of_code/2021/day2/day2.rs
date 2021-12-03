use std::fs::File;
use std::io::{prelude::*, BufReader};

fn main() {
	// parse input
	let data = parse_input("data2.txt");
	
	// part 1
	let part1_solution = part1(&data);
	println!("{}", part1_solution);
	
	let part2_solution = part2(&data);
	println!("{}", part2_solution);
}

// Structs and such

enum Direction {
	Forward,
	Down,
	Up,
}

struct Command {
	val: isize,
	direction: Direction,
}

// Parse input

fn parse_input(data_file: &str) -> Vec<Command> {
	let file = File::open(data_file).expect("No such file");
	let buf = BufReader::new(file);
	let data: Vec<Command> = buf.lines()
		.map(|l| {
			let line = l.expect("Could not parse line");
			let tokens: Vec<_> = line.split(" ").collect();
			let direction = match tokens[0] {
				"forward" => Some(Direction::Forward),
				"down" => Some(Direction::Down),
				"up" => Some(Direction::Up),
				_ => None,
			};
			assert!(!direction.is_none());
			let val = tokens[1].parse::<isize>().unwrap();
			Command {
				val,
				direction: direction.unwrap(),
			}
		})
		.collect();
	return data;
}

// Part 1

fn part1(commands: &Vec<Command>) -> isize {
	let (mut horiz_pos, mut depth) = (0, 0);
	for command in commands {
		match command.direction {
			Direction::Forward => { horiz_pos += command.val },
			Direction::Down => { depth += command.val },
			Direction::Up => { depth -= command.val },
		};
	}
	
	return horiz_pos * depth;
}

// Part 2

fn part2(commands: &Vec<Command>) -> isize {
	let (mut horiz_pos, mut depth, mut aim) = (0, 0, 0);
	for command in commands {
		match command.direction {
			Direction::Forward => {
				horiz_pos += command.val;
				depth += command.val * aim;
			},
			Direction::Down => { aim += command.val },
			Direction::Up => { aim -= command.val },
		};
	}
	
	return horiz_pos * depth;
}
