fn main() {
	// read lines from input and parse as numbers
	let file_path = "../inputs/data10.txt";
	let xs = {
		let mut xs = std::fs::read_to_string(file_path)
			.expect(&format!("Could not read file `{}`", file_path))
			.lines()
			.map(|line| line.parse::<i64>().expect(&format!("`{}` is not a number!", line)))
			.collect::<Vec<_>>();
		xs.sort();
		// Insert 0 (the implicit joltage of the wall adapter) at first index)
		xs.insert(0, 0);
		// Insert the last element + 3 for the highest joltage
		xs.push(xs.last().expect("100% Rust bug not mine") + 3); // we added an element already
		xs
	};
	
	// Dynamic programming table
	// dp[i] is the amount of possible adaptors at the ith adaptor
	// Usually this depends on the previous amount of adaptors, e.g.
	// dp[i] = dp[i - 1] + dp[i - 2] + ...
	// Our final solution has to be dp.last()
	let mut dp = Vec::<i64>::new();
	// We need to fill in our DP table from left to right
	// if you have no adaptors there is only one way to build that chain, so dp[0] = 1
	dp.push(1);
	// iterate over the remaining indices (the first is already dones, so start from one
	for i in 1..xs.len() {
		// initialise the slot in the vector
		dp.push(0);
		// Start iterating backwards until we can connect to a previous adaptor (i.e., (i - 1):0)
		// println!("Iterating j in {:?}", (0..i).rev());
		for j in (0..i).rev() {
			assert!(xs[i] > xs[j]);
			// then the jth block is not connectable anymore
			if (xs[i] - xs[j]) > 3 {
				break;
			}
			// Otherwise keep adding the previous combinations to the current solution
			// println!("Adding {} to index {}", dp[j], i);
			// println!("{:?}", dp);
			dp[i] += dp[j];
		}
	}
	
	println!("{:?}", dp.last().expect("100% Rust bug not mine again")); // Even if input is empty should have 0 and 3 in dp
}
