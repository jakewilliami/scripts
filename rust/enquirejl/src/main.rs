extern crate clap;
use clap::{Arg, App};//, SubCommand};

fn main() {
    let matches = App::new("enquirejl")
                      .version("1.0")
                      .author("Jake W. Ireland. <jakewilliami@icloud.com>")
                      .about("A simple CL utility to help look at Julia's source code.")
							// .arg(Arg::with_name("help")
							// 	.short("h")
							// 	.long("help")
							// 	// .value_name("FILE")
							// 	.help("Shows help (present output).")
							// 	.takes_value(false)
							// 	.required(false)
							// 	.multiple(false)
						   	// )
							.arg(Arg::with_name("INPUT")
								// TODO: as well as -n we should also be able to do -10, -100, -3, etc
								// .short("n")
								// .long("number")
								// .value_name("FILE")
								.help("Given an input, will go to the corresponding line of code in JuliaLang's GitHub repository.  Typically the input of this will be the output of the Julia command @which.  For example, I run

								julia> @which length([1, 2, 3])
								length(a::Array) in Base at array.jl:197

								So I give this binary the output:

								$ enquirejl array.jl:197
								https://github.com/JuliaLang/julia/blob/master/base/array.jl#L197")
								// .index(1)
								// .default_value("10")
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
	
	// if matches.is_present("LEVEL") {
	// 	// level =; matches.value_of("LEVEL").unwrap().parse().unwrap();
	// } else {
	// 	level = DEFAULT_DEPTH;
	// }
	
	if matches.is_present("INPUT") {
		let input = matches.value_of("INPUT").unwrap();
		let url = parse_input(input);
		println!("{}", url);
	}
}

fn parse_input(input: &str) -> String {
	let i = input.find(':');
	if i.is_none() {
		panic!("Malformed input: no colon given.  Input should be of the form filename.jl:linenumber")
	}
	let i = i.unwrap();
	// let (filename, linenumber) = i.map(|i| (&input[0..i], &input[(i + 1)..]));
	let filename = &input[0..i];
	let linenumber = &input[(i + 1)..];
	
	let mut out = String::new();
	out.push_str("https://github.com/JuliaLang/julia/blob/master/base/");
	out.push_str(filename);
	out.push_str("#L");
	out.push_str(linenumber);
	
	return out;
}



/*
julia> R = ccall(:jl_gf_invoke_lookup_worlds, Any,
               (Any, UInt, Ptr{Csize_t}, Ptr{Csize_t}),
               Tuple{typeof(length), Array},
			   ccall(:jl_get_world_counter, UInt, ()),
			   Base.RefValue{UInt}(typemin(UInt)),
			   Base.RefValue{UInt}(typemax(UInt)))
length(a::Array) in Base at array.jl:197

julia> R.module
Base

julia> R.file
Symbol("array.jl")

julia> R.line
197
*/
