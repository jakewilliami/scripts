use std::env;
use std::path::PathBuf;

use pdf::error::PdfError;
// use pdf::file::
use pdf_extract;

/*fn main() -> Result<(), PdfError> {
    let path = PathBuf::from(env::args_os().nth(1).expect("no file given"));

    // let file = File::<Vec<u8>>::open(&path)?;

    let file = FileOptions::cached().open(&path)?;

    for page in file.pages() {
        let page = page.unwrap();
        println!("{:?}", page);
        // if let Some(c) = &page.contents {
            // println!("{:?}", c);
        // }
    }

    Ok(())
}
*/

fn main() {
    let path = PathBuf::from(env::args_os().nth(1).expect("no file given"));
    let out = pdf_extract::extract_text(path).unwrap();
    // println!("{:?}", out);
}
