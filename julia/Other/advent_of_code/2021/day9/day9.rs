use std::fs::File;
use std::io::{prelude::*, BufReader};
use std::collections::HashMap;

// NOTE: immediately I can see that this is an optimisation
// problem.  The only problem is that I don't know Rust well
// enough to solve a problem like this...
// I will do the naïve approach
fn main() {
	let data = parse_input("data9.txt");
	
	// part 1	
	let a: Vec<Vec<u8>> = vec![
		vec![1, 2, 3],
		vec![4, 5, 6],
		vec![7, 8, 9],
	];
	assert_eq!(a.get_surrounding_values(0, 0), Some(vec![2, 4]));
	assert_eq!(a.get_surrounding_values(1, 1), Some(vec![4, 6, 2, 8]));
	let part1_solution = part1(&data);
	println!("Part 1: {}", part1_solution);
}

// Parse input

fn parse_input(data_file: &str) -> Vec<Vec<u8>> {
	const RADIX: u32 = 10;
	let file = File::open(data_file).expect("No such file");
	let buf = BufReader::new(file);
	let data: Vec<Vec<u8>> = buf.lines()
		.map(|l| {
			let line = l.expect("Could not parse line");
			line.chars().map(|d| {
				d.to_digit(RADIX).unwrap() as u8
			})
			.collect::<Vec<u8>>()
		})
		.collect();
	return data;
}

// Part 1

/*
trait SurroundingVals1D<T> {
	fn get_surrounding_values_from_vec(&self, i: usize) -> Option<Vec<T>>;
}

trait SurroundingVals2D<T> {
	fn get_surrounding_values(&self, x: usize, y: usize) -> Option<Vec<T>>;
}

impl<T> SurroundingVals1D<T> for Vec<T> {
	fn get_surrounding_values_from_vec(&self, i: usize) -> Option<Vec<T>> {
		let n = self.len();
		match i {
			0 => { vec![self[i + 1]] },
			_m if _m == n => { vec![self[i - 1]] },
			_ => { vec![self[i - 1], self[i + 1]] },
		}
	}
}

impl<T> SurroundingVals2D<T> for Vec<Vec<T>> {
	fn get_surrounding_values(&self, x: usize, y: usize) -> Option<Vec<T>> {
		let n = self.len();
		let mut surrounding_values = self[y].get_surrounding_values_from_vec(x);
		match y {
			0 => { surrounding_values.push(self[y + 1][x]); },
			_m if _m == n => { surrounding_values.push(self[y - 1][x]); },
			_ => {
				surrounding_values.push(self[y - 1][x]);
				surrounding_values.push(self[y + 1][x])
			},
		}
		return surrounding_values;
	}
}
*/

trait SurroundingVals1D {
	fn get_surrounding_values_from_vec(&self, i: usize) -> Option<Vec<u8>>;
}

trait SurroundingVals2D {
	fn get_surrounding_values(&self, x: usize, y: usize) -> Option<Vec<u8>>;
}

impl SurroundingVals1D for Vec<u8> {
	fn get_surrounding_values_from_vec(&self, i: usize) -> Option<Vec<u8>> {
		let n = self.len();
		if i >= n {
			None
		} else {
			Some(match i {
				0 => { vec![self[i + 1]] },
				_m if _m == n - 1 => { vec![self[i - 1]] },
				_ => { vec![self[i - 1], self[i + 1]] },
			})
		}
	}
}

impl SurroundingVals2D for Vec<Vec<u8>> {
	fn get_surrounding_values(&self, x: usize, y: usize) -> Option<Vec<u8>> {
		let n = self.len();
		if y >= n {
			return None;
		}
		let surrounding_values_opt = self[y].get_surrounding_values_from_vec(x);
		if surrounding_values_opt.is_none() {
			return None;
		}
		let mut surrounding_values = surrounding_values_opt.unwrap();
		match y {
			0 => { surrounding_values.push(self[y + 1][x]); },
			_m if _m == n - 1 => { surrounding_values.push(self[y - 1][x]); },
			_ => {
				surrounding_values.push(self[y - 1][x]);
				surrounding_values.push(self[y + 1][x]);
			},
		};
		return Some(surrounding_values);
	}
}

fn find_minima(data: &Vec<Vec<u8>>) -> HashMap<(usize, usize), u8> {
	let nrows = data.len();
	let ncols = data[0].len();
	let mut minima: HashMap<(usize, usize), u8> = HashMap::new();
	for y in 0..nrows {
		for x in 0..ncols {
			let v = data[y][x];
			let is_minimum = data.get_surrounding_values(x, y)
				.unwrap()
				.iter()
				.all(|w| { v < *w });
			if is_minimum {
				minima.insert((x, y), v);
			}
		}
	}
	return minima
}

fn part1(data: &Vec<Vec<u8>>) -> usize {
	return find_minima(data).iter()
		.map(|(_, v)| { *v as usize + 1 })
		.sum();
}
