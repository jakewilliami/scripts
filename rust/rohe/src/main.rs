mod postcodes;
mod request;
mod response;

use postcodes::*;
use response::*;

extern crate clap;
use clap::{Arg, App};//, SubCommand};

// extern crate reqwest;
// use reqwest;

// #[async_std::main]
#[tokio::main]
async fn main() {
    // println!("Hello, world!");
    // println!("{}", request::into_URI(request::TOOLS0))
    // request::make_request().await;
    
    let matches = App::new("rohe")
                      .version("1.0")
                      .author("Jake W. Ireland. <jakewilliami@icloud.com>")
                      .about("A command line interface for NZP's locator API.  The name 'rohe' is the Māori word for 'areas'.")
							// .arg(Arg::with_name("help")
							// 	.short("h")
							// 	.long("help")
							// 	// .value_name("FILE")
							// 	.help("Shows help (present output).")
							// 	.takes_value(false)
							// 	.required(false)
							// 	.multiple(false)
						   	// )
							.arg(Arg::with_name("ADDR")
								.short("a")
								.long("address")
								// .index(1)
								.help("Takes address as input.  Default return value is the address' associated postcode.")
								.takes_value(true)
								.required(false)
								.multiple(false)
							)
							.arg(Arg::with_name("POSTCODE")
								.short("p")
								.long("postcode")
								// .value_name("FILE")
								.help("Takes postcode as input.  Default return value is the postcode's associated region.")
								.takes_value(true)
								.required(false)
								.multiple(false)
						   	)
							.arg(Arg::with_name("COORDS")
								.short("c")
								.long("coordinates")
								// .value_name("FILE")
								.help("Return addresses as (latitude, longitude).")
								.takes_value(true)
								.required(false)
								.multiple(false)
						   	)
							// .subcommand(SubCommand::with_name("test")
							// 			.about("controls testing features")
							// 			.version("1.3")
							// 			.author("Someone E. <someone_else@other.com>")
							// 			.arg_from_usage("-d, --debug 'Print debug information'"))
							.get_matches();
	
	// TODO:
	// ENSURE THAT OTHER ARGUMENTS CHECK FOR REQUIREMENTS
	// E.G., IF USING -C, CHECK THAT -A, NOT -P
	
	// if matches.is_present("LEVEL") {
	// 	// level =; matches.value_of("LEVEL").unwrap().parse().unwrap();
	// } else {
	// 	level = DEFAULT_DEPTH;
	// }
	
	// println!("{}", request::into_URI(request::TOOLS0))
	
	
	// URIs as strings
    // let mut address_uri: String = String::new();
    
    // postcode_uri.push_str("6021");
	
    // request::make_request(postcode_uri.as_str()).await;
	
	if matches.is_present("POSTCODE") {
		// get value of postcode
		let postcode = matches.value_of("POSTCODE").unwrap().parse_postcode();
		// println!("{:?}", postcode);
		// construct postcode uri
		// let mut postcode_uri: String = String::new();
		// postcode_uri.push_str(postcode);
		let resp: Option<Vec<EachPostcode>> = request::get_suggested_postcodes(postcode).await;
		println!("{:?}", resp);
		// println!("{}", postcode_uri);
		// request::make_request(postcode_uri.as_str()).await;
		// println!("{:}", resp[]);
	}
	
	// let client = reqwest::Client::new();
	// let res = client
	// 	.get("https://httpbin.org/get")
	// 	.send()
	// 	.await
	// 	.expect("Failed to make HTTP request");
	//
	// println!("Status: {}", res.status());
	// println!("Headers:\n{:#?}", res.headers());
	//
	// let body = res
	// 	.text()
	// 	.await
	// 	.expect("Failed to retrieve body of response");
	//
	// println!("Body:\n{}", body);
	//
	// Ok(())
}
