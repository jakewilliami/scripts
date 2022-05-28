use std::fs::File;
use std::io::{prelude::*, BufReader};
use std::cmp::{Ordering, max, min};

fn main() {
	// NOTE: I'm not entirely proud of this solution...I keep going with the
	// simplest, most naïve, solution, so I thought I would be clever and ended
	// up somewhat overcomplicating it, and now my solution is O(n^2).
	// Was fun though, except for a range-related bug that took me ages to 
	// figure out.  Was also nice to do literally no extra programming instead
	// of a bit of copy and pasting to get part 2 (because I had already accounted
	// for diagonals, if nothing else in preparation for what I thought it might ask.
	
	// parse input
	let lines = parse_input("data5.txt");
	// let lines = parse_input("test.txt");
	
	// part 1
	let args: Vec<String> = std::env::args().collect();
    let allowed_args: (String, String) = ("1".to_string(), "2".to_string());
	
	// part 1
    if *(&args.contains(&allowed_args.0)) {
		let part1_solution = part1(&lines);
		println!("Part 1: {}", part1_solution);
	}
	
	// part 2
    if *(&args.contains(&allowed_args.1)) {
		let part2_solution = part2(&lines);
		println!("Part 2: {}", part2_solution);
	}
}

#[test]
fn test_intersecting_lines() {
	let p1 = Line {
		p: Point { x: 1, y: 1, },
		q: Point { x: 10, y: 1, },
	};
	let p2 = Line {
		p: Point { x: 1, y: 2, },
		q: Point { x: 10, y: 2, },
	};
	let p3 = Line {
		p: Point { x: 10, y: 0, },
		q: Point { x: 0, y: 10, },
	};
	let p4 = Line {
		p: Point { x: 0, y: 0, },
		q: Point { x: 10, y: 10, },
	};
	let p5 = Line {
		p: Point { x: -5, y: -5, },
		q: Point { x: 0, y: 0, },
	};
	let p6 = Line {
		p: Point { x: 1, y: 1, },
		q: Point { x: 10, y: 10, },
	};
	assert!(!p1.intersects(&p2));
	assert!(p3.intersects(&p4));
	assert!(!p5.intersects(&p6));
	assert!(!p2.intersects(&p1));
	assert!(p4.intersects(&p3));
	assert!(!p6.intersects(&p5));
}

#[test]
fn test_get_points_on_line() {	
	let line = Line {
		p: Point { x: 0, y: 1, },
		q: Point { x: 6, y: 4, },
	};
	assert_eq!(line.points().unwrap(), vec![Point{ x: 0, y: 1, }, Point{ x: 1, y: 1, }, Point{ x: 2, y: 2, }, Point{ x: 3, y:2, }, Point{ x: 4, y: 3, }, Point{ x: 5, y: 3, }, Point{ x: 6, y: 4, }]);

	// test for points of intersection
	let p7 = Line {
		p: Point { x: 1, y: 1, },
		q: Point { x: 10, y: 10, },
	};
	let p8 = Line {
		p: Point { x: 2, y: 2, },
		q: Point { x: 11, y: 11, },
	};
	let p9 = Line {
		p: Point { x: 1, y: 1, },
		q: Point { x: 10, y: 10, },
	};
	let p10 = Line {
		p: Point { x: 0, y: 1, },
		q: Point { x: 8, y: 10, },
	};
	let p11 = Line {
		p: Point { x: 3, y: 4, },
		q: Point { x: 1, y: 4, },
	};
	let p12 = Line {
		p: Point { x: 9, y: 4, },
		q: Point { x: 3, y: 4, },
	};
	assert_eq!(p11.points_of_intersection(&p12), vec![Point { x: 3, y: 4 }]);
	assert_eq!(p11.points().unwrap(), vec![Point { x: 1, y: 4 }, Point { x: 2, y: 4 }, Point { x: 3, y: 4 }]);
	assert_eq!(p12.points().unwrap(), vec![Point { x: 3, y: 4 }, Point { x: 4, y: 4 }, Point { x: 5, y: 4 }, Point { x: 6, y: 4 }, Point { x: 7, y: 4 }, Point { x: 8, y: 4 }, Point { x: 9, y: 4 }]);
	assert_eq!(p7.points_of_intersection(&p8), vec![Point { x: 2, y: 2 }, Point { x: 3, y: 3 }, Point { x: 4, y: 4 }, Point { x: 5, y: 5 }, Point { x: 6, y: 6 }, Point { x: 7, y: 7 }, Point { x: 8, y: 8 }, Point { x: 9, y: 9 }, Point { x: 10, y: 10 }]);
	assert_eq!(p7.points_of_intersection(&p8), p8.points_of_intersection(&p7));
	assert_eq!(p9.points_of_intersection(&p10), vec![]);
}

