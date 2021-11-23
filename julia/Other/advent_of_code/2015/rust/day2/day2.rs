use std::fs::File;
use std::io::{prelude::*, BufReader};

fn main() {
	// parse input
	let boxes = parse_boxes("data2.txt");
	
	// part 1
	assert_eq!(parse_box_dimensions("2x3x4".to_string()).surface_area(), 52);
	assert_eq!(parse_box_dimensions("2x3x4".to_string()).wrapping_area(), 58);
	assert_eq!(parse_box_dimensions("1x1x10".to_string()).surface_area(), 42);
	assert_eq!(parse_box_dimensions("1x1x10".to_string()).wrapping_area(), 43);
	let part1_solution = part1(&boxes);
	println!("Part 1: {}", part1_solution);
	
	// part 2
	assert_eq!(parse_box_dimensions("2x3x4".to_string()).ribbon_wrap_length(), 10);
	assert_eq!(parse_box_dimensions("2x3x4".to_string()).ribbon_length_with_bow(), 34);
	assert_eq!(parse_box_dimensions("1x1x10".to_string()).ribbon_wrap_length(), 4);
	assert_eq!(parse_box_dimensions("1x1x10".to_string()).ribbon_length_with_bow(), 14);
	let part2_solution = part2(&boxes);
	println!("Part 2: {}", part2_solution);
}

// Structs and methods

struct Box {
	l: isize,
	w: isize,
	h: isize,
}

trait BoxDimensions {
	// part 1
	fn side_areas(&self) -> Vec<isize>;
	fn surface_area(&self) -> isize;
    fn wrapping_area(&self) -> isize;
	
	// part 2
	fn side_perimeters(&self) -> Vec<isize>;
	fn volume(&self) -> isize;
	fn ribbon_wrap_length(&self) -> isize;
	fn ribbon_length_with_bow(&self) -> isize;
}

impl BoxDimensions for Box {
	// part 1 methods
	
	fn side_areas(&self) -> Vec<isize> {
		let lw = self.l * self.w;
		let wh = self.w * self.h;
		let hl = self.h * self.l;
		
		return vec![lw, wh, hl];
	}
	
	fn surface_area(&self) -> isize {
		let area_of_sides = self.side_areas();
		
		let lw = &area_of_sides[0];
		let wh = &area_of_sides[1];
		let hl = &area_of_sides[2];
		
		return 2*lw + 2*wh + 2*hl;
	}
	
    fn wrapping_area(&self) -> isize {
		let area_of_sides = self.side_areas();
		
		let smallest_side = area_of_sides
							.iter().min()
							.unwrap().to_owned();
		
		let wrapping_area: isize = area_of_sides.iter()
									.map(|side_area| 2 * side_area)
									.sum();
		
		return wrapping_area + smallest_side;
    }
	
	// part 2 methods
	
	fn volume(&self) -> isize {
		return self.l * self.w * self.h;
	}
	
	fn side_perimeters(&self) -> Vec<isize> {
		let lw = 2*self.l + 2*self.w;
		let wh = 2*self.w + 2*self.h;
		let hl = 2*self.h + 2*self.l;
		
		return vec![lw, wh, hl];
	}
	
	fn ribbon_wrap_length(&self) -> isize {
		let perimeters = self.side_perimeters();
		
		let smallest_perimeter = perimeters.iter().min()
									.unwrap().to_owned();
		
		return smallest_perimeter;
	}
	
	fn ribbon_length_with_bow(&self) -> isize {
		return self.ribbon_wrap_length() + self.volume();
	}
}

// Parse input

fn parse_boxes(input_file: &str) -> Vec<Box> {
	let mut boxes: Vec<Box> = Vec::new();
	
	let file = File::open(input_file).expect("no such file");
	let buf = BufReader::new(file);
	let lines: Vec<_> = buf.lines()//.collect();
                    .map(|l| l.expect("Could not parse line"))
                    .collect();
	
	for box_dimensions in lines {
		let boxbox = parse_box_dimensions(box_dimensions); // `box` is taken in Rust
		boxes.push(boxbox);
	}
	
	return boxes;
}

fn parse_box_dimensions(dimensions_raw: String) -> Box {
	let boxbox: Vec<isize> = dimensions_raw.split("x")
										   .map(|s| s.parse::<isize>().unwrap())
										   .collect();
	let l = boxbox[0];
	let w = boxbox[1];
	let h = boxbox[2];
	
	return Box{l: l, w: w, h: h};
}

// Part 1

fn part1(boxes: &Vec<Box>) -> isize {
	let mut amount_of_wrapping_paper = 0;
	for boxbox in boxes {
		amount_of_wrapping_paper += boxbox.wrapping_area();
	}
	return amount_of_wrapping_paper;
}

// Part 2

fn part2(presents: &Vec<Box>) -> isize {
	let mut amount_of_ribbon = 0;
	for present in presents {
		amount_of_ribbon += present.ribbon_length_with_bow();
	}
	return amount_of_ribbon;
}
