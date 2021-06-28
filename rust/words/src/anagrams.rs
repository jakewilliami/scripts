use unicode_segmentation::UnicodeSegmentation;
use std::collections::HashMap;

// function to remove space characters from a string
fn skipblanks(s: String) -> String {
    return s.replace(" ", "");
}

// this function takes in two strings and returns a boolean value
// of whether or not these strings are anagrams of each other
pub fn areanagrams(s1: String, s2: String) -> bool {
    // we don't care about spaces in our anagrams
    let s1: String = skipblanks(s1);
    let s2: String = skipblanks(s2);
    
    // immediately return false if our strings are not
    // the same length
    if s1.len() != s2.len() {
        return false;
    }
    
    // Here we use .graphemes(true) as an alternative to .chars(),
    // provided to us bu the unicode_segmentation package,
    // in order to handle unicode strings properly
    let mut s2_arr: Vec<_> = s2.graphemes(true).collect();
    
    // iterate over characters of string 1
    for c1 in s1.graphemes(true) {
        // find the position of the first element in the string 2
        // array that is exactly c1
        let i_option: Option<_> = s2_arr.iter().position(|&c2| c2 == c1);
        
        if i_option.is_some() {
            // if there is some result from the above process, unwrap
            // the result as an index
            let i: usize = i_option.unwrap();
            // remove the character from the string2 array at
            // the specified index
            s2_arr.remove(i);
        }
    }
        
    // if the string 2 array is empty at the end of this process,
    // s1 is an anagram of s2 (and vice versa)
    return s2_arr.is_empty();
}

// given two strings, if they are anagrams, creates a hashmap of (character, index1) -> index2
pub fn get_anagram_map(s1: String, s2: String) -> Option<HashMap<(char, usize), usize>> {
    if !areanagrams(s1, s2) {
        let err_str = format!("{} is not an anagram of {}, so we cannot perform this function", s1, s2);
        // panic!(err_str);
        return None;
    }
    
    let mut map = HashMap::<(char, usize), usize>::new();
    
    return map;
}

// fn find_value(map: &HashMap<Vec<String>, String>, value: String) -> Option<&str> {
//     map.iter().find_map(|(key, val)| {
//         if key.contains(&value) {
//             Some(val.as_str())
//         } else {
//             None
//         }
//     })
// }
// construct hashmap
// let mut map = HashMap::<Vec<String>, String>::new();
// for i in v {
//     let s: Vec<&str> = i.split('\t').collect::<Vec<&str>>();
//     // println!{"{:?}", s};
//     // let tempj = s[0];
//     let j: Vec<String> = s[0]
//         .replace(&['{', '}'][..], "") // replace multiple at once; https://users.rust-lang.org/t/24554/2
//         .split(", ")
//         .map(str::to_owned)
//         .collect::<Vec<String>>();
//     let k = s[1];
//     map.insert(j, k.to_owned());
// }