// Structs and such

#[derive(Debug, Eq, PartialEq, Clone, Copy, Hash)]
struct Point {
	x: isize,
	y: isize,
}

#[derive(Debug)]
struct Line {
	p: Point,
	q: Point,
}

// Parse input

trait ToPoint {
	fn to_point(&self) -> Option<Point>;
}

impl ToPoint for String {
	fn to_point(&self) -> Option<Point> {
		let tokens: Vec<String> = self.split(",").map(|s| s.to_string()).collect();
		let x = tokens[0].parse::<isize>();
		let y = tokens[1].parse::<isize>();
		if x.is_err() || y.is_err() {
			return None;
		}
		return Some(Point {
			x: x.unwrap(),
			y: y.unwrap(),
		});
	}
}

trait ToLine {
	fn to_line(&self) -> Option<Line>;
}

impl ToLine for String {
	fn to_line(&self) -> Option<Line> {
		let tokens: Vec<String> = self.split(" -> ").map(|s| s.to_string()).collect();
		let p = tokens[0].to_point();
		let q = tokens[1].to_point();
		if p.is_none() || q.is_none() {
			return None;
		}
		return Some(Line {
			p: p.unwrap(),
			q: q.unwrap(),
		});
	}
}

fn parse_input(data_file: &str) -> Vec<Line> {
	let file = File::open(data_file).expect("No such file");
	let buf = BufReader::new(file);
	let lines: Vec<Line> = buf.lines()
		.map(|l| l.expect("Could not parse line").to_line().unwrap())
		.collect();
	return lines;
}

// Part 1

enum LineCardinality {
	Horizontal,
	Vertical,
	Diagonal,
}

trait Cardinality {
	fn is_horizontal(&self) -> bool;
	fn is_vertical(&self) -> bool;
	fn is_diagonal(&self) -> bool;
	fn cardinality(&self) -> Option<LineCardinality>;
}

impl Cardinality for Line {
	fn is_horizontal(&self) -> bool {
		return self.p.y == self.q.y;
	}
	
	fn is_vertical(&self) -> bool {
		return self.p.x == self.q.x;
	}
	
	fn is_diagonal(&self) -> bool {
		return !self.is_horizontal() && !self.is_vertical();
	}
	
	fn cardinality(&self) -> Option<LineCardinality> {
		if self.is_horizontal() {
			return Some(LineCardinality::Horizontal);
		} else if self.is_vertical() {
			return Some(LineCardinality::Vertical);
		} else if self.is_diagonal() {
			return Some(LineCardinality::Diagonal);
		}
		
		// should never get here...
		return None;
	}
}

fn on_segment(p: &Point, q: &Point, r: &Point) -> bool {
	// Given three collinear points p, q, r, the function checks if
	// point q lies on line segment 'pr'
	return (q.x <= max(p.x, r.x)) && (q.x >= min(p.x, r.x)) &&
		(q.y <= max(p.y, r.y)) && (q.y >= min(p.y, r.y));
}

#[derive(PartialEq)]
enum Orientation {
	Collinear,
	Clockwise,
	AntiClockwise
}

