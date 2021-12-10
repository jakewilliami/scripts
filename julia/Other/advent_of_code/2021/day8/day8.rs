use std::fs::File;
use std::io::{prelude::*, BufReader};
use std::collections::HashMap;

fn main() {
	let observations = parse_input("data8.txt");
	// let observations = parse_input("test.txt");
	
	// part 1
	let part1_solution = part1(&observations);
	println!("Part 1: {}", part1_solution);
}

// Structs and such

#[derive(Debug, Clone, Copy)]
struct SevenSegmentDisplay {
	a: bool,
	b: bool,
	c: bool,
	d: bool,
	e: bool,
	f: bool,
	g: bool,
}

#[derive(Debug)]
struct Observations {
	signal_patterns: [SevenSegmentDisplay; 10],
	four_digits: [SevenSegmentDisplay; 4],
}

impl Default for SevenSegmentDisplay {
	fn default() -> Self {
		SevenSegmentDisplay {
			a: false,
			b: false,
			c: false,
			d: false,
			e: false,
			f: false,
			g: false,
		}
	}
}

static SEVEN_SEGMENT_DISPLAYS: [SevenSegmentDisplay; 10] = [
	SevenSegmentDisplay { a: true, b: true, c: true, d: false, e: true, f: true, g: true, },
	SevenSegmentDisplay { a: false, b: false, c: true, d: false, e: false, f: true, g: false, },
	SevenSegmentDisplay { a: true, b: false, c: true, d: true, e: true, f: false, g: true, },
	SevenSegmentDisplay { a: true, b: false, c: true, d: true, e: false, f: true, g: true, },
	SevenSegmentDisplay { a: false, b: true, c: true, d: true, e: false, f: true, g: false, },
	SevenSegmentDisplay { a: true, b: true, c: false, d: true, e: false, f: true, g: true, },
	SevenSegmentDisplay { a: true, b: true, c: false, d: true, e: true, f: true, g: true, },
	SevenSegmentDisplay { a: true, b: false, c: true, d: false, e: false, f: true, g: false, },
	SevenSegmentDisplay { a: true, b: true, c: true, d: true, e: true, f: true, g: true, },
	SevenSegmentDisplay { a: true, b: true, c: true, d: true, e: false, f: true, g: true, },
];

// Parse input

impl From<&str> for SevenSegmentDisplay {
	fn from(segments_str: &str) -> Self {
		let segments: Vec<char> = segments_str.chars().collect();
		return SevenSegmentDisplay {
			a: segments.contains(&'a'),
			b: segments.contains(&'b'),
			c: segments.contains(&'c'),
			d: segments.contains(&'d'),
			e: segments.contains(&'e'),
			f: segments.contains(&'f'),
			g: segments.contains(&'g'),
		}
	}
}

fn parse_input(data_file: &str) -> Vec<Observations> {
	let file = File::open(data_file).expect("no such file");
	let buf = BufReader::new(file);
	let data: Vec<Observations> = buf.lines()
		.map(|l| {
			let line = l.expect("Could not parse line");
			let observations_raw: Vec<_> = line.split(" | ").collect();
			let mut signal_patterns = [SevenSegmentDisplay { ..Default::default() }; 10];
			let mut four_digits = [SevenSegmentDisplay { ..Default::default() }; 4];
			for (i, s) in observations_raw[0].split_whitespace().enumerate() {
				signal_patterns[i] = SevenSegmentDisplay::from(s);
			}
			for (i, s) in observations_raw[1].split_whitespace().enumerate() {
				four_digits[i] = SevenSegmentDisplay::from(s);
			}
			Observations {
				signal_patterns,
				four_digits,
			}
		})
		.collect();
	return data;
}

// Part 1

trait CountSegments {
	fn count_segments(&self) -> usize;
}

impl CountSegments for SevenSegmentDisplay {
	fn count_segments(&self) -> usize {
		let mut cnt = 0;
		if self.a { cnt += 1 }
		if self.b { cnt += 1 }
		if self.c { cnt += 1 }
		if self.d { cnt += 1 }
		if self.e { cnt += 1 }
		if self.f { cnt += 1 }
		if self.g { cnt += 1 }
		return cnt;
	}
}

fn part1(observations: &Vec<Observations>) -> usize {
	// simple segments definitions
	let simple_segments: [usize; 4] = [1, 4, 7, 8];
	let simple_segment_counts: Vec<usize> = simple_segments.iter()
		.map(|i| SEVEN_SEGMENT_DISPLAYS[*i].count_segments())
		.collect();
	
	// find all simple segments
	let mut cnt = 0;
	for observation in observations {
		for digit in observation.four_digits {
			if simple_segment_counts.contains(&digit.count_segments()) {
				cnt += 1;
			}
		}
	}
	
	return cnt;
}

// Part 2

trait GetField {
	fn get_field(&self, field: &str) -> bool;
	fn get_field(&self, field: String) -> bool;
	fn get_field(&self, field: char) -> bool;
}

impl GetField for SevenSegmentDisplay {
	fn get_field(&self, field: &str) -> bool {
		return match field {
			"a" => self.a,
			"b" => self.b,
			"c" => self.c,
			"d" => self.d,
			"e" => self.e,
			"f" => self.f,
			"g" => self.g,
		}
	}
	
	fn get_field(&self, field: String) -> bool {
		return self.get_field(field.as_str());
	}
	
	fn get_field(&self, field: char) -> bool {
		return self.get_field(field.to_string());
	}
}

fn part2(observations: &Vec<Observations>) -> usize {
	// simple segment definitions
	let mut simple_segments: HashMap<usize: usize> = HashMap::new();
	let simple_segment_numbers: [usize; 4] = [1, 4, 7, 8];
	for i in simple_segment_numbers {
		let simple_segment_count = SEVEN_SEGMENT_DISPLAYS[*i].count_segments();
		simple_segments.insert(simple_segment_count, *i);
	}
	
	// determine simple segment mappings
	let mut simple_segments_parts: HashMap<usize, Vec<char>> = HashMap::new();
	let num_observations = observations.len();
	let mut i: usize = 0;
	while i < num_observations {
		let observation = observations[i];
		for signal_pattern in observation.signal_patterns {
			let segment_count = signal_pattern.count_segments();
			match simple_segments.get(&segment_count) {
				Some() => {},
				None => {},
			}
			if num_observations.len() <= 7 {
				break
			}
		}
		i += 1
	}
	
	// initialise result hashmap
	let mut segment_wire_map: HashMap<&str, &str> = HashMap::new();
	
	return 1;
}
