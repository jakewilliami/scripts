use std::fs;

const LANTERNFISH_REPRODUCE_PERIOD: usize = 7;
const LANTERNFISH_MATURING_PERIOD: usize = 2;
const DAYS_TO_MODEL: usize = 80;

fn main() {
	let lanternfish = parse_input("data6.txt");
	
	// part 1
	let part1_solution = part1(&lanternfish);
	println!("Part 1: {}", part1_solution);
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

fn model_lanternfish_ecosystem(lanternfish_population: &mut Vec<Lanternfish>) -> Vec<Lanternfish> {
	for _ in 0..DAYS_TO_MODEL {
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
		model_lanternfish_ecosystem(&mut lanternfish_population.clone());
	return new_lanternfish_population.len();
}
