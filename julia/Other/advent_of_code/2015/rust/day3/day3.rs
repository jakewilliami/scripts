use std::collections::HashSet;

fn main() {
	// parse input
	let instructions = std::fs::read_to_string("data3.txt")
                .unwrap();
	
	// part 1
	assert_eq!(part1(&">".to_string()), 2);
	assert_eq!(part1(&"^>v<".to_string()), 4);
	assert_eq!(part1(&"^v^v^v^v^v".to_string()), 2);
	let part1_solution = part1(&instructions);
	println!("Part 1: {}", part1_solution);
	
	// part 2
	assert_eq!(part2(&"^v".to_string()), 3);
	assert_eq!(part2(&"^>v<".to_string()), 3);
	assert_eq!(part2(&"^v^v^v^v^v".to_string()), 11);
	let part2_solution = part2(&instructions);
	println!("Part 2: {}", part2_solution);
}

fn part1(instructions: &String) -> usize {
	let mut house_coordinates: HashSet<(isize, isize)> = HashSet::new();
	let (mut x, mut y) = (0, 0);
	house_coordinates.insert((x, y)); // add the first house Santa visits to the set
	
	for instruction in instructions.chars() {
		match &instruction {
			&'^' => {
				y += 1;
			},
			&'v' => {
				y -= 1;
			},
			&'>' => {
				x += 1;
			},
			&'<' => {
				x -= 1;
			},
			_ => {},
		}
		house_coordinates.insert((x, y));
	}
	
	return house_coordinates.len();
}

fn part2(instructions: &String) -> usize {
	let mut house_coordinates: HashSet<(isize, isize)> = HashSet::new();
	let (mut x, mut y) = (0, 0);
	let (mut w, mut v) = (0, 0);
	house_coordinates.insert((x, y)); // add the first house Santa visits to the set
	
	for (i, instruction) in instructions.chars().enumerate() {
		if i % 2 == 0 {
			match &instruction {
				&'^' => { y += 1 },
				&'v' => { y -= 1 },
				&'>' => { x += 1 },
				&'<' => { x -= 1 },
				_ => {},
			}
			house_coordinates.insert((x, y));
		} else {
			match &instruction {
				&'^' => { v += 1 },
				&'v' => { v -= 1 },
				&'>' => { w += 1 },
				&'<' => { w -= 1 },
				_ => {},
			}
			house_coordinates.insert((w, v));
		}
	}
	
	return house_coordinates.len();
}
