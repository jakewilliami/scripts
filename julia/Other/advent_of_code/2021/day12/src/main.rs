use std::fs::File;
use std::io::{prelude::*, BufReader};
use std::collections::HashMap;

// using `ndarray` rather than `[[T; m]; n]` mainly because I've already set this project up using `cargo` (for `petgraph`, which I never ended up using), so I figured I could get some experience with this crate.
use ndarray::{Array2, ArrayView};

fn main() {
	let data = parse_input("src/small.txt");
	// let data = parse_input("src/medium.txt");
	// let data = parse_input("src/large.txt");
	
	// part 1
	let part1_solution = part1(&data)
	println!("Part 1: {}", part1_solution);
}

#[derive(Debug, Hash, PartialEq, Eq, Clone)]
enum Cave {
	Big(String),
	Small(String),
	Start,
	End,
}

fn parse_cave(cave_type_str: &str) -> Cave {
	return match cave_type_str {
		"start" => Cave::Start,
		"end" => Cave::End,
		_ => if cave_type_str.chars().all(|c| c.is_uppercase()) { 
				Cave::Big(cave_type_str.to_string())
			} else { 
				Cave::Small(cave_type_str.to_string())
			},
		};
}

#[derive(Debug)]
struct CaveSystem {
	adj_mat: Array2<u8>,
	indices: HashMap<Cave, usize>,
	n_caves: usize,
}

// Read input and return an adjacency matrix
fn parse_input(data_file: &str) -> CaveSystem {
	let file = File::open(data_file).expect("No such file");
	let buf = BufReader::new(file);
	let mut caves = HashMap::<Cave, usize>::new();
	let mut n_caves: usize = 0;
	let mut adj_mat = Array2::<u8>::zeros((0, 0));
	for line_opt in buf.lines() {
		// parse line
		let line = line_opt.expect("Could not parse line in file");
		let (cave1_str, cave2_str) = line.split_once('-').expect(format!("Problem splitting line {:?}", line).as_str());
		let (cave1, cave2) = (parse_cave(cave1_str), parse_cave(cave2_str));
		
		// Update objects with new unique caves
		for cave in vec![cave1.clone(), cave2.clone()].iter() {
			if !caves.contains_key(cave) {
				// add to list of unique caves
				caves.insert(cave.clone(), n_caves);
				n_caves += 1;
				
				// update the adjacency matrix
				adj_mat.push_column(ArrayView::from(&vec![0; n_caves - 1])).unwrap();
				adj_mat.push_row(ArrayView::from(&vec![0; n_caves])).unwrap();
			}
		}
		
		// Update the adjacecy matrix
		let i = caves.get(&cave1).unwrap();
		let j = caves.get(&cave2).unwrap();
		adj_mat[[*i, *j]] = 1;
		adj_mat[[*j, *i]] = 1;
	}
	
	// Ensure cave system has a start and an end!
	assert!(caves.contains_key(Cave::Start))
	assert!(caves.contains_key(Cave::End))
	
	CaveSystem {
		adj_mat: adj_mat,
		indices: caves,
		n_caves: n_caves,
	}
}

fn are_adjacent_caves(caves: &CaveSystem, a: &Cave, b: &Cave) -> Option<bool> {
	let i = caves.indices.get(a);
	let j = caves.indices.get(b);
	if let (Some(i), Some(j)) {  // i.is_none() || j.is_none()
		Some(caves.adj_mat[[i, j]])  // TODO: check if this needs to be switched
	} else {
		None
	}
}

fn dfs(caves: &CaveSystem, a: &Cave, &mut Vec<bool>: visited, mut count: &usize) {
	if let a == Cave::End {
		count += 1;
		return;
	} else {
		for (b, i) in cave.indices.iter() {
			if are_adjacent_caves(caves, a, b) {
				if let a == Cave::Big {
					visited[i] = true;
				}
				dfs(caves, &b, visited, count);
				visited[i] = false;
			}
		}
	}
}

fn part1(caves: &CaveSystem) -> usize {
	let start = caves.indices.get(&Cave::Start).unwrap()
	visited[start] = true;
	let mut count: usize = 0;
	let visited = vec![false; caves.n_caves];
	dfs(caves, &Cave::Start, visited, &mut count);
	count
}
