use std::fs::File;
use std::io::{prelude::*, BufReader};
// use petgraph::Graph;
use std::collections::HashMap;

fn main() {
	let data = parse_input("src/small.txt");
	// let data = parse_input("src/medium.txt");
	// let data = parse_input("src/large.txt");
	println!("{:?}", data);
	paths = vec![];
	start = cave_map.get().expect("There is no starting node!");
	traverse_graph(&mut paths, &mut cave_map, start);
}

#[derive(Debug, PartialEq, Eq, Hash, Clone)]
enum CaveType {
	Big(String),
	Small(String),
	Start,
	End,
}

#[derive(Debug, Clone)]
struct Cave {
	ctype: CaveType,
	visited: usize,
	connections: Vec<CaveType>,
}

fn parse_cave_type(cave_type_str: &str) -> CaveType {
	return match cave_type_str {
		"start" => CaveType::Start,
		"end" => CaveType::End,
		_ => if cave_type_str.chars().all(|c| c.is_uppercase()) { 
				CaveType::Big(cave_type_str.to_string())
			} else { 
				CaveType::Small(cave_type_str.to_string())
			},
		};
}

fn parse_cave(cave_str: &str) -> Cave {
	return Cave { 
		ctype: parse_cave_type(cave_str),
		visited: 0, 
		connections: Vec::new(),
	};
}

type CaveGraph = HashMap<CaveType, Cave>;

fn parse_input(data_file: &str) -> CaveGraph {
	let file = File::open(data_file).expect("No such file");
	let buf = BufReader::new(file);
	let mut cave_map: CaveGraph = HashMap::new();
	for line_opt in buf.lines() {
		let line = line_opt.expect("Could not parse line in file");
		let (cave1_str, cave2_str) = line.split_once('-').expect(format!("Problem splitting line {:?}", line));
		let cave1 = parse_cave(cave1_str);
		let cave2 = parse_cave(cave2_str);

		// If line is "a-b", ensure node "a" is added to map, and has connector "b"
		if let Some(c) = cave_map.get_mut(&cave1.ctype) {
		    c.connections.push(cave2.ctype.clone());
		} else {
			cave_map.insert(cave1.ctype.clone(), cave1.clone());
		}

		// If line is "a-b", ensure node "b" is added to map, and has connector "a"
		if let Some(c) = cave_map.get_mut(&cave2.ctype) {
		    c.connections.push(cave1.ctype.clone());
		} else {
			cave_map.insert(cave2.ctype.clone(), cave2.clone());
			cave_map.get_mut(&cave2.ctype.clone()).expect("100% Rust bug").connections.push(cave1.ctype);
		}
	}
	
	// Ensure we have an all-important start and end node!	
	assert!(cave_map.contains_key(CaveType::Start))
	assert!(cave_map.contains_key(CaveType::End))
	
	return cave_map;
}

fn traverse_graph(paths: &mut Vec<CaveType>, cave_map: &mut CaveGraph, start_node: &Cave) {
	// for node in start_node.connections {
	start_node.connections.retain(|node| {
		let delete = {
			if let Some(cave_node) = cave_map.get_mut(node) {
				match node {
					CaveType::End => {
						todo!()
					},
					CaveType::Small => {
						if node.visited == 0 {
							*node.visited += 1;
							traverse_graph(paths, cave_map, &node);
						}
					},
					CaveType::Big => {
						todo!()
					},
					CaveType::Start => {
						panic!("Something has gone horribly wrong")
					}
				}
			}
		todo!("return a bool")
		}
		!delete
	})
	todo!()
}

