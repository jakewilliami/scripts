use std::fs;
use json;

// fn get_languages() -> Result<()> {
	// let parsed = json::parse("/Users/jakeireland/projects/scripts/bash/colours/textcolours.json");
	// return parsed;
// }

fn main() {
	let parsed = 
		json::parse(&fs::read_to_string("/Users/jakeireland/projects/scripts/bash/colours/textcolours.json").unwrap());
	// let parsed = get_languages();
	let green_val = &parsed.unwrap()["BGREEN"].to_string();
	println!("{:?}", green_val);
}
