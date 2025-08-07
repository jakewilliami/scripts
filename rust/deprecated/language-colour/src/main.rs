use std::fs::File;
use std::io::prelude::*;
use curl::easy::Easy;
// use std::collections::BTreeMap;
use serde_yaml; // 0.8.7

// curl https://raw.githubusercontent.com/github/linguist/master/lib/linguist/languages.yml > languages.yml; julia -E 'import Pkg; Pkg.add.(["YAML", "OrderedCollections", "Colors"]); using YAML; include("$(homedir())/projects/scripts/python/rgb2iterm256.jl"); f = YAML.load_file("languages.yml"); for k in keys(f); col = get(f[k], "color", ""); if !isempty(col); print(k, ":\t\t"); main(col); end; end'; rm languages.yml

static DATAFILE: &str = "/tmp/languages.yml";

fn main() {
	get_datafile();
}

// fn get_datafile() -> std::io::Result<String> {
fn get_datafile() {
    // First write everything into a `Vec<u8>`
    let mut data = Vec::new();
    let mut handle = Easy::new();
    handle.url("https://raw.githubusercontent.com/github/linguist/master/lib/linguist/languages.yml").unwrap();
    {
        let mut transfer = handle.transfer();
        transfer.write_function(|new_data| {
            data.extend_from_slice(new_data);
            Ok(new_data.len())
        }).unwrap();
        transfer.perform().unwrap();
    }

    // Convert it to `String`
    let datastr = String::from_utf8(data)
		.expect("body is not valid UTF8!");
	let mut file = File::create(DATAFILE);
	// file.write_all(&data);
	println!("{:?}", file);

    // let f = std::fs::File::open(DATAFILE);
	// let d: serde_yaml::Value = serde_yaml::from_reader(f);
	// let d = d["foo"]["bar"]
	// 	.as_str()
	// 	.map(|s| s.to_string());
	// 	// .or_ok(anyhow!("Count not find key foo.bar in the language file"))
    // println!("Read YAML string: {:?}", d);

	// return Ok(());
}

// Current progress: debugging, trying to get the downloaded file (or Vec<u8>) to be parsed as a yml file
