mod acronyms;
mod acrostics;
mod anagrams;
mod forkerisms;
mod kniferisms;
mod palindromes;
mod senryus;
mod sonnets;
mod spoonerisms;

use std::{
    fs::File,
    io::{
        prelude::*,
        BufReader,
    },
    path::Path,
};

static WORDLIST_PATH: &str = "/Users/jakeireland/projects/scripts/rust/words/src/wordlist.txt";
static LONGEST_PALINDROME: &str = "tattarrattat";

fn main() {
    println!("{:?}", anagrams::get_anagram_map("a   nna".to_string(), "nana".to_string()));
    // println!("{:?}", read_wordlist(WORDLIST_PATH));
}

fn read_wordlist(filename: impl AsRef<Path>) -> Vec<String> {
    let file = File::open(filename).expect("No such file");
    let buf = BufReader::new(file);
    let readlines: Vec<String> = buf.lines()
        .map(|l| l.expect("Could not parse line"))
        .collect();
    
    return readlines;
}
