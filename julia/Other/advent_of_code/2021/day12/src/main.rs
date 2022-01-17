use std::fs::File;
use std::io::{prelude::*, BufReader};
use petgraph::Graph;

fn main() {
    println!("Hello, world!");
	let mut graph = Graph::new();
	let n1 = graph.add_node(LinkTarget::LabelSelector(Default::default()));
	let _l2 = graph.add_edge(n1, n2, SomeMetadataStruct);
}

struct Cave {
	name: &str,
	size: CaveSize,
	visited: usize,
	connections: Vec<Cave>,
}

enum CaveSize {
	Small,
	Big,
}

fn construct_graph(data_file: &str) -> Graph {
	let file = File::open(data_file).expect("No such file");
	let buf = BufReader::new(file);
	// let lines: Vec<&str> = buf.lines().collect();
	let mut graph = Graph::new();
	for line in buf.lines() {
		let nodes_str = line.split("-").collect();
		let n1 = graph.add_node(nodes_str[0]);
		let n2 = graph.add_node(nodes_str[1]);
		let _edge = graph.add_edge(n1, n2)
	}
}