fn orientation(p: &Point, q: &Point, r: &Point) -> Orientation {
	// find the orientation of an ordered triplet (p,q,r)
	let x = (q.y - p.y) as f64 * (r.x - q.x) as f64;
	let y = (q.x - p.x) as f64 * (r.y - q.y) as f64;
	let z = x - y;
	return match z.partial_cmp(&0.0).expect("Cannot compare values in `orientation` definition") {
		Ordering::Less => Orientation::AntiClockwise,
		Ordering::Greater => Orientation::Clockwise,
		Ordering::Equal => Orientation::Collinear,
	};
}

trait Intersects {
	// http://www.dcs.gla.ac.uk/~pat/52233/slides/Geometry1x1.pdf
	fn intersects(&self, l: &Line) -> bool;
}

impl Intersects for Line {
	fn intersects(&self, l: &Line) -> bool {
		let p1 = &self.p;
		let q1 = &self.q;
		let p2 = &l.p;
		let q2 = &l.q;
		
		// Find the 4 orientations required for
		// the general and special cases
		let o1 = orientation(p1, q1, p2);
		let o2 = orientation(p1, q1, q2);
		let o3 = orientation(p2, q2, p1);
		let o4 = orientation(p2, q2, q1);
		
		// general case
		if (o1 != o2) && (o3 != o4) {
			return true;
		}
		
		// special cases
		
		// p1 , q1 and p2 are collinear and p2 lies on segment p1q1
		if (o1 == Orientation::Collinear) && on_segment(&p1, &p2, &q1) {
			return true;
		}
		
		// p1 , q1 and q2 are collinear and q2 lies on segment p1q1
		if (o2 == Orientation::Collinear) && on_segment(&p1, &q2, &q1) {
			return true;
		}
		
		// p2 , q2 and p1 are collinear and p1 lies on segment p2q2
		if (o3 == Orientation::Collinear) && on_segment(&p2, &p1, &q2) {
			return true;
		}
		
		// p2 , q2 and q1 are collinear and q1 lies on segment p2q2
		if (o4 == Orientation::Collinear) && on_segment(&p2, &q1, &q2) {
			return true;
		}
		
		// if we reached this point then the lines cannot be collinear
		return false;
	}
}

// Bresenham's line algorithm
// https://www.wikiwand.com/en/Bresenham%27s_line_algorithm
trait PointsOnLine {
	fn points(&self) -> Option<Vec<Point>>;
	fn points_of_intersection(&self, l: &Line) -> Vec<Point>;
}

enum Gradient {
	Low,
	High,
}

fn points_on_line(x0: isize, y0: isize, x1: isize, y1: isize, gradient: Gradient) -> Vec<Point> {
	match gradient {
		Gradient::Low => {
			let dx = x1 - x0;
			let mut dy = y1 - y0;
			
			let mut yi = 1;
			if dy < 0 {
				yi = -1;
				dy = -dy;
			}
			
			let mut d = (2 * dy) - dx;
			let mut y = y0;
			
			let mut points: Vec<Point> = Vec::new();
			
			for x in x0..=x1 {
				points.push(Point{ x, y });
				if d > 0 {
					y += yi;
					d += 2 * (dy - dx);
				} else {
					d += 2*dy;
				}
			}
		
			return points;
		},
		Gradient::High => {
			let mut dx = x1 - x0;
			let dy = y1 - y0;
			
			let mut xi = 1;
			if dx < 0 {
				xi = -1;
				dx = -dx;
			}
			
			let mut d = (2 * dx) - dy;
			let mut x = x0;
			
			let mut points: Vec<Point> = Vec::new();
			
			for y in y0..=y1 {
				points.push(Point{ x, y });
				if d > 0 {
					x += xi;
					d += 2 * (dx - dy);
				} else {
					d += 2*dx;
				}
			}
		
			return points;
		},
	}
}

