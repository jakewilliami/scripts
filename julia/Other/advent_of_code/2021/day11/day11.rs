use std::fs::File;
use std::io::{prelude::*, BufReader};
use std::collections::VecDeque;

use std::fmt;

fn main() {
	// let octopodes = parse_input("small_test.txt");
	// let octopodes = parse_input("test.txt");
	let octopodes = parse_input("data11.txt");
	
	// part 1
	let part1_solution = part1(&octopodes, 100);
	println!("Part 1: {}", part1_solution);
	
	// part 2
	let part2_solution = part2(&octopodes, 0);
	println!("Part 2: {}", part2_solution);
}

// Structs and such

#[derive(Clone, Copy)]
struct Octopus {
	energy: u8,
	flashing: bool,
}

const ENERGY_LEVEL_FULL: u8 = 9;

impl Octopus {
	fn is_energy_full(&self) -> bool {
		self.energy > ENERGY_LEVEL_FULL
	}
}

impl fmt::Debug for Octopus {
	fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
		let padding_char = if self.flashing {"*"} else {" "};
		write!(f, "{}{}{}", padding_char, self.energy, padding_char)
	}
}

type Octopodes = Vec<Vec<Octopus>>;
// struct Octopodes(Vec<Vec<Octopus>>); // these are tuple structs, should be indexed by .0, etc

#[derive(PartialEq, Clone, Copy)]
struct Point2D {
	x: usize,
	y: usize,
}

impl fmt::Debug for Point2D {
	fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
		write!(f, "({}, {})", self.x, self.y)
	}
}

// Parse input

fn parse_input(data_file: &str) -> Vec<Vec<Octopus>> {
	const RADIX: u32 = 10;
	let file = File::open(data_file).expect("No such file");
	let buf = BufReader::new(file);
	let data: Vec<Vec<Octopus>> = buf.lines()
		.map(|l| {
			let line = l.expect("Could not parse line");
			line.chars().map(|d| {
				let energy = d.to_digit(RADIX).unwrap() as u8;
				Octopus {
					energy,
					flashing: false,
				}
			})
			.collect::<Vec<Octopus>>()
		})
		.collect();
	return data;
}

// Helper methods

trait GetIndex<T> {
	fn get_index(&self, p: &Point2D) -> T;
}

impl GetIndex<Octopus> for Octopodes {
	fn get_index(&self, p: &Point2D) -> Octopus {
		return self[p.y][p.x];
	}
}

/*
fn get_points_from_mat<T>(matrix: &Vec<Vec<T>>) -> impl Iterator<Item=Point2D> + '_ {
	matrix.iter().enumerate().map(|(y, row)| {
		row.iter().enumerate().map(move |(x, _el)| {
			Point2D { x, y }
		})
	})
	.flatten()
}
*/

// fn get_points(nrows: usize, ncols: usize) -> impl Iterator<Item=Point2D> {
fn get_points(nrows: usize, ncols: usize) -> Vec<Point2D> {
	(0..nrows).map(move |y| {
		(0..ncols).map(move |x| {
			Point2D { x, y }
		})
	})
	.flatten()
	.collect()
}

const SURROUNDING_DIRECTIONS: [(isize, isize); 8] = [
	(-1, -1),
	( 0, -1),
	( 1, -1),
	(-1,  0),
	( 1,  0),
	(-1,  1),
	( 0,  1),
	( 1,  1),
];

trait SurroundingVals {
	fn get_surrounding_indices(&self, p: &Point2D) -> Option<Vec<Point2D>>;
}

impl<T> SurroundingVals for Vec<Vec<T>>
	where T: Copy,
{
	fn get_surrounding_indices(&self, p: &Point2D) -> Option<Vec<Point2D>> {
		let x = p.x as isize;
		let y = p.y as isize;
		
		// get size of data
		let n = self.len() as isize;
		let m = self[0].len() as isize; // assume all inner vectors are the same length
		
		// return none if indices are out of bouds
		if y >= n || x >= m {
			return None;
		}
		
		// return all valid indices as points
		let surrounding_values: Vec<Point2D> = SURROUNDING_DIRECTIONS.iter()
			.filter_map(|(a, b)| {
				let w = x + a;
				let v = y + b;
				if w >= 0 && v >= 0 && v < n && w < m {
					Some(Point2D { x: w as usize, y: v as usize, })
				} else {
					None
				}
			})
			.collect();
		
		return if surrounding_values.is_empty() { None } else { Some(surrounding_values) };
	}
}

