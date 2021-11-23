extern crate crypto;

use crypto::md5::Md5;
use crypto::digest::Digest;

fn main() {
	// parse input
	let key = std::fs::read_to_string("data4.txt")
                .unwrap();
	
	// part 1
	println!("{:?}", hash);
	// assert_eq!(part1(&"abcdef".to_string()), 609043);
	// assert_eq!(part1(&"pqrstuv".to_string()), 1048970);
	// let part1_solution = part1(&key);
	// println!("Part 1: {}", part1_solution);
	
	// part 2
	// let part2_solution = part2(&instructions);
	// println!("Part 2: {}", part2_solution);
}

fn part1(key: &String) {
	let mut hasher = Md5::new();
	
	for i in 1..std::isize::MAX {
		hasher.input(key);
        hasher.input(i.to_string().as_bytes());
		
		let mut output = [0; 16]; // An MD5 is 16 bytes
        hasher.result(&mut output);
		
		let first_five = output[0] as i32 + output[1] as i32 + (output[2] >> 4) as i32;
        if first_five == 0 {
            println!("{}", i);
            break;
        }
        hasher.reset();
	}
}
