use std::fs;

const BINGO_BOARD_SIZE: usize = 5;

fn main() {
	// parse input
	let bingo_components = parse_input("data4.txt");
	// let bingo_components = parse_input("test.txt");
	
	// part 1
	let part1_solution = part1(&bingo_components);
	println!("Part 1: {}", part1_solution);
	
	// part 2
	let part2_solution = part2(&bingo_components);
	println!("Part 2: {}", part2_solution);	
}

// Structs and such

#[derive(Debug, Clone, Copy, PartialEq)]
struct BingoNumber {
	val: u8, // all the numbers are positive and at most 2 digits, so can fit into 8 bits
	obtained: bool,
}

#[derive(Debug, Clone, PartialEq)]
struct BingoBoard {
	data: [[BingoNumber; BINGO_BOARD_SIZE]; BINGO_BOARD_SIZE],
}

#[derive(Debug, Clone, PartialEq)]
struct BingoComponents {
	numbers: Vec<u8>,
	boards: Vec<BingoBoard>,
}

impl Default for BingoNumber {
	fn default() -> Self {
		BingoNumber {
			val: 0 as u8,
			obtained: false,
		}
	}
}

impl Default for BingoBoard {
	fn default() -> Self {
		BingoBoard {
			data: [[BingoNumber { ..Default::default() }; BINGO_BOARD_SIZE]; BINGO_BOARD_SIZE],
		}
	}
}

enum DimType {
	Row,
	Col,
}

trait BingoBoardIsWinner {
	fn is_winner(&self, dim_type: DimType, i: usize) -> bool;
}

trait BingoBoardScore {
	fn calculate_score(&self) -> usize;
}

trait WinningBingoBoard {
	fn get_winning_board(&mut self) -> Option<(u8, BingoBoard)>;
}

trait WorstBingoBoard {
	fn get_worst_board(&mut self) -> Option<(u8, BingoBoard)>;
}

// Parse input

fn parse_input(data_file: &str) -> BingoComponents {
	// parse input
	let input = fs::read_to_string(data_file).expect("No such file");
	let bingo_components_str: Vec<_> = input.split("\n\n").collect();
	
	// parse numbers
	let numbers: Vec<u8> = bingo_components_str[0].split(",")
		.map(|n| {
			n.parse::<u8>().unwrap()
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
			let bingo_num = bingo_numstr.trim().parse::<u8>().unwrap();
			board_data[col][row].val = bingo_num;
		}
	}
	
	return BingoBoard {
		data: board_data
	}
}

// Part 1

impl BingoBoardIsWinner for BingoBoard {
	fn is_winner(&self, dim_type: DimType, i: usize) -> bool {
		match dim_type {
			DimType::Row => {
				self.data[i].iter().all(|r| { r.obtained })
			},
			DimType::Col => {
				self.data.iter().all(|r| { r[i].obtained })
			},
		}
	}
}

impl WinningBingoBoard for BingoComponents {
	fn get_winning_board(&mut self) -> Option<(u8, BingoBoard)> {
		for n in self.numbers.iter() {
			for board in self.boards.iter_mut() {
				// in a small attempt to optimise my original solution (1f71bf3), 
				// I realised that I don't have to check all rows and all columns; 
				// I just have to check the column/row for the position at which the
				// drawn number has occurred
				let mut marked_value_positions: Vec<(usize, DimType)> = Vec::new();
				
				// mark position on board
				'outer: for x in 0..BINGO_BOARD_SIZE {
					for y in 0..BINGO_BOARD_SIZE {
						if board.data[y][x].val == *n {
							// update/mark bingo number as obtained
							board.data[y][x].obtained = true;
							
							// as per the above note, we add to the list of positions
							// we have changed on this board
							marked_value_positions.push((y, DimType::Row));
							marked_value_positions.push((x, DimType::Col));
							
							// we have found the position of the drawn number;
							// as all numbers in the Bingo board should be
							// unique, we should stop searching here
							break 'outer;
						}
					}
				}
				
				// check for winner from the positions of the numbers
				// we have marked from this board
				for (i, dim_type) in marked_value_positions {
					if board.is_winner(dim_type, i) {
						return Some((*n, board.to_owned()));
					}
				}
			}
		}
		
		// if we get here, we have no winner
		return None;
	}
}

impl BingoBoardScore for BingoBoard {
	fn calculate_score(&self) -> usize {
		return self.data.iter().map(|r| {
				r.iter()
					.filter(|m| { !m.obtained })
					.map(|m| { m.val as usize })
					.sum::<usize>()
			})
			.sum();
	}
}

fn part1(bingo_components_original: &BingoComponents) -> usize {
	let mut bingo_components = bingo_components_original.clone();
	let (n, winning_board) = (&mut bingo_components).get_winning_board().expect("This game has no winner");
	let unmarked_sum: usize = winning_board.calculate_score();
	return (n as usize) * unmarked_sum;
}

// Part 2

impl WorstBingoBoard for BingoComponents {
	fn get_worst_board(&mut self) -> Option<(u8, BingoBoard)> {
		// some useful metrics
		let nboards = self.boards.len();
		
		// set persistence mutable values to use after simulation of the game
		let mut previous_winners: Vec<BingoBoard> = Vec::with_capacity(nboards);
		let mut winning_numbers: Vec<u8> = Vec::with_capacity(nboards);
		
		'numbers_outer: for n in self.numbers.iter() {
			for board in self.boards.iter_mut() {
				if previous_winners.contains(&board) {
					continue;
				}
				
				let mut marked_value_positions: Vec<(DimType, usize)> = Vec::new();
				
				// mark position on board
				'idx_outer: for x in 0..BINGO_BOARD_SIZE {
					for y in 0..BINGO_BOARD_SIZE {
						if board.data[y][x].val == *n {
							// update/mark bingo number as obtained
							board.data[y][x].obtained = true;
							
							// add the current position to the marked values
							marked_value_positions.push((DimType::Row, y));
							marked_value_positions.push((DimType::Col, x));
							
							// stop looking here (board values are unique)
							break 'idx_outer;
						}
					}
				}
				
				// check for winner
				for (dim_type, j) in marked_value_positions {
					if board.is_winner(dim_type, j) {
						let this_board = board.to_owned();
						previous_winners.push(this_board);
						winning_numbers.push(*n);
						break;
					}
				}
				
				if previous_winners.len() >= nboards {
					break 'numbers_outer;
				}
			}
		}
		
		// return the last winning board, or nothing if no board has won
		// during the course of this game
		return match previous_winners.is_empty() {
			true => { None },
			false => {
				// last board to win will have been last updated
				let last_winning_board = previous_winners.last().unwrap().to_owned();
				let last_winning_number = winning_numbers.last().unwrap().to_owned();
				Some((last_winning_number, last_winning_board))
			},
		}
	}
}

fn part2(bingo_components_original: &BingoComponents) -> usize {
	let mut bingo_components = bingo_components_original.clone();
	let (n, worst_board) = (&mut bingo_components).get_worst_board().expect("This game has no winner");
	let unmarked_sum: usize = worst_board.calculate_score();
	return (n as usize) * unmarked_sum;
}

