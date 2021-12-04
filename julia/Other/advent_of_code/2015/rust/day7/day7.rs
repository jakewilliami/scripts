use std::fs::File;
use std::io::{prelude::*, BufReader};
use std::collections::HashMap;
use std::collections::VecDeque;

fn main() {
	// parse input
	let file = File::open("data7.txt").expect("no such file");
	let buf = BufReader::new(file);
	let instructions: Vec<_> = buf.lines()
		.map(|l| parse_instruction(l.unwrap().as_str()))
		.collect();
	
	// part 1
	/*let instructions_raw_test = vec!["123 -> x", "456 -> y", "x AND y -> d", "x OR y -> e", "x LSHIFT 2 -> f", "y RSHIFT 2 -> g", "NOT x -> h", "NOT y -> i"];
	let instructions_test: Vec<Instruction> = instructions_raw_test
			.iter()
			.map(|s| parse_instruction(s))
			.collect();
	let circuit_components_test = simulate_circuit(instructions_test);
	assert_eq!(circuit_components_test.get(&"d".to_string()).unwrap().to_owned(), 72 as u16);
	assert_eq!(circuit_components_test.get(&"e".to_string()).unwrap().to_owned(), 507 as u16);
	assert_eq!(circuit_components_test.get(&"f".to_string()).unwrap().to_owned(), 492 as u16);
	assert_eq!(circuit_components_test.get(&"g".to_string()).unwrap().to_owned(), 114 as u16);
	assert_eq!(circuit_components_test.get(&"h".to_string()).unwrap().to_owned(), 65412 as u16);
	assert_eq!(circuit_components_test.get(&"i".to_string()).unwrap().to_owned(), 65079 as u16);
	assert_eq!(circuit_components_test.get(&"x".to_string()).unwrap().to_owned(), 123 as u16);
	assert_eq!(circuit_components_test.get(&"y".to_string()).unwrap().to_owned(), 456 as u16);*/
	let part1_solution = part1(instructions);
	println!("Part 1: {}", part1_solution);
}

// Structs and such

#[derive(Debug)]
enum Operation {
	Assign,
	And,
	Or,
	Not,
	LeftShift,
	RightShift,
}

#[derive(Debug)]
enum ComponentData {
	ComponentName(String),
	ComponentValue(u16),
}

#[derive(Debug)]
struct Instruction {
	op: Operation,
	operands: Vec<ComponentData>,
	dst: String,
}

// type alias
type CircuitComponents = HashMap<String, u16>;

fn parse_circuit_data(circuit_data_raw: &str) -> ComponentData {
	let operand: ComponentData = match circuit_data_raw.parse::<u16>() {
		Ok(val) => ComponentData::ComponentValue(val),
		Err(_) => ComponentData::ComponentName(circuit_data_raw.to_string()),
	};
	return operand;
}

fn parse_instruction(instruction_str: &str) -> Instruction {
	// println!("{}", instruction_str);
	let instruction_parts: Vec<_> = instruction_str.split(" -> ").collect();
	let op_tokens: Vec<_> = instruction_parts[0].split(" ").collect();
	let dst = instruction_parts[1].to_string();
	let instruction: Option<Instruction> = match op_tokens.len() {
		// if the left-hand side has 1 token, it is a simple assign
		1 => {
			Some(Instruction {
				op: Operation::Assign,
				operands: vec![parse_circuit_data(op_tokens[0])],
				dst,
			})
		},
		// if the left-hand side has 2 tokens, we are looking at a not operator
		2 => {
			assert_eq!(op_tokens[0], "NOT");
			Some(Instruction{
				op: Operation::Not,
				operands: vec![parse_circuit_data(op_tokens[1])],
				dst: dst,
			})
		},
		// otherwise, we are looking at all other operations
		3 => {
			let op: Option<Operation> = match op_tokens[1] {
				"LSHIFT" => Some(Operation::LeftShift),
				"RSHIFT" => Some(Operation::RightShift),
				"AND" => Some(Operation::And),
				"OR" => Some(Operation::Or),
				_ => None,
			};
			assert!(!op.is_none());
			
			let a = parse_circuit_data(op_tokens[0]);
			let b = parse_circuit_data(op_tokens[2]);
			
			Some(Instruction {
				op: op.unwrap(),
				operands: vec![a, b],
				dst,
			})
		},
		_ => None, // catch all
	};
	
	assert!(!instruction.is_none()); // should never get to the last branch
	return instruction.unwrap();
}

// Part 1

fn get_circuit_value(circuit: &mut CircuitComponents, v: &ComponentData) -> u16 {
	println!("-------{:?}: {:?}", v, circuit);
	return match v {
		ComponentData::ComponentValue(val) => *val,
		ComponentData::ComponentName(name) => {//*circuit.get(name).unwrap(),
			// if circuit.contains_key(name) {
				*circuit.get(name).unwrap()
			// } else {
				// circuit.insert(name.to_string(), 0 as u16);
				// 0 as u16
			// }
		},
	}
}

fn simulate_circuit(instructions: Vec<Instruction>) -> CircuitComponents {
// fn simulate_circuit(instructions: Vec<Instruction>) -> {
	// let mut ordered_instructions = VecDeque::new();
	// for instruction in instructions {
		// match instruction.op {
			// Operation::Assign => ordered_instructions.push_front(instruction),
			// _ => ordered_instructions.push_back(instruction),
		// }
	// }
	
	let mut instructions_clone = instructions.clone();
	let mut circuit_components = HashMap::new();
	// for instruction in instructions_clone {
	// while !circuit_components.get("a".to_string()).is_none() {
	let i: usize = 0;
	while !instructions_clone.empty() {
		// let instruction = ordered_instructions[j];
		let j = i % instructions_clone.len();
		let instruction = instructions_clone[j];
		i += 1;
		// if !circuit_components.contains_key(instruction.operands[0]) {
			// continue;
		// }
		println!("{:?}", instruction);
		match instruction.op {
			Operation::Assign => {
				let val = match &instruction.operands[0] {
					ComponentData::ComponentValue(val) => {
						circuit_components.insert(instruction.dst, *val);
					},
					ComponentData::ComponentName(name) => {
						// if *circuit_components.contains_key(name) {
						if let Some(val) = *circuit_components.get(name) {
							// *circuit_components.get(name).unwrap()
							instructions_clone.remove(j);
							circuit_components.insert(instruction.dst, val);
						} else {
							continue;
						}
						*circuit.get(name).unwrap()
					},
				}
				// let val = get_circuit_value(&mut circuit_components, &instruction.operands[0]);
				// circuit_components.insert(instruction.dst, val);
			},
			Operation::Not => {
				let val = get_circuit_value(&mut circuit_components, &instruction.operands[0]);
				circuit_components.insert(instruction.dst, !val);
			},
			Operation::And | Operation::Or | Operation::LeftShift | Operation::RightShift => {
				let a = get_circuit_value(&mut circuit_components, &instruction.operands[0]);
				let b = get_circuit_value(&mut circuit_components, &instruction.operands[1]);
				let val = match instruction.op {
					Operation::And => Some(a & b),
					Operation::Or => Some(a | b),
					Operation::LeftShift => Some(a << b),
					Operation::RightShift => Some(a >> b),
					_ => None,
				};
				circuit_components.insert(instruction.dst, val.unwrap());
			},
		};
	}
	return circuit_components;
}

fn part1(instructions: Vec<Instruction>) -> u16 {
	let circuit_components = simulate_circuit(instructions);
	return *circuit_components.get("a").unwrap();
}
