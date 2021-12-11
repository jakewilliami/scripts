use std::fs::File;
use std::io::{prelude::*, BufReader};
use std::ops::Not;
use std::collections::{VecDeque, HashMap};

fn main() {
	// parse input
	let file = File::open("data10.txt").expect("No such file");
	// let file = File::open("test.txt").expect("No such file");
	let buf = BufReader::new(file);
	let data_strs: Vec<String> = buf.lines().map(|l| {
			l.expect("Could not parse line")
		}).collect();
	let data = data_strs.iter().map(|s| &**s).collect();
	
	// part 1
	assert_eq!(chunk_valid("()").0, ChunkParseResult::Ok);
	assert_eq!(chunk_valid("[]").0, ChunkParseResult::Ok);
	assert_eq!(chunk_valid("([])").0, ChunkParseResult::Ok);
	assert_eq!(chunk_valid("{()()()}").0, ChunkParseResult::Ok);
	assert_eq!(chunk_valid("<([{}])>").0, ChunkParseResult::Ok);
	assert_eq!(chunk_valid("[<>({}){}[([])<>]]").0, ChunkParseResult::Ok);
	assert_eq!(chunk_valid("(((((((((())))))))))").0, ChunkParseResult::Ok);
	assert_eq!(chunk_valid("((((((((())))))))))").0, ChunkParseResult::Incomplete);
	assert_eq!(chunk_valid("<([{}]>)").0, ChunkParseResult::Corrupted);
	// "(]" "{()()()>" "(((()))}" "<([]){()}[{}])"
	let part1_solution = part1(&data);
	println!("Part 1: {}", part1_solution);
}

// Structs and such

#[derive(Debug, PartialEq, Hash, Eq, Clone, Copy)]
enum ParenthesisType {
	Round,
	Curly,
	Square,
	Angle,
}

#[derive(Debug, PartialEq, Hash, Eq)]
enum ParenthesisDirection {
	Open,
	Close,
}

#[derive(Debug, PartialEq, Hash, Eq)]
struct Parenthesis {
	ptype: ParenthesisType,
	dir: ParenthesisDirection,
}

impl Not for ParenthesisDirection {
	type Output = Self;
	fn not(self) -> Self::Output {
		match self {
			ParenthesisDirection::Open => ParenthesisDirection::Close,
			ParenthesisDirection::Close => ParenthesisDirection::Open,
		}
	}
}

#[derive(Debug, PartialEq)]
enum ChunkParseResult {
	Ok,
	Incomplete,
	Corrupted
}

fn parse_parenthesis(p: &char) -> Option<Parenthesis> {
	let ptype = match p {
		'(' | ')' => Some(ParenthesisType::Round),
		'{' | '}' => Some(ParenthesisType::Curly),
		'[' | ']' => Some(ParenthesisType::Square),
		'<' | '>' => Some(ParenthesisType::Angle),
		_ => None,
	};
	let dir = match p {
		'(' | '{' | '[' | '<' => Some(ParenthesisDirection::Open),
		')' | '}' | ']' | '>' => Some(ParenthesisDirection::Close),
		_ => None,
	};
	return if ptype.is_none() || dir.is_none() {
		None
	} else {
		Some(Parenthesis {
			ptype: ptype.unwrap(),
			dir: dir.unwrap(),
		})
	};
}

fn chunk_valid(token_str: &str) -> (ChunkParseResult, Option<ParenthesisType>) {
	let mut tokens: VecDeque<char> = token_str.chars().collect();
	return chunk_tokens_valid(&mut tokens);
}

fn chunk_tokens_valid(tokens: &mut VecDeque<char>) -> (ChunkParseResult, Option<ParenthesisType>) {
	// let mut output_queue: VecDeque<Parenthesis> = VecDeque::new();
	let mut op_stack: VecDeque<Parenthesis> = VecDeque::new();
	
	// some weird algorithm inspired by the Shunting-yard algorithm
	// I should probably research how a Lisp compiler does it
	// while !tokens.is_empty() {
		// let token = tokens.pop_front().expect("100% bug in Rust");
	for i in 0..tokens.len() {
		let token = tokens[i];
		let paren = parse_parenthesis(&token).expect("Invalid parenthesis character");

		if paren.dir == ParenthesisDirection::Open {
			let matching_paren = Parenthesis {
				ptype: paren.ptype,
				dir: !paren.dir,
			};
			op_stack.push_back(matching_paren);
		} else {
			if op_stack.is_empty() {
				return (ChunkParseResult::Incomplete, None);
			} else if paren != op_stack.pop_back().unwrap() {
				// let matching_paren = op_stack.pop_back().unwrap();
				// if paren.ptype != matching_paren.ptype {
					return (ChunkParseResult::Corrupted, Some(paren.ptype));
				// }
			}
		}
	}
	
	// if stack is empty at this point, return true
	return if op_stack.is_empty() {
		(ChunkParseResult::Ok, None)
	} else {
		(ChunkParseResult::Incomplete, None)
	};
}

// Part 1

fn part1(data: &Vec<&str>) -> usize {
	let mut syntax_scores: HashMap<ParenthesisType, usize> = HashMap::new();
	syntax_scores.insert(ParenthesisType::Round, 3);
	syntax_scores.insert(ParenthesisType::Square, 57);
	syntax_scores.insert(ParenthesisType::Curly, 1197);
	syntax_scores.insert(ParenthesisType::Angle, 25137);
	
	let corrupted: Vec<_> = data.iter().filter(|l| {
			let parse_res = chunk_valid(l);
			parse_res.0 == ChunkParseResult::Corrupted
		})
		.map(|l| {
			let parse_res = chunk_valid(l);
			parse_res.1.unwrap()
		})
		.collect();
	
	let mut invalid_tokens: HashMap<ParenthesisType, usize> = HashMap::new();
	for ptype in corrupted.iter() {
		let counter = invalid_tokens.entry(*ptype).or_insert(0);
	    *counter += 1;
	}
	
	let res: Vec<(usize, usize)> = invalid_tokens.iter().map(|(ptype, i)| {
			(*i, syntax_scores[ptype])
		}).collect();
	
	return res.iter().map(|(i, s)| { i * s }).sum()
}
