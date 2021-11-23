fn main() {
	// parse input
	let instructions = std::fs::read_to_string("data1.txt")
                .unwrap();
	
	// part 1
	assert_eq!(part1(&"(())".to_string()).unwrap(), 0);
	assert_eq!(part1(&"()()".to_string()).unwrap(), 0);
	assert_eq!(part1(&"(((".to_string()).unwrap(), 3);
	assert_eq!(part1(&"(()(()(".to_string()).unwrap(), 3);
	assert_eq!(part1(&"))(((((".to_string()).unwrap(), 3);
	assert_eq!(part1(&"())".to_string()).unwrap(), -1);
	assert_eq!(part1(&"))(".to_string()).unwrap(), -1);
	assert_eq!(part1(&")))".to_string()).unwrap(), -3);
	assert_eq!(part1(&")())())".to_string()).unwrap(), -3);
	let part1_solution = part1(&instructions).unwrap();
	println!("Part 1: {}", part1_solution);
	
	// part 2
	assert_eq!(part2(&")".to_string()).unwrap(), 1);
	assert_eq!(part2(&"()())".to_string()).unwrap(), 5);
	let part2_solution = part2(&instructions).unwrap();
	println!("Part 2: {}", part2_solution)
}

fn part1(instructions: &String) -> Option<isize> {
	let mut floor = 0;
	for instruction in instructions.chars() {
		let move_value = move_floor(instruction);
		if move_value.is_none() {
			return None;
		} else {
			floor += move_value.unwrap();
		}
	}
	return Some(floor);
}

fn part2(instructions: &String) -> Option<usize> {
	let mut floor = 0;
	for (i, instruction) in instructions.chars().enumerate() {
		let move_value = move_floor(instruction);
		if move_value.is_none() {
			return None;
		} else {
			floor += move_value.unwrap();
			if floor == -1 {
				return Some(i + 1);
			}
		}
	}
	return None;
}

fn move_floor(instruction: char) -> Option<isize> {
	if instruction == '(' {
		return Some(1);
	} else if instruction == ')' {
		return Some(-1);
	} else {
		return None;
	}
}
