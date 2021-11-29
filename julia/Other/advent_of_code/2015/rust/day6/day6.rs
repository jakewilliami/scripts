use std::fs::File;
use std::io::{prelude::*, BufReader};
use std::collections::VecDeque;
// use std::cmp::max;

fn main() {
	// parse input
	let instructions = parse_instructions("data6.txt");

	// part 1
	let part1_solution = part1(&instructions);
	println!("Part 1: {}", part1_solution);
	
	// part 2
	let part2_solution = part2(&instructions);
	println!("Part 2: {}", part2_solution);
}

// Structs and such

enum ChangeState {
	TurnOn,
	TurnOff,
	Toggle,
}

struct Instruction {
	state_instruction: ChangeState,
	top_left_coords: (usize, usize),
	bottom_right_coords: (usize, usize),
}

// Parse input

fn parse_coordinates(coordinate_str: &str) -> (usize, usize) {
	let coordinates_as_strs: Vec<_> = coordinate_str.split(",").collect();
	let x_str = coordinates_as_strs[0];
	let y_str = coordinates_as_strs[1];
	let x = x_str.parse::<usize>().unwrap();
	let y = y_str.parse::<usize>().unwrap();
	return (x, y);
}

fn parse_instruction(s: &str) -> Instruction {
	let mut tokens: VecDeque<_> = s.split(" ").collect();
	let state_instruction: Option<ChangeState>;
	let state_instruction_str = tokens.pop_front().unwrap();
	if state_instruction_str == "turn" {
		let state_set_instruction = tokens.pop_front().unwrap();
		state_instruction = match state_set_instruction {
			"on" => Some(ChangeState::TurnOn),
			"off" => Some(ChangeState::TurnOff),
			_ => None,
		};
		assert!(!state_instruction.is_none());
	} else {
		assert_eq!(state_instruction_str, "toggle");
		state_instruction = Some(ChangeState::Toggle);
	}
	let top_left_coords_str = tokens.pop_front().unwrap();
	let top_left_coords = parse_coordinates(top_left_coords_str);
	let _through = tokens.pop_front();
	let bottom_right_coords_str = tokens.pop_front().unwrap();
	let bottom_right_coords = parse_coordinates(bottom_right_coords_str);
	assert_eq!(tokens.len(), 0);
	
	return Instruction{
		state_instruction: state_instruction.unwrap(),
		top_left_coords: top_left_coords,
		bottom_right_coords: bottom_right_coords
	}
}

fn parse_instructions(input_file: &str) -> Vec<Instruction> {
	let mut instructions: Vec<Instruction> = Vec::new();
	
	let file = File::open(input_file).expect("no such file");
	let buf = BufReader::new(file);
	let lines: Vec<_> = buf.lines()//.collect();
						.map(|l| l.expect("Could not parse line"))
						.collect();
	
	for instruction_raw in lines {
		let instruction = parse_instruction(&instruction_raw);
		instructions.push(instruction);
	}
	
	return instructions;
}

// Part 1

fn part1(instructions: &Vec<Instruction>) -> usize {
	let mut lights = [[0 as u8; 1000]; 1000];
	for instruction in instructions {
		let left_most_index = instruction.top_left_coords.0;
		let right_most_index = instruction.bottom_right_coords.0;
		let top_most_index = instruction.top_left_coords.1;
		let bottom_most_index = instruction.bottom_right_coords.1;
		for x in left_most_index..=right_most_index {
			for y in top_most_index..=bottom_most_index {
				match instruction.state_instruction {
					ChangeState::TurnOn => {
						lights[y][x] = 1;
					},
					ChangeState::TurnOff => {
						lights[y][x] = 0;
					},
					ChangeState::Toggle => {
						lights[y][x] = 1 - lights[y][x];
					},
				};
			}
		}
	}
	
	let mut light_count: usize = 0;
	for row in lights.iter_mut() {
		for l in row.iter_mut() {
			light_count += *l as usize;
		}
	}
	
	return light_count;
}

// Part 2
fn part2(instructions: &Vec<Instruction>) -> usize {
	let mut lights = [[0 as usize; 1000]; 1000];
	for instruction in instructions {
		let left_most_index = instruction.top_left_coords.0;
		let right_most_index = instruction.bottom_right_coords.0;
		let top_most_index = instruction.top_left_coords.1;
		let bottom_most_index = instruction.bottom_right_coords.1;
		for x in left_most_index..=right_most_index {
			for y in top_most_index..=bottom_most_index {
				match instruction.state_instruction {
					ChangeState::TurnOn => {
						lights[y][x] += 1;
					},
					ChangeState::TurnOff => {
						/*
						let current_brightness = lights[y][x];
						lights[y][x] = if current_brightness == 0 {
							0
						} else {
							current_brightness - 1
						}
						*/
						// lights[y][x] = max(1, lights[y][x]) - 1;
						lights[y][x] = lights[y][x].saturating_sub(1);
					},
					ChangeState::Toggle => {
						lights[y][x] += 2;
					},
				};
			}
		}
	}
	
	let mut light_count: usize = 0;
	for row in lights.iter_mut() {
		for l in row.iter_mut() {
			light_count += *l;
		}
	}
	
	// xxxxxxxx too high
	// 2544104 too low
	// 14687245 is correct
	
	return light_count;
}
