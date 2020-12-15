use aoc_runner_derive::{aoc, aoc_generator};

pub struct Password {
    num1: u32,
    num2: u32,
    letter: char,
    password: String,
}

#[aoc_generator(day2, part1, with_generator)]
#[aoc_generator(day2, part2, with_generator)]
pub fn input_generator(input: &str) -> Vec<Password> {
    input
        .lines()
        .map(|line| {
            let v: Vec<&str> = line.split(" ").collect();
            let bounds: Vec<&str> = v[0].split("-").collect();
            Password{
                num1: bounds[0].parse().unwrap(),
                num2: bounds[1].parse().unwrap(),
                letter: v[1].chars().next().unwrap(),
                password: String::from(v[2])
            }
        })
        .collect()
}

#[aoc(day2, part1, with_generator)]
pub fn solve_part1(passwords: &[Password]) -> u32 {
    passwords
        .iter()
        .fold(0, |count, entry| {
            let letter_count = entry.password.matches(entry.letter).count() as u32;
            count + if letter_count >= entry.num1 && letter_count <= entry.num2 {
                1
            } else {
                0
            }
        })
}

#[aoc(day2, part2, with_generator)]
pub fn solve_part2(passwords: &[Password]) -> u32 {
    passwords
        .iter()
        .fold(0, |count, entry| {
            let bytes = entry.password.as_bytes();
            count + if (bytes[entry.num1 as usize - 1] as char == entry.letter) ^
                       (bytes[entry.num2 as usize - 1] as char == entry.letter) {
                1
            } else {
                0
            }
        })
}

// #[aoc(day2, part1, no_generator)]
// pub fn solve_part1_no_generator(input: &str) -> u32 {
//     input
//         .lines()
//         .fold(0, |count, line| {
//             // let v: Vec<&str> = line.split(" ").collect();
//             // let bounds: Vec<&str> = v[0].split("-").collect();
//             // let min = bounds[0].parse().unwrap();
//             // let max = bounds[1].parse().unwrap();
//             // let letter = v[1].chars().next().unwrap();
//             // let password = String::from(v[2]);
//             let mut v = line.split(" ");
//             let mut bounds = v.next().unwrap().split("-");
//             let min = bounds.next().unwrap().parse().unwrap();
//             let max = bounds.next().unwrap().parse().unwrap();
//             let letter = v.next().unwrap().chars().next().unwrap();
//             let password = String::from(v.next().unwrap());
//             let letter_count = password.matches(letter).count() as u32;
//             count + if letter_count >= min && letter_count <= max {
//                 1
//             } else {
//                 0
//             }
//         })
// }
//
// #[aoc(day2, part2, no_generator)]
// pub fn solve_part2_no_generator(input: &str) -> u32 {
//     input
//         .lines()
//         .fold(0, |count, line| {
//             // let v: Vec<&str> = line.split(" ").collect();
//             // let bounds: Vec<&str> = v[0].split("-").collect();
//             // let index1: usize = bounds[0].parse().unwrap();
//             // let index2: usize = bounds[1].parse().unwrap();
//             // let letter = v[1].chars().next().unwrap();
//             // let password = String::from(v[2]);
//             let mut v = line.split(" ");
//             let mut bounds = v.next().unwrap().split("-");
//             let index1: usize = bounds.next().unwrap().parse().unwrap();
//             let index2: usize = bounds.next().unwrap().parse().unwrap();
//             let letter = v.next().unwrap().chars().next().unwrap();
//             let password = String::from(v.next().unwrap());
//             let bytes = password.as_bytes();
//             count + if (bytes[index1 - 1] as char == letter) ^
//                        (bytes[index2 - 1] as char == letter) {
//                 1
//             } else {
//                 0
//             }
//         })
// }
