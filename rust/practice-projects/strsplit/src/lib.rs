//!
#![warn(missing_debug_implementations, rust_2018_idioms, missing_docs)]

pub struct StrSplit<'a> {
	remainder: &'a str,
	delimiter: &'a str,
}

// <'_> is anonymous lifetime
impl StrSplit<'_> {
	pub fn new(haystack: &str, delimiter: &str) -> Self {
		Self {
			remainder: haystack,
			delimiter, // equiv to `delimiter: delimiter`
		}
	}
}

impl Iterator for StrSplit<'_> {
	type Item = &str;
	fn next(&mut self) -> Option<Self::Item> {
		if let Some(next_delim) = self.remainder.find(self.delimiter) {
			let until_delimiter = &self.remainder[..next_delim];
			self.remainder = &self.remainder[next_delim + self.delimiter.len()..];
			Some(until_delimiter)
		} else if self.remainder.is_empty() {
			// TODO: bug
			None
		} else {
			let rest = self.remainder;
			self.remainder = &[];
			Some(rest)
		}
	}
}

#[test]
fn it_works() {
	let haystack = "a b c d e";
	let letters = StrSplit::new(haystack, " "); //.collect()
	assert_eq!(letters, vec!["a", "b", "c", "d", "e"].into_iter()); // you can compare iterators so long as they have the same type
}
