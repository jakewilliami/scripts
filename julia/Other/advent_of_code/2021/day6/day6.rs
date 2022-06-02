use std::fs;

const LANTERNFISH_REPRODUCE_PERIOD: usize = 7;
const LANTERNFISH_MATURING_PERIOD: usize = 2;
const PART1_DAYS_TO_MODEL: usize = 80;
const PART2_DAYS_TO_MODEL: usize = 256;

fn main() {
	let lanternfish = parse_input("data6.txt");

	let args: Vec<String> = std::env::args().collect();
    let allowed_args: (String, String) = ("1".to_string(), "2".to_string());

    // part 1
    if *(&args.contains(&allowed_args.0)) {
		let part1_solution = part1(&lanternfish);
		println!("Part 1: {}", part1_solution);
	}
	
	// part 2
    if *(&args.contains(&allowed_args.1)) {
		let part2_solution = part2(&lanternfish);
		println!("Part 2: {}", part2_solution);
	}
}

// Structs and such

#[derive(Debug, Clone)]
struct Lanternfish {
	baby_timer: usize,
	mature: bool,
}

impl Default for Lanternfish {
	fn default() -> Self {
		Lanternfish {
			baby_timer: LANTERNFISH_REPRODUCE_PERIOD + LANTERNFISH_MATURING_PERIOD - 1,
			mature: false,
		}
	}
}

// Parse Input

fn parse_input(data_file: &str) -> Vec<Lanternfish> {
	let raw_data = fs::read_to_string(data_file).expect("No such file");
	return raw_data.trim().split(",").map(|l| {
		let baby_timer = l.parse::<usize>().unwrap();
		Lanternfish {
			baby_timer,
			mature: true,
		}
	})
	.collect::<Vec<Lanternfish>>();
}

// Part 1

fn model_lanternfish_ecosystem(lanternfish_population: &mut Vec<Lanternfish>, days_to_model: usize) -> Vec<Lanternfish> {
	for _ in 0..days_to_model {
		let current_population_count = lanternfish_population.len();
		for i in 0..current_population_count {
			let lanternfish = &lanternfish_population[i].to_owned();
			
			// lanternfish has reached maturity
			if !lanternfish.mature && lanternfish.baby_timer == (LANTERNFISH_REPRODUCE_PERIOD - LANTERNFISH_MATURING_PERIOD + 1) {
				lanternfish_population[i].mature = true;
			}
			
			// reproduction
			if lanternfish.mature && lanternfish.baby_timer == 0 {
				lanternfish_population[i].baby_timer = LANTERNFISH_REPRODUCE_PERIOD - 1;
				lanternfish_population.push(Lanternfish { ..Default::default() });
			} else {
				lanternfish_population[i].baby_timer -= 1;
			}
		}
	}
	
	return lanternfish_population.to_vec();
}

fn part1(lanternfish_population: &Vec<Lanternfish>) -> usize {
	let new_lanternfish_population = 
		model_lanternfish_ecosystem(&mut lanternfish_population.clone(), PART1_DAYS_TO_MODEL);
	return new_lanternfish_population.len();
}

// part 2

fn part2(lanternfish_population: &Vec<Lanternfish>) -> usize {
	let mut new: Vec<usize> = (0..=(LANTERNFISH_REPRODUCE_PERIOD + 2)).map(|j| {
		lanternfish_population.iter()
			.filter(|f| { f.baby_timer == j })
			.count()
	})
	.collect();
	let mut old: Vec<usize> = vec![0; LANTERNFISH_REPRODUCE_PERIOD + 2];
	
	for _ in 0..PART2_DAYS_TO_MODEL {
		let offspring = new[0] + old[0];
		// Example of `copy_within` from Rust docs:
		// let mut bytes = *b"Hello, World!";
		// bytes.copy_within(1..5, 8);
		// assert_eq!(&bytes, b"Hello, Wello!");
		//
		// This should do:
		// [0, 1, 2, 3, 4, 5] -> [1, 2, 3, 4, 5, 5]
		new.copy_within(1..(LANTERNFISH_REPRODUCE_PERIOD + 2), 0);
		old.copy_within(1..(LANTERNFISH_REPRODUCE_PERIOD + 2), 0);
		new[LANTERNFISH_REPRODUCE_PERIOD + 1] = offspring;
		old[LANTERNFISH_REPRODUCE_PERIOD - 1] = offspring;
		
	}
	
	return new.iter().sum::<usize>() + old.iter().sum::<usize>();
}
