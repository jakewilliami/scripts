fn main() {
	let input = std::fs::read_to_string("inputs/1.input")
		.unwrap();
	let mut xs = input
		.split('\n') // split by new line
		.filter(|s| !s.is_empty()) // filter empty lines (i.e., last line
		.map(|x| x.parse::<i32>().unwrap()) // parse as integers
		.collect::<Vec<_>>(); // collect into a vector
	let n = xs.len();

	// O(N^2) for part 1, and O(N^3) for part 2
	/*	
	for i in 0..n - 1 {
		for j in i + 1..n - 1 {
			if xs[i] + xs[j] == 2020 {
				println!("{}", xs[i] * xs[j]);
				return;
			}
		}
	}
	
	for i in 0..n - 2 {
		for j in 1 + 1..n - 1 {
			for k in j + 1..n {
				if xs[i] + xs[j] + xs[k] == 2020 {
					println!("{}", xs[i] * xs[j] * xs[k]);
					return;
				}
			}
		}
	}
	*/

	// O(NlogN) for part 1, and O(N^2logN) for part 2 // sort + binary search
	/*
	xs.sort();
	for i in 0..n {
		if let Ok(j) = xs.binary_search(&(2020 - xs[i])) {
			if i != j {
				println!("{}", xs[i] * xs[j]);
				return;
			}
		}
	}

	for i in 0..n - 1 {
		for j in i+1..n {
			if let Ok(k) = xs.binary_search(&(2020 - xs[i] - xs[j])) {
				if j != k {
					println!{"{}", xs[i] * xs[j] * xs[k]};
					return;
				}
			}
		}
	}
	*/
	
	return;
}
