use std::fs;

fn main() {
	// parse input
	let crab_submarines = parse_input("data7.txt");
	// let crab_submarines = parse_input("test.txt");
	
	let args: Vec<String> = std::env::args().collect();
    let allowed_args: (String, String) = ("1".to_string(), "2".to_string());

    // part 1
    if *(&args.contains(&allowed_args.0)) {
		let part1_solution = part1(&crab_submarines);
		println!("Part 1: {}", part1_solution);
	}
	
	// part 2
    if *(&args.contains(&allowed_args.1)) {
		let part2_solution = part2(&crab_submarines);
		println!("Part 2: {}", part2_solution);
	}
}

// Structs and such

#[derive(Debug)]
struct CrabSubmarine {
	xpos: usize,
}

// Parse input

fn parse_input(data_file: &str) -> Vec<CrabSubmarine> {
	let raw_data = fs::read_to_string(data_file).expect("No such file");
	return raw_data.trim().split(",").map(|l| {
		let xpos = l.parse::<usize>().unwrap();
		CrabSubmarine {
			xpos,
		}})
		.collect::<Vec<CrabSubmarine>>();
}

// Part 1

trait CrabAlignmentCost {
	fn get_alignment_cost(&self, i: usize) -> usize;
}

impl CrabAlignmentCost for Vec<CrabSubmarine> {
	fn get_alignment_cost(&self, i: usize) -> usize {
		return self.iter().map(|c| {
			(c.xpos as isize - i as isize).abs() as usize
		}).sum();
	}
}

fn part1(crab_submarines: &Vec<CrabSubmarine>) -> usize {
	return (0..crab_submarines.len())
		.map(|i| {
			crab_submarines.get_alignment_cost(i)
		})
		.min()
		.expect("You have no Crab Submarines.  You have no friends.");
}

// Part 2

trait CrabAlignmentCostAccumulative {
	fn get_accumulative_alignment_cost(&self, i: usize) -> usize;
}

impl CrabAlignmentCostAccumulative for Vec<CrabSubmarine> {
	fn get_accumulative_alignment_cost(&self, i: usize) -> usize {
		return self.iter().map(|c| {
			(1..=((c.xpos as isize - i as isize).abs() as usize)).sum::<usize>()
		}).sum();
	}
}

fn part2(crab_submarines: &Vec<CrabSubmarine>) -> usize {
	return (0..crab_submarines.len())
		.map(|i| {
			crab_submarines.get_accumulative_alignment_cost(i)
		})
		.min()
		.unwrap();
}
