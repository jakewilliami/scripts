use std::env;

fn main() {
	// iterate over arguments	
    for (i, s) in env::args().enumerate() {
		if i != 0 { // if argument is not the binary call itself
			// repeat letters
			let out_str: String = repeat_letters(s);
			println!("{}", out_str);
		}
	}
	
	return;
}

fn repeat_letters(in_str: String) -> String {
	let mut out_str = "".to_string();
	
	// iterate over characters of the input string
	for c in in_str.chars() {
		// repeat the letters twice
		// let repeated_c = format!("{:-^1$}", c, 2);
		let repeated_c = c.to_string().repeat(2);
		// and add it to the output string
		out_str.push_str(&repeated_c.as_str())
	}

	return out_str;
}
