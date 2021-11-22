fn main() {
	let xs = parse_input("data1.txt");
	
	// part 1
	let part1_solution = part1(&xs);
	println!("Part 1: {}", part1_solution.unwrap());
	
	// part 2
	let part2_solution = part2(&xs);
	println!("Part 2: {}", part2_solution.unwrap());
}

fn parse_input(input_file: &str) -> Vec<i64> {
	let input = std::fs::read_to_string(input_file)
		.unwrap();
	let xs = input
		.split('\n') // split by new line
		.filter(|s| !s.is_empty()) // filter empty lines (i.e., last line
		.map(|x| x.parse::<i64>().unwrap()) // parse as integers
		.collect::<Vec<_>>(); // collect into a vector
	
	return xs;
}

fn part1(xs: &Vec<i64>) -> Option<i64> {
	let n = xs.len();

	// O(N^2) for part 1, and O(N^3) for part 2
	for i in 0..n - 1 {
		for j in i + 1..n - 1 {
			if xs[i] + xs[j] == 2020 {
				return Some(xs[i] * xs[j]);
			}
		}
	}
	
	return None;
	
	// O(NlogN) for part 1, and O(N^2logN) for part 2 // sort + binary search
	/*
	xs.sort();
	for i in 0..n {
		if let Ok(j) = xs.binary_search(&(2020 - xs[i])) {
			if i != j {
				return Some("{}", xs[i] * xs[j]);
			}
		}
	}
	
	return None;
	*/
}

fn part2(xs: &Vec<i64>) -> Option<i64> {
	let n = xs.len();
	
	for i in 0..n - 2 {
		for j in 1 + 1..n - 1 {
			for k in j + 1..n {
				if xs[i] + xs[j] + xs[k] == 2020 {
					return Some(xs[i] * xs[j] * xs[k])
				}
			}
		}
	}
	
	return None;
	
	// O(NlogN) for part 1, and O(N^2logN) for part 2 // sort + binary search
	/*
	for i in 0..n - 1 {
		for j in i+1..n {
			if let Ok(k) = xs.binary_search(&(2020 - xs[i] - xs[j])) {
				if j != k {
					return Some("{}", xs[i] * xs[j] * xs[k]);
				}
			}
		}
	}
	
	return None;
	*/
}

