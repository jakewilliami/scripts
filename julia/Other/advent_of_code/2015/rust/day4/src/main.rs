extern crate crypto;

use crypto::md5::Md5;
use crypto::digest::Digest;

fn main() {
	// parse input
	let key = std::fs::read_to_string("data4.txt")
                .unwrap().trim().to_string();
	
	// part 1
	assert_eq!(part1(&"abcdef".to_string()).unwrap(), 609043);
	assert_eq!(part1(&"pqrstuv".to_string()).unwrap(), 1048970);
	let part1_solution = part1(&key).unwrap();
	println!("Part 1: {}", part1_solution);
	
	// part 2
	let part2_solution = part2(&key).unwrap();
	println!("Part 2: {}", part2_solution);
}

fn part1(key: &String) -> Option<isize> {
	let mut hasher = Md5::new();
	
	for i in 1..std::isize::MAX {
		hasher.input(key.as_bytes());
        hasher.input(i.to_string().as_bytes());
		
		let mut output = [0; 16]; // An MD5 is 16 bytes
        hasher.result(&mut output);
		
		// in hex representation, every byte is displayed as two characters
		// hence, the first 5 characters of the hex representation being zero
		// implies that the first 2 bytes (i.e., 4 characters) are zero, and 
		// bit-shifting the last value by 4 will split the last byte "in half",
		// as it were, hence obtaining the first digit of the hex representation
		// of the byte
		let first_five = output[0] as i32 + output[1] as i32 + (output[2] >> 4) as i32;
        if first_five == 0 {
			return Some(i);
        }
        hasher.reset();
	}
	
	return None
}

fn part2(key: &String) -> Option<isize> {
	let mut hasher = Md5::new();
	
	for i in 1..std::isize::MAX {
		hasher.input(key.as_bytes());
        hasher.input(i.to_string().as_bytes());
		
		let mut output = [0; 16]; // An MD5 is 16 bytes
        hasher.result(&mut output);
		
		// as 6 digits in hex are a multiple of 2, this is easy; just get 
		// the first 3 bytes and make sure they're zero
		let first_five = output[0] as i32 + output[1] as i32 + output[2] as i32;
        if first_five == 0 {
			return Some(i);
        }
        hasher.reset();
	}
	
	return None
}
