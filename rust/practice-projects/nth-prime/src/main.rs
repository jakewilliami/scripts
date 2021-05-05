// This is by no means a fancy seive version of getting the nth prime number.  However, it works as a practice project

use std::env;

fn main() {
	// iterate over arguments
    for (i, m) in env::args().enumerate() {
		if i != 0 { // if argument is not the binary call itself
			// repeat letters
			let m_isize: isize = m.parse().unwrap();
			let nth_prime_number: isize = nth_prime(m_isize);
			println!("{}", nth_prime_number);
		}
	}

	return;    
}

fn is_prime(m: isize) -> bool {
	let mut is_a_prime: bool = true;
	
	if m <= 1 {
		is_a_prime = false;
	}

	for i in 2..(m / 2) {
		if (m % i) == 0 {
			is_a_prime = false;
			break;
		}
	}

	return is_a_prime;
}

fn nth_prime(n: isize) -> isize {
	let mut prime: isize = 2;

	if (n + 1) == 1 { // index starts at 0 so plus 1
		return 2;
	}

	if (n + 1) > 1 {
		let mut m: isize = 3;
		
		while prime < n + 1 {
			m += 1;
			
			if is_prime(m) {
				prime += 1
			}
		}

		return m;
	} else {
		return prime + 1;
	}
}
