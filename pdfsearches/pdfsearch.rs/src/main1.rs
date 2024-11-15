// run using
// cargo install cargo-edit && \
// cargo add lopdf pdf-extract
// cd /Users/jakeireland/scripts/pdfsearches/pdfsearch.rs/src/ && \
// [sudo] cargo run main.rs

extern crate pdf_extract;
// extern crate lopdf;

// use std::env;
// use std::path::PathBuf;
// use std::path;
// use std::io::BufWriter;
// use std::fs::File;
// use pdf_extract::*;
// use lopdf::*;

// fn getPDFText() {
//     //let output_kind = "html";
//     //let output_kind = "txt";
//     //let output_kind = "svg";
//     let file = env::args().nth(1).unwrap();
//     let output_kind = env::args().nth(2).unwrap_or_else(|| "txt".to_owned());
//     println!("{}", file);
//     let path = path::Path::new(&file);
//     let filename = path.file_name().expect("expected a filename");
//     let mut output_file = PathBuf::new();
//     output_file.push(filename);
//     output_file.set_extension(&output_kind);
//     let mut output_file = BufWriter::new(File::create(output_file).expect("could not create output"));
//     let doc = Document::load(path).unwrap();
//
//     print_metadata(&doc);
//
//     let mut output: Box<dyn OutputDev> = match output_kind.as_ref() {
//         "txt" => Box::new(PlainTextOutput::new(&mut output_file as &mut dyn std::io::Write)),
//         "html" => Box::new(HTMLOutput::new(&mut output_file)),
//         "svg" => Box::new(SVGOutput::new(&mut output_file)),
//         _ => panic!(),
//     };
//
//     output_doc(&doc, output.as_mut());
// }
 

// https://github.com/jrmuizel/pdf-extract/blob/master/examples/extract.rs
fn main() {
    // println!("Hello, world!");
    let text = pdf_extract::extract_text("/Users/jakeireland/Desktop/sensors-17-02741.pdf");
    println!("{}", text);
}

// match thingy() {
//     Ok(_x) => { panic!("Things are not supposed to work right!"); }
//     Err(_err) => {} // TODO
// }
