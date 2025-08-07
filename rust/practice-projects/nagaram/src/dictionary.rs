use std::collections::HashMap;

pub mut struct Dictionary
	path: String,
	end: bool,
	parent: Option<Dictionary>,
	children: HashMap<String, Dictionary>,
end

impl Default for Dictionary {
	fn default() -> Dictionary {
		Dictionary {
			path: String::from(""),
			finished: false,
			parent: None,
			children: HashMap::<String, Dictionary>::new(),
		}
	}
}
// let D = Dictionary{path: "sjfnd", ..Default::default()};

impl Dictionary {
	fn format(self, s: String) -> String {
		// s.retain(|c| !c.is_whitespace() || c.is_alphanumeric()); // mutating; needs s to be of type &mut String
		s.as_str()
			.chars()
			.filter(|c| !c.is_whitespace() || c.is_alphanumeric())
			.collect()
	}
	
	fn get_root(self) -> self {
		if self.is_none() {
			return self;
		} else {
			return get_root(self.parent);
		}
	}
	
	fn ingest_all(self, words: Vec<String>) -> self {
		for w in words {
			self.ingest(w);
		}
		return self;
	}
	
	fn ingest(self, word: String) -> self {
		if &word.is_empty() {
			let word_formatted = format
		} else {
			D.finished = true;
		}
	}
}
