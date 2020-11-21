use json;

fn get_languages() {
	let parsed = json::parse("/Users/jakeireland/projects/scripts/bash/colours/textcolours.json");
	return parsed;
}

fn main() {
    println!("Hello, world!");
	let parsed = get_languages();
	println!("{:x?}", parsed);
}
