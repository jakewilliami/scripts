use std::fs::File;
use std::io::{prelude::*, BufReader};
use std::collections::HashMap;

const VOWELS: [char; 5] = ['a', 'e', 'i', 'o', 'u'];
const BAD_PAIRS: [&str; 4] = ["ab", "cd", "pq", "xy"];

fn main() {
	// parse input
	let file = File::open("data5.txt").expect("no such file");
	let buf = BufReader::new(file);
	let lines: Vec<_> = buf.lines()//.collect();
                    .map(|l| l.unwrap())
                    .collect();
	
	// part 1
	assert!(NiceString{s: "aei".to_string()}.has_three_vowels());
	assert!(NiceString{s: "xazegov".to_string()}.has_three_vowels());
	assert!(NiceString{s: "aeiouaeiouaeiou".to_string()}.has_three_vowels());
	assert!(NiceString{s: "xx".to_string()}.has_double_letter());
	assert!(NiceString{s: "abcdde".to_string()}.has_double_letter());
	assert!(NiceString{s: "aabbccdd".to_string()}.has_double_letter());
	assert!(NiceString{s: "ugknbfddgicrmopn".to_string()}.is_nice());
	assert!(NiceString{s: "aaa".to_string()}.is_nice());
	assert!(NiceString{s: "jchzalrnumimnmhp".to_string()}.is_naughty());
	assert!(!NiceString{s: "jchzalrnumimnmhp".to_string()}.has_double_letter());
	assert!(NiceString{s: "haegwjzuvuyypxyu".to_string()}.is_naughty());
	assert!(!NiceString{s: "haegwjzuvuyypxyu".to_string()}.contains_no_bad_pairs());
	assert!(NiceString{s: "dvszwmarrgswjxmb".to_string()}.is_naughty());
	assert!(!NiceString{s: "dvszwmarrgswjxmb".to_string()}.has_three_vowels());
	let strs: Vec<NiceString> = lines.iter().map(|s| NiceString{s: s.to_string()}).collect();
	let part1_solution = part1(&strs);
	println!("Part 1: {}", part1_solution);
	
	// part 2
	assert!(ReallyNiceString{s: "xyxy".to_string()}.has_two_nice_pairs());
	assert!(ReallyNiceString{s: "aabcdefgaa".to_string()}.has_two_nice_pairs());
	assert!(!ReallyNiceString{s: "aaa".to_string()}.has_two_nice_pairs());
	assert!(ReallyNiceString{s: "xyx".to_string()}.has_one_repeating_letter());
	assert!(ReallyNiceString{s: "abcdefeghi".to_string()}.has_one_repeating_letter());
	assert!(ReallyNiceString{s: "aaa".to_string()}.has_one_repeating_letter());
	assert!(ReallyNiceString{s: "qjhvhtzxzqqjkmpb".to_string()}.is_nice());
	assert!(ReallyNiceString{s: "xxyxx".to_string()}.is_nice());
	assert!(ReallyNiceString{s: "uurcxstgmygtbstg".to_string()}.is_naughty());
	assert!(ReallyNiceString{s: "ieodomkazucvgmuy".to_string()}.is_naughty());
	let strs2: Vec<ReallyNiceString> = lines.iter().map(|s| ReallyNiceString{s: s.to_string()}).collect();
	let part2_solution = part2(&strs2);
	println!("Part 2: {}", part2_solution);
}

// Structs

struct NiceString {
	s: String,
}

// Part 1

trait IsNiceString {
	fn is_nice(&self) -> bool;
	fn is_naughty(&self) -> bool;
	fn has_three_vowels(&self) -> bool;
	fn has_double_letter(&self) -> bool;
	fn contains_no_bad_pairs(&self) -> bool;
}

impl IsNiceString for NiceString {
	fn is_nice(&self) -> bool {
		return self.has_three_vowels() && self.has_double_letter() && self.contains_no_bad_pairs();
	}
	
	fn is_naughty(&self) -> bool {
		return !self.is_nice();
	}
	
