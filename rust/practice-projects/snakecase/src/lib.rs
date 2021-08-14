extern crate unicode_segmentation;

// No need for main method; as it is a library, we only case about tests

use unicode_segmentation::UnicodeSegmentation;

pub trait SnakeCase {
	fn to_snake_case(&self) -> String;
	fn is_snake_case(&self) -> bool;
}

impl SnakeCase for String {
	fn to_snake_case(&self) -> String {
		let mut snake_case_string = String::new();
		for (i, c) in self.graphemes(true).enumerate() {
			if c == c.to_ascii_uppercase() {
				if i != 0 {
					snake_case_string.push_str("_");
				}
				snake_case_string.push_str(&c.to_lowercase());
			} else {
				snake_case_string.push_str(&c);
			}
		}
		return snake_case_string;
	}
	
	fn is_snake_case(&self) -> bool {
		let first_char = &self
			.graphemes(true)
			.next()
			.unwrap();
		let last_char = &self
			.graphemes(true)
			.next_back()
			.unwrap();
		if first_char != &"_" &&
			last_char != &"_" &&
			&self == &&self.to_ascii_lowercase()
		{
			return true
		} else {
			return false;
		}
	}
}

impl SnakeCase for &str {
	fn to_snake_case(&self) -> String {
		return self.to_string().to_snake_case();
	}
	fn is_snake_case(&self) -> bool {
		return self.to_string().is_snake_case();
	}
}

#[test]
fn it_works() {
	// to_snake_case()
    assert_eq!("SnakeCase".to_snake_case(), "snake_case".to_string());
	assert_eq!(String::from("SnakeCase").to_snake_case(), "snake_case".to_string());
	assert_eq!("ReallyLongSnakeCaseString".to_snake_case(), "really_long_snake_case_string".to_string());
	// is_snake_case()
	assert_eq!("_is_snake_case".to_string().is_snake_case(), false);
	assert_eq!("is_snake_case".to_string().is_snake_case(), true);
	assert_eq!("This_Is_Snake_Case".is_snake_case(), false);
	assert_eq!("this_is_snake_case".is_snake_case(), true);
	assert_eq!("thisistechnicallysnakecasebecauseimnotgoingtocheckwordsagainstsomewordlist".is_snake_case(), true);
	assert_eq!("this_is_a_really_long_snake_case_string".is_snake_case(), true);
	assert_eq!("is_snake_case_".to_string().is_snake_case(), false);
}
