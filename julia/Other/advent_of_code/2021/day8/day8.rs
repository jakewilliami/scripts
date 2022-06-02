use std::fs::File;
use std::io::{prelude::*, BufReader};
use std::collections::HashMap;
use std::ops::{BitAnd, Not, BitXor, Sub};

fn main() {
	// let observations = parse_input("data8.txt");
	let observations = parse_input("test.txt");
	
	let args: Vec<String> = std::env::args().collect();
    let allowed_args: (String, String) = ("1".to_string(), "2".to_string());

    // part 1
    if *(&args.contains(&allowed_args.0)) {
		let part1_solution = part1(&observations);
		println!("Part 1: {}", part1_solution);
	}
	
	// part 2
    if *(&args.contains(&allowed_args.1)) {
		let mut top_segment = SevenSegmentDisplay { ..Default::default() };
		top_segment.a = true;
		let digital_one = SEVEN_SEGMENT_DISPLAYS[1];
		let digital_seven = SEVEN_SEGMENT_DISPLAYS[7];
		assert_eq!(digital_seven - digital_one, top_segment);
		assert_eq!(digital_one - digital_seven, SevenSegmentDisplay { ..Default::default() }); // order matters
		// let (a, b) = (8, 4);
		// println!("{:?}", SEVEN_SEGMENT_DISPLAYS[a] - SEVEN_SEGMENT_DISPLAYS[b]);
		// let part2_solution = part2(&observations);
		// println!("Part 2: {}", part2_solution);
		todo!()
	}
}

// Structs and such

#[derive(Debug, Clone, Copy, PartialEq)]
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

const SEVEN_SEGMENT_DISPLAYS: [SevenSegmentDisplay; 10] = [
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

const ATOMIC_SEGMENT_NUMBERS: [usize; 4] = [1, 4, 7, 8];
const ATOMIC_SEGMENT_COUNTS: [usize; 4] = [2, 4, 3, 7];

const SEVEN_SEGMENT_COUNTS: [usize; 10] = [6, 2, 5, 5, 4, 5, 6, 3, 7, 6];

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

impl BitAnd for SevenSegmentDisplay {
	type Output = Self;
	
	// rhs is the "right-hand side" of the expression `a & b`
	fn bitand(self, rhs: Self) -> Self::Output {
		SevenSegmentDisplay {
			a: self.a & rhs.a,
			b: self.b & rhs.b,
			c: self.c & rhs.c,
			d: self.d & rhs.d,
			e: self.e & rhs.e,
			f: self.f & rhs.f,
			g: self.g & rhs.g,
		}
	}
}

impl Not for SevenSegmentDisplay {
	type Output = Self;
	
	fn not(self) -> Self::Output {
		SevenSegmentDisplay {
			a: !self.a,
			b: !self.b,
			c: !self.c,
			d: !self.d,
			e: !self.e,
			f: !self.f,
			g: !self.g,
		}
	}
}

impl Sub for SevenSegmentDisplay {
	type Output = Self;
	
	fn sub(self, other: Self) -> Self::Output {
		self & !other
	}
}

/*
impl BitXor for SevenSegmentDisplay {
	type Output = Self;
	
	// rhs is the "right-hand side" of the expression `a ^ b`
	fn bitxor(self, rhs: Self) -> Self::Output {
		SevenSegmentDisplay {
			a: self.a ^ rhs.a,
			b: self.b ^ rhs.b,
			c: self.c ^ rhs.c,
			d: self.d ^ rhs.d,
			e: self.e ^ rhs.e,
			f: self.f ^ rhs.f,
			g: self.g ^ rhs.g,
		}
	}
}
*/

trait AtomicSegmentMappings {
	fn get_atomic_mappings(&self) -> HashMap<usize, SevenSegmentDisplay>;
	fn get_seg_a(&self, atomic_mappings: HashMap<usize, SevenSegmentDisplay>) -> SevenSegmentDisplay;
}

impl AtomicSegmentMappings for Observations {
	fn get_atomic_mappings(&self) -> HashMap<usize, SevenSegmentDisplay> {
		let mut mappings: HashMap<usize, SevenSegmentDisplay> = HashMap::new();
		for display in self.signal_patterns {
			let n = display.count_segments();
			if ATOMIC_SEGMENT_COUNTS.contains(&n) {
				let i = SEVEN_SEGMENT_COUNTS.iter().position(|&m| m == n).unwrap();
				mappings.insert(i, display);
			}
		}
		assert_eq!(mappings.len(), ATOMIC_SEGMENT_NUMBERS.len()); // observations should have complete mappings
		return mappings;
	}
	
	fn get_seg_a(&self, atomic_mappings: HashMap<usize, SevenSegmentDisplay>) -> SevenSegmentDisplay {
		let digital_one = atomic_mappings[&1];
		let digital_seven = atomic_mappings[&7];
		return digital_seven - digital_one;
	}
}

/*
fn part2(observations: &Vec<Observations>) -> usize {
	for observation in observations {
		println!("{:?}", observation.get_atomic_mappings());
	}
	
	return 1;
}
*/

/*
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

trait GetTrueFields {
	fn get_true_fields(&self) -> Vec<char>;
}

impl GetTrueFields for SevenSegmentDisplay {
	fn get_true_fields(&self) -> Vec<char> {
		let mut s = String::new();
		if self.a { s.push_str('a'); }
		if self.b { s.push_str('b'); }
		if self.c { s.push_str('c'); }
		if self.d { s.push_str('d'); }
		if self.e { s.push_str('e'); }
		if self.f { s.push_str('f'); }
		if self.g { s.push_str('g'); }
		return s.chars().collect()
	}
}

fn determine_simple_segments(observation: Observations, segment_counts: HashMap<usize, usize>) -> HashMap<char, char> {
	let mut simple_segment_mappings: HashMap<char, char> = HashMap::new();
	for signal_pattern in observation.signal_patterns {
		for digit in signal_pattern {
			// if ATOMIC_SEGMENT_NUMBERS.contains(digit)
			// let segment_count = digit.count_segments();
			if segment_counts.has_key(&digit) {
				let true_fields = digit.get_true_fields();
				match segment_counts[digit] {
					2 => { // => digit = 1
						
					},
					4 => { // => digit = 4
						
					},
					3 => { // => digit = 7
						
					},
					7 => { // => digit = 8
						
					},
				}
			}
		}
	}
	return simple_segment_mappings;
}

fn part2(observations: &Vec<Observations>) -> usize {
	// simple segment definitions
	let mut simple_segments: HashMap<usize: usize> = HashMap::new();
	for i in ATOMIC_SEGMENT_NUMBERS {
		let simple_segment_count = SEVEN_SEGMENT_DISPLAYS[*i].count_segments();
		simple_segments.insert(simple_segment_count, *i);
	}
	
	// determine simple segment mappings
	let mut simple_segments_parts: HashMap<usize, Vec<char>> = HashMap::new();
	/*
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
	*/
	for observation in observations {
	}
	
	// initialise result hashmap
	let mut segment_wire_map: HashMap<&str, &str> = HashMap::new();
	
	return 1;
}

//
*/
 
