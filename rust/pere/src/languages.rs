// extern crate serde_yaml;
use serde_yaml;
// use std::collections::BTreeMap;
// use std::collections::HashMap;

// static BASE_DIR: &str = "/Users/jakeireland/projects/";
// static LANGUAGE_FILE: &str = "/Users/jakeireland/projects/scripts/rust/pere/src/languages.yml";

// fn print_type_of<T>(_: &T) {
//     println!("{}", std::any::type_name::<T>())
// }

pub fn parse_languages(datafile: &str) -> serde_yaml::Mapping {
	// HashMap<String, String>
    // First write everything into a `Vec<u8>`
    // let mut data = Vec::new();
    // let mut handle = Easy::new();
    // handle.url("https://raw.githubusercontent.com/github/linguist/master/lib/linguist/languages.yml").unwrap();
    // {
    //     let mut transfer = handle.transfer();
    //     transfer.write_function(|new_data| {
    //         data.extend_from_slice(new_data);
    //         Ok(new_data.len())
    //     }).unwrap();
    //     transfer.perform().unwrap();
    // }

    // Convert it to `String`
    // let datastr = String::from_utf8(data)
	// 	.expect("body is not valid UTF8!");
	// let mut file = File::create(DATAFILE);
	// // file.write_all(&data);
	// println!("{:?}", file);

    // let f = std::fs::File::open(DATAFILE);
	// let d: serde_yaml::Value = serde_yaml::from_reader(f);
	// let d = d["foo"]["bar"]
	// 	.as_str()
	// 	.map(|s| s.to_string());
	// 	// .or_ok(anyhow!("Count not find key foo.bar in the language file"))
    // println!("Read YAML string: {:?}", d);
	
	// let mut map = BTreeMap::new();
	
	// let f = std::fs::File::open(datafile)?;
    // let d: String = serde_yaml::from_reader(f)?;
    // println!("Read YAML string: {}", d);
    // return Ok(())
	
	let f = std::fs::File::open(datafile).unwrap();
	// let data: HashMap<String, String> = serde_yaml::from_reader(f).unwrap();
	let data: serde_yaml::Mapping = serde_yaml::from_reader(f).unwrap();
	
    // data["4D"]["extensions"]
    //     .as_str()
    //     .map(|s| s.to_string())
    //     .ok_or(anyhow!("Could not find key 4D.extensions in languages.yml"))
	// println!("{:?}", data)
	// print_type_of(&data);
	
	return data;
	
	// return ;

	// return Ok(());
}