// Part 1

fn simulate_step(octopodes: &mut Octopodes) -> usize {
	let nrows = octopodes.len();
	let ncols = octopodes[0].len(); // assume all inner vectors are the same length
	
	let mut flash_counter = 0;
	let points = get_points(nrows, ncols);
	
	// First, the energy level of each octopus increases by 1
	// for p in points.iter() {
		// octopodes[p.y][p.x].energy += 1;
	// }
	points.iter().for_each(|p| { 
		octopodes[p.y][p.x].energy += 1;
	});
	
	// need to get the points that are flashing
	let initial_flashing_points: Vec<Point2D> = points.iter()
		.filter_map(|p| {
			if octopodes[p.y][p.x].is_energy_full() {
				Some(*p)
			} else {
				None
			}
		})
		.collect();
	
	// Then, any octopus with an energy level greater than 9 flashes. 
	// This increases the energy level of all adjacent octopuses by 1, 
	// including octopuses that are diagonally adjacent. If this causes 
	// an octopus to have an energy level greater than 9, it also flashes. 
	// This process continues as long as new octopuses keep having their 
	// energy level increased beyond 9. (An octopus can only flash at most 
	// once per step.)
	for initial_flashing_point in initial_flashing_points {
		let mut surrounding_queue: VecDeque<Point2D> = VecDeque::from(vec![initial_flashing_point]);
		while !surrounding_queue.is_empty() {
			let p = surrounding_queue.pop_front().expect("100% Rust bug");
			// Very similar to day 9—now we flash!
			if octopodes[p.y][p.x].is_energy_full() && !octopodes[p.y][p.x].flashing {
				octopodes[p.y][p.x].energy += 1;
				octopodes[p.y][p.x].flashing = true;
				flash_counter += 1;
				// for all adjacent points, we add to the queue
				// if and only if they are also ready to flash
				let surrounding_points: Vec<Point2D> = octopodes
					.get_surrounding_indices(&p)
					.unwrap();
				
				// need to increase all of the surrounding indices
				// for all ready-to-flash points, and put them in in the queue
				for p2 in surrounding_points {
					octopodes[p2.y][p2.x].energy += 1;
					if !surrounding_queue.contains(&p2) {
						surrounding_queue.push_back(p2);
					}
				}
			}
		}
	}
	
	// Finally, any octopus that flashed during this step 
	// has its energy level set to 0, as it used all of its 
	// energy to flash.
	for p in points.iter() {
		if octopodes[p.y][p.x].flashing {
			octopodes[p.y][p.x].flashing = false;
			octopodes[p.y][p.x].energy = 0;
		}
	}
		
	return flash_counter;
}

fn simulate_steps(octopodes: &mut Octopodes, nsteps: usize) -> (&mut Octopodes, usize) {
	let mut flash_counter: usize = 0;
	for _ in 0..nsteps {
		flash_counter += simulate_step(octopodes);
	}
	return (octopodes, flash_counter);
}

fn part1(octopodes: &Octopodes, nsteps: usize) -> usize {
	let mut octopodes_mutable = octopodes.clone();
	let (octopodes_final, flash_counter) = simulate_steps(&mut octopodes_mutable, nsteps);
	let mut octopodes_final_str = String::new();
	for row in octopodes_final {
		octopodes_final_str.push_str("  ");
		for el in row {
			octopodes_final_str.push_str(el.energy.to_string().as_str());
		}
		octopodes_final_str.push_str("\n");
	}
	println!("Final Octopodes State (Part 1): \n{}", octopodes_final_str);
	return flash_counter;
}

// Part 2

/*
fn all_equal_to(octopodes: &Octopodes, n: usize) -> bool {
	for row in octopodes {
		for
	}
	ret
}*/

fn find_unanimous_state(octopodes: &mut Octopodes, val: u8) -> (&mut Octopodes, usize) {
	let mut state_counter: usize = 0;
	while !octopodes.iter().all(|row| {row.iter().all(|el| { el.energy == val })}) {
		simulate_step(octopodes);
		state_counter += 1;
	}
	
	return (octopodes, state_counter);
}

fn part2(octopodes: &Octopodes, ubiquitous_val: u8) -> usize {
	let mut octopodes_mutable = octopodes.clone();
	let (_octopodes_final, flash_counter) = find_unanimous_state(&mut octopodes_mutable, ubiquitous_val);
	return flash_counter;
}
