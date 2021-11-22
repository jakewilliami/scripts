use std::fs::File;
use std::io::{prelude::*, BufReader};

fn main() {
	let passwords = parse_input("data2.txt");
	
	// part 1
	let part1_solution = part1(&passwords);
	println!("Part 1: {}", part1_solution);

	// part 2
	let part2_solution = part2(&passwords);
	println!("Part 2: {}", part2_solution);
}

struct PasswordRequirements {
	lo: usize,
	hi: usize,
	ch: char,
}

fn parse_input(input_file: &str) -> Vec<(String, PasswordRequirements)> {
	let mut out: Vec<(String, PasswordRequirements)> = Vec::new();
	
	let file = File::open(input_file).expect("no such file");
    let buf = BufReader::new(file);
	let lines: Vec<_> = buf.lines()//.collect();
        			.map(|l| l.expect("Could not parse line"))
        			.collect();
	
	// let reader = BufReader::new(input_file);
	// let lines: Vec<_> = reader.lines().collect();
	
	
	// let lines = std::fs::read_to_string(input_file)
		// .unwrap()
		// .split('\n') // split by new line
		// .filter(|s| !s.is_empty()); // filter empty lines (i.e., last line;
	// let file = File::open(input_file).expect("no such file");
    // let buf = BufReader::new(input_file);
    // buf.lines()
        // .map(|l| l.expect("Could not parse line"))
        // .collect()
	
	
	for line in lines {
		let req_pass: Vec<String> = line.split(": ").map(|s| s.to_string()).collect();
		let req_raw = &req_pass[0];
		let pass = &req_pass[1];
		// let (req_raw, pass) = line.split(": ").map(|s| s.to_string()).collect();
		let rng_ch: Vec<String> = req_raw.split(" ").map(|s| s.to_string()).collect();
		let rng = &rng_ch[0];
		let ch = &rng_ch[1].chars().next().unwrap();
		// let (rng, ch) = req_raw.split(" ");
		let lo_hi: Vec<usize> = rng.split("-").map(|s| s.parse::<usize>().unwrap()).collect();
		// let (lo, hi) = rng.split("-");
		// let pass_string = pass.to_string();
		// let lo_i = lo.parse::<i64>();
		// let hi_i = hi.parse::<i64>();
		let lo = lo_hi[0];
		let hi = lo_hi[1];
		// let c = ch.chars().next().unwrap();
		let req = PasswordRequirements{lo: lo, hi: hi, ch: *ch};
		// out.push(Password{pass: pass.to_string(), req: req});
		out.push((pass.to_string(), req));
	}
	return out;
}

fn password_isvalid_part1(pass: &String, req: &PasswordRequirements) -> bool {
	let i = pass.matches(req.ch).count();
	let rng = req.lo..=req.hi;
	return rng.contains(&i);
}

fn part1(passwords: &Vec<(String, PasswordRequirements)>) -> usize {
	let mut cnt: usize = 0;
	for (pass, req) in passwords {
		if password_isvalid_part1(pass, req) {
			cnt += 1;
		}
	}
	return cnt;
}

fn password_isvalid_part2(pass: &String, req: &PasswordRequirements) -> bool {
	/*
    1-3 a: abcde is valid: position 1 contains a and position 3 does not.
    1-3 b: cdefg is invalid: neither position 1 nor position 3 contains b.
    2-9 c: ccccccccc is invalid: both position 2 and position 9 contain c.
	*/
	let pass_chars: Vec<char> = pass.chars().collect();
	let c1 = &pass_chars[req.lo - 1];
	let c2 = &pass_chars[req.hi - 1];
	// let b1 = pass_chars.contains(&pass_chars[req.lo - 1]);
	// let b2 = pass_chars.contains(&pass_chars[req.hi - 1]);
	// println!("{}: '{}'; {}: '{}'", req.lo, c1, req.hi, c2);
	// return (pass_chars.contains(c1) || pass_chars.contains(c2)) && ;
	// return (b1 || b2) && (b1 != b2);
	return (c1 == &req.ch) ^ (c2 == &req.ch);
}

fn part2(passwords: &Vec<(String, PasswordRequirements)>) -> usize {
	let mut cnt: usize = 0;
	for (pass, req) in passwords {
		if password_isvalid_part2(pass, req) {
			cnt += 1;
		}
	}
	return cnt;
}
