use std::fs::File;
use std::io::{prelude::*, BufReader};
use std::collections::{HashMap, VecDeque};

// NOTE: immediately I can see that this is an optimisation
// problem.  The only problem is that I don't know Rust well
// enough to solve a problem like this...
// I will do the naïve approach
fn main() {
	// let data = parse_input("test.txt");
	let data = parse_input("data9.txt");
	
	// part 1	
	let a: Vec<Vec<u8>> = vec![
		vec![1, 2, 3],
		vec![4, 5, 6],
		vec![7, 8, 9],
	];
	assert_eq!(a.get_surrounding_values(&Point2D { x: 0, y: 0, }), Some(vec![2, 4]));
	assert_eq!(a.get_surrounding_values(&Point2D { x: 1, y: 1, }), Some(vec![4, 6, 2, 8]));
	let part1_solution = part1(&data);
	println!("Part 1: {}", part1_solution);
	
	// part 2
	assert_eq!(a.get_surrounding_indices(&Point2D { x: 0, y: 0, }), Some(vec![Point2D { x: 1, y: 0 }, Point2D { x: 0, y: 1 }]));
	assert_eq!(a.get_surrounding_indices(&Point2D { x: 1, y: 1, }), Some(vec![Point2D { x: 0, y: 1 }, Point2D { x: 2, y: 1 }, Point2D { x: 1, y: 0 }, Point2D { x: 1, y: 2 }]));
	let part2_solution = part2(&data);
	println!("Part 2: {}", part2_solution);
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

trait SurroundingVals1D {
	fn get_surrounding_values_from_vec(&self, i: usize) -> Option<Vec<u8>>;
}

trait SurroundingVals2D {
	fn get_surrounding_values(&self, p: &Point2D) -> Option<Vec<u8>>;
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

#[derive(Debug, PartialEq, Eq, Hash, Clone, Copy)]
struct Point2D {
	x: usize,
	y: usize,
}

impl SurroundingVals2D for Vec<Vec<u8>> {
	fn get_surrounding_values(&self, p: &Point2D) -> Option<Vec<u8>> {
		let x = p.x;
		let y = p.y;
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

fn find_minima(data: &Vec<Vec<u8>>) -> HashMap<Point2D, u8> {
	let nrows = data.len();
	let ncols = data[0].len();
	let mut minima: HashMap<Point2D, u8> = HashMap::new();
	for y in 0..nrows {
		for x in 0..ncols {
			let p = Point2D { x, y, };
			let v = data[y][x];
			let is_minimum = data.get_surrounding_values(&p)
				.unwrap()
				.iter()
				.all(|w| { v < *w });
			if is_minimum {
				minima.insert(p, v);
			}
		}
	}
	return minima
}

fn part1(data: &Vec<Vec<u8>>) -> usize {
	let minima = find_minima(data);
	return minima.iter().map(|(_p, v)| {
			let risk_level = *v as usize + 1; 
			risk_level
		})
		.sum();
}

// Part 2

/*
const SURROUNDING_DIRECTIONS_2D: [(isize, isize); 8] = [
	(-1, -1),
	( 0, -1),
	( 1, -1),
	(-1,  0),
	( 1,  0),
	(-1,  1),
	( 0,  1),
	( 1,  1),
];
*/

const SURROUNDING_DIRECTIONS_2D: [(isize, isize); 4] = [
	(-1,  0),
	( 1,  0),
	( 0, -1),
	( 0,  1),
];

trait AllSurroundingVals2D<T> {
	fn get_surrounding_indices(&self, p: &Point2D) -> Option<Vec<Point2D>>;
}

impl<T> AllSurroundingVals2D<T> for Vec<Vec<T>>
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
		let surrounding_values: Vec<Point2D> = SURROUNDING_DIRECTIONS_2D.iter()
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

#[derive(Debug, Clone, Copy, PartialEq)]
enum BasinPoints {
	Maximum,
	Explored,
	Unexplored,
}

#[derive(Debug)]
struct Basin {
	minimum: Point2D,
	components: Vec<Point2D>,
}

fn find_basins(data: &Vec<Vec<u8>>) -> Vec<Basin> {
	// Create a copy of the data where
	let mut minimal_data: Vec<Vec<BasinPoints>> = data.iter()
		.map(|row| {
			row.iter()
				.map(|i| {
					match i {
						9 => BasinPoints::Maximum,
						_ => BasinPoints::Unexplored,
					}
				})
				.collect::<Vec<BasinPoints>>()
		})
		.collect();
	
	let minima = find_minima(data);
	
	let mut basins: Vec<Basin> = Vec::new();
	for (minimum_point, _minimum_val) in minima {
		// initialise basin and surrounding points queue for this minimum point
		let mut basin: Basin = Basin { minimum: minimum_point, components: Vec::new(), };
		let mut surrounding_queue: VecDeque<Point2D> = VecDeque::from(vec![minimum_point]);
		
		// explore minimum
		minimal_data[minimum_point.y][minimum_point.x] = BasinPoints::Explored;
		
		// explore basin
		while !surrounding_queue.is_empty() {
			let p = surrounding_queue.pop_front().expect("100% Rust bug");
			// add the current point (obtained from the queue) to the basin
			basin.components.push(p);
			minimal_data[p.y][p.x] = BasinPoints::Explored;
			// add to the current queue of points in the basin
			let more_surrounding_points: Vec<Point2D> = minimal_data.get_surrounding_indices(&p)
				.unwrap()
				.iter()
				.filter_map(|i| {
					let v = minimal_data[i.y][i.x];
					if v == BasinPoints::Unexplored { Some(*i) } else { None }
				})
				.collect();
			for p2 in more_surrounding_points {
				if !surrounding_queue.contains(&p2) {
					surrounding_queue.push_back(p2);
				}
			}
		}

		basins.push(basin);
	}
	
	return basins;
}

fn part2(data: &Vec<Vec<u8>>) -> usize {
	let mut basin_sizes: Vec<usize> = find_basins(data).iter()
		.map(|b| { b.components.len() })
		.collect();
	basin_sizes.sort();
	basin_sizes.reverse();
	
	return basin_sizes[0] * basin_sizes[1] * basin_sizes[2];
}
