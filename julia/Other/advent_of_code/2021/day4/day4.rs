use std::fs;
// use std::fs::File;
// use std::io::{prelude::*, BufReader};

const BINGO_BOARD_SIZE: usize = 5;

fn main() {
	// parse input
	let bingo_components = parse_input("data4.txt");
	
	// part 1
	let part1_solution = part1(&bingo_components);
	println!("Part 1: {}", part1_solution);
	
	// part 2
	// let part2_solution = part2(&bingo_components);
	// println!("Part 2: {}", part2_solution);	
}

// Structs and such

#[derive(Debug, Clone, Copy)]
struct BingoNumber {
	val: u16,
	obtained: bool,
}

#[derive(Debug, Clone)]
struct BingoBoard {
	data: [[BingoNumber; BINGO_BOARD_SIZE]; BINGO_BOARD_SIZE],
}

#[derive(Debug, Clone)]
struct BingoComponents {
	numbers: Vec<u16>,
	boards: Vec<BingoBoard>,
}

impl Default for BingoNumber {
	fn default() -> Self {
		BingoNumber {
			val: 0 as u16,
			obtained: false,
		}
	}
}

// Parse input

fn parse_input(data_file: &str) -> BingoComponents {
	// parse input
	let input = fs::read_to_string(data_file).expect("No such file");
	let bingo_components_str: Vec<_> = input.split("\n\n").collect();
	
	// parse numbers
	let numbers: Vec<u16> = bingo_components_str[0].split(",")
		.map(|n| {
			n.parse::<u16>().unwrap()
		})
		.collect();
	
	// parse board
	let boards: Vec<BingoBoard> = bingo_components_str.iter().skip(1)
		.map(|b| {
			let board_rows: Vec<_> = b.lines().collect();
			parse_board(board_rows)
		})
		.collect();
	
	// return bingo components
	return BingoComponents {
		numbers,
		boards
	}
}

fn parse_board(board_rows: Vec<&str>) -> BingoBoard {
	let mut board_data = [[BingoNumber { ..Default::default() }; BINGO_BOARD_SIZE]; BINGO_BOARD_SIZE];
	for (col, bingrow) in board_rows.iter().enumerate() {
		for (row, bingo_numstr) in bingrow.split_whitespace().enumerate() {
			let bingo_num = bingo_numstr.trim().parse::<u16>().unwrap();
			board_data[col][row].val = bingo_num;
		}
	}
	
	return BingoBoard {
		data: board_data
	}
}

// Part 1

/*
fn is_winning_vector(&v: &[BingoNumber; BINGO_BOARD_SIZE]) -> bool {
	return v.iter().all(|b| { b.obtained })
}
*/

trait IsWinner {
	// fn is_winner(&self) -> Option<Vec<BingoNumber>>;
	fn is_winner(&self) -> bool;
}


impl IsWinner for BingoBoard {
	// fn is_winner(&self) -> Option<Vec<BingoNumber>> {
	fn is_winner(&self) -> bool {
		// check the board for any winning configurations
		for i in 0..BINGO_BOARD_SIZE {
			// check the current row
			if self.data[i].iter().all(|r| { r.obtained }) {
				// return Some(self.data[i].to_vec());
				return true;
			}
			// check the current column
			if self.data.iter().all(|r| { r[i].obtained } ) {
				// return Some(self.data.iter().map(|r| { r[i] }).collect());
				return true;
			}
		}
		
		// if we have not found any configurations yet, then
		// this board has not yet won
		// return None;
		return false;
	}
}

fn simulate_bingo_game(bingo_components: &mut BingoComponents) -> Option<(u16, BingoBoard)> {
	for n in bingo_components.numbers.iter() {
		for board in bingo_components.boards.iter_mut() {
			// mutate board
			for x in 0..BINGO_BOARD_SIZE {
				for y in 0..BINGO_BOARD_SIZE {
					if board.data[y][x].val == *n {
						board.data[y][x].obtained = true;
						break;
					}
				}
			}
			
			// check for winner
			// let winning_vec = board.is_winner();
			// if !winning_vec.is_none() {
			if board.is_winner() {
				return Some((*n, board.clone()));
			}
		}
	}
	return None;
}

fn part1(bingo_components_original: &BingoComponents) -> usize {
	let mut bingo_components = bingo_components_original.clone();
	let (n, winning_board) = simulate_bingo_game(&mut bingo_components).expect("This game has no winner");
	let unmarked_sum: usize = winning_board.data.iter().map(|r| {
			r.iter()
				.filter(|m| { !m.obtained })
				.map(|m| { m.val as usize })
				.sum::<usize>()
		})
		.sum();
	return n as usize * unmarked_sum;
}
