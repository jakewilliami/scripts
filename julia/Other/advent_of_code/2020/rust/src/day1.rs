use aoc_runner_derive::{aoc, aoc_generator};

#[aoc_generator(day1)]
pub fn input_generator(input: &str) -> Vec<u32> {
    input
        .lines()
        .map(|line| line.parse().unwrap())
        .collect()
}

#[aoc(day1, part1)]
pub fn solve_part1(input: &[u32]) -> u32 {
    for (index1, element1) in (&input[0..input.len()-1]).iter().enumerate() {
        for element2 in (&input[index1..]).iter() {
            if element1 + element2 == 2020 {
                return element1 * element2;
            }
        }
    }
    unreachable!()
}

#[aoc(day1, part2)]
pub fn solve_part2(input: &[u32]) -> u32 {
    for (index1, element1) in (&input[0..input.len()-2]).iter().enumerate() {
        for (index2, element2) in (&input[index1..input.len() - 1]).iter().enumerate() {
            for element3 in (&input[index2..]).iter() {
                if element1 + element2 + element3 == 2020 {
                    return element1 * element2 * element3;
                }
            }
        }
    }
    unreachable!()
}