	fn has_three_vowels(&self) -> bool {
		let mut vowel_count = 0;
		for c in self.s.chars() {
			if VOWELS.contains(&c) {
				vowel_count += 1;
			}
			if vowel_count >= 3 {
				return true;
			}
		}
		return false;
	}
	
	fn has_double_letter(&self) -> bool {
		let str_len = self.s.len();
		let s: Vec<char> = self.s.chars().collect();
		for i in 0..(str_len - 1) {
			if s[i] == s[i + 1] {
				return true;
			}
		}
		return false;
	}
	
	fn contains_no_bad_pairs(&self) -> bool {
		let str_len = self.s.len();
		let s: Vec<char> = self.s.chars().collect();
		for p_str in BAD_PAIRS {
			let p: Vec<char> = p_str.chars().collect();
			for i in 0..(str_len - 1) {
				if s[i] == p[0] && s[i + 1] == p[1] {
					return false;
				}
			}
		}
		return true;
	}
}

fn part1(strs: &Vec<NiceString>) -> usize {
	let mut nice_str_count = 0 as usize;
	for s in strs {
		if s.is_nice() {
			nice_str_count += 1;
		}
	}
	return nice_str_count;
}

// Part 2

struct ReallyNiceString {
	s: String,
}

// Part 1

trait IsReallyNiceString {
	fn is_nice(&self) -> bool;
	fn is_naughty(&self) -> bool;
	fn has_two_nice_pairs(&self) -> bool;
	fn has_one_repeating_letter(&self) -> bool;
}

impl IsReallyNiceString for ReallyNiceString {
	fn is_nice(&self) -> bool {
		return self.has_two_nice_pairs() && self.has_one_repeating_letter();
	}
	
	fn is_naughty(&self) -> bool {
		return !self.is_nice();
	}
	
	fn has_two_nice_pairs(&self) -> bool {
		// let mut pair_map = HashMap::new();
		// let mut pair_list: Vec<(char, char)> = Vec::new();
		let mut pair_map = HashMap::new();
		let str_len = self.s.len();
		// TODO: check that the length of the string is at least 4
		let s: Vec<char> = self.s.chars().collect();
		let mut i: usize = 0;
		while i < (str_len - 1) {
			let p = (s[i], s[i + 1]);
			/*
			if let Some(x) = pair_map.get_mut(&p) {
				*x = pair_map.get(&p) + 1;
			} else {
				pair_map.insert(&p, 1);
			}
			*/
			/*
 		   	let pair_counter = pair_map.entry(p).or_insert(1);
		    *pair_counter += 1;
			if *pair_counter == 2 {
				return true
			}
			*/
			/*
			if pair_map.contains_key(&p) {} else {}
			*/
			/*
			if pair_list.contains(&p) {
				return true;
			} else {
				pair_list.push(p);
				i += 2;
			}
			*/
			/*
			let j = pair_map.get(&p); // returns an Option!
			if !j.is_none() {
				if j.unwrap() != &(i - 1) {
					return true; // xxyxx aaa
				}
			} else {
				pair_map.insert(p, i);
			}
			i += 1;
			*/
			if let Some(j) = pair_map.get(&p) {
				if *j != (i - 1) { // check for no overlap
					return true;
				}
			} else {
				pair_map.insert(p, i);
			}
			i += 1;
		}
		return false;
	}
	
	fn has_one_repeating_letter(&self) -> bool {
		let str_len = self.s.len();
		let s: Vec<char> = self.s.chars().collect();
		for i in 0..(str_len - 2) {
			if s[i] == s[i + 2] { // && s[i] != s[i + 1] {
				return true;
			}
		}
		return false;
	}
}

fn part2(strs: &Vec<ReallyNiceString>) -> usize {
	let mut really_nice_str_count = 0 as usize;
	for s in strs {
		if s.is_nice() {
			really_nice_str_count += 1;
		}
	}
	return really_nice_str_count;
}

