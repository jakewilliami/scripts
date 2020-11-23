use std::{fs, env, process, path};
use dirs;

//   -g | --general		Chooses the general template.
// 	 -c | --class		Chooses the general template via the class.
// 	 -C | --classBib	[DEPRECATED] Chooses the general template via the citations class.
// 	 -f | --figure		Chooses the figure template.
// 	 -l | --letter		Chooses the class for Teagoslavic letter template.
// 	 -b | --beamer		Chooses the beamer (slide-show) template.
// 	 -B | --bib		    Creates a Bibliography file named `references.bib` in a given directory.
// 	 -p | --poi		    Chooses the Persons of Interest template.
// 	 -h | --help		Shows help (present output).
// 	 -h | --help		Shows help (present output)

fn main() {
    // define colours
    let bold_white = "\x1b[1;38m";
    let bold_red = "\x1b[1;31m";
    let reset = "\x1b[0;38m";
    
    // construct an array of command line arguments
    let args: Vec<String> = env::args().collect();
    // ensure correct number of arguments
    if args.len() != 4 {
        eprintln!("{}error{}{}: this programme takes in three command line arguments.  See mktex -h for help.{}", bold_red, reset, bold_white, reset);
        process::exit(1);
    }
    
    // declare directories
    let home_dir = dirs::home_dir().ok_or_else(|| anyhow!("Could not get home dir"))?;
    let bash_dir = path::Path::new(&format!("{}/projects/scripts/bash/", dirs::home_dir().unwrap().into_os_string().into_string().unwrap()).to_string());
    let templates_dir = path::Path::new(&format!("{}/projects/tex-macros/templates/", dirs::home_dir().unwrap().into_os_string().into_string().unwrap()).to_string());
    let beamer_dir = path::Path::new(&format!("{}/beamer/", templates_dir.display()).to_string());
    // let class_dir = path::Path::new(&format!("{}/../general_macros/class/", templates_dir.parent().unwrap().into_os_string().into_string().unwrap()).to_string());
    
    // convert flag argument from String to &str.  It needs to be String to collect initially
    let flag: &str = &String::from(args[1].to_string());
    let template: &str = match flag {
        "-g" | "--general"  => "general",
        "-c" | "--class"    => "class",
        "-f" | "--figure"   => "figure",
        "-l" | "--letter"   => "letter",
        "-b" | "--beamer"   => "beamer",
        "-B" | "--bib"      => "bib",
        "-p" | "--poi"      => "poi",
        "-h" | "--help"     => "help",
        _ => {
            eprintln!("{}error{}{}: problem parsing arguments{}", bold_red, reset, bold_white, reset);
            process::exit(1);
        }
    };
    
    println!("{}", template);
}

// fn build_template() {
//
// }