/*
fn points_low(x0: isize, y0: isize, x1: isize, y1: isize) -> Vec<Point> {
	let dx = x1 - x0;
	let mut dy = y1 - y0;
	
	let mut yi = 1;
	if dy < 0 {
		yi = -1;
		dy = -dy;
	}
	
	let mut d = (2 * dy) - dx;
	let mut y = y0;
	
	let mut points: Vec<Point> = Vec::new();
	
	for x in x0..=x1 {
		points.push(Point{ x, y });
		if d > 0 {
			y += yi;
			d += 2 * (dy - dx);
		} else 
			d += 2*dy;
		}
	}

	return points;
}

fn points_high(x0: isize, y0: isize, x1: isize, y1: isize) -> Vec<Point> {
	let mut dx = x1 - x0;
	let dy = y1 - y0;
	
	let mut xi = 1;
	if dx < 0 {
		xi = -1;
		dx = -dx;
	}
	
	let mut d = (2 * dx) - dy;
	let mut x = x0;
	
	let mut points: Vec<Point> = Vec::new();
	
	for y in y0..=y1 {
		points.push(Point{ x, y });
		if d > 0 {
			x += xi;
			d += 2 * (dx - dy);
		} else 
			d += 2*dx;
		}
	}

	return points;
}
*/

impl PointsOnLine for Line {
	fn points(&self) -> Option<Vec<Point>> {
		let cardinality = self.cardinality();
		match cardinality {
			Some(LineCardinality::Horizontal) => {
				let y = self.p.y;
				assert_eq!(y, self.q.y);
				let range = if self.p.x <= self.q.x {
					self.p.x..=self.q.x
				} else {
					self.q.x..=self.p.x
				};
				Some(range.map(|x| {
						Point { x, y, }
					})
					.collect())
			},
			Some(LineCardinality::Vertical) => {
				let x = self.p.x;
				assert_eq!(x, self.q.x);
				let range = if self.p.y <= self.q.y {
					self.p.y..=self.q.y
				} else {
					self.q.y..=self.p.y
				};
				Some(range.map(|y| {
						Point { x, y, }
					})
					.collect())
			},
			Some(LineCardinality::Diagonal) => {
				let x0 = self.p.x;
				let y0 = self.p.y;
				let x1 = self.q.x;
				let y1 = self.q.y;
				
				match (y1 - y0).abs() < (x1 - x0).abs() {
					true => {
						match x0 > x1 {
							true => { Some(points_on_line(x1, y1, x0, y0, Gradient::Low)) },
							false => { Some(points_on_line(x0, y0, x1, y1, Gradient::Low)) },
						}
					},
					false => {
						match y0 > y1 {
							true => { Some(points_on_line(x1, y1, x0, y0, Gradient::High)) },
							false => { Some(points_on_line(x0, y0, x1, y1, Gradient::High)) },
						}
					},
				}
			},
			None => None,
		}
	}
	
	fn points_of_intersection(&self, l: &Line) -> Vec<Point> {
		let points1 = self.points().unwrap();
		let points2 = l.points().unwrap();
		return points1.iter().filter(|p| {
			points2.contains(&p)
		}).map(|p| p.to_owned())
		.collect();
	}
}

fn part1(all_lines: &Vec<Line>) -> usize {
	let lines: Vec<_> = all_lines
		.iter()
		.filter(|l| !l.is_diagonal())
		.collect();
	
	let mut intersecting_points: Vec<Point> = Vec::new();
	for i in 0..lines.len() {
		let l1 = &lines[i];
		for j in (i + 1)..lines.len() {
			let l2 = &lines[j];
			if l1.intersects(&l2) {
				let points_of_intersection = l1.points_of_intersection(l2);
				for p in points_of_intersection {
					if !intersecting_points.contains(&p) {
						intersecting_points.push(p);
					}
				}
			}
		}
	}
	
	return intersecting_points.len();
}

// Part 2

fn part2(lines: &Vec<Line>) -> usize {
	let mut intersecting_points: Vec<Point> = Vec::new();
	for i in 0..lines.len() {
		let l1 = &lines[i];
		for j in (i + 1)..lines.len() {
			let l2 = &lines[j];
			if l1.intersects(&l2) {
				let points_of_intersection = l1.points_of_intersection(l2);
				for p in points_of_intersection {
					if !intersecting_points.contains(&p) {
						intersecting_points.push(p);
					}
				}
			}
		}
	}
	
	return intersecting_points.len();
}
