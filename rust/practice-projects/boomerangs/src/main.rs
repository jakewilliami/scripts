// A boomerang is a V-shaped sequence that is either upright or upside down.  
// Specifically, a boomerang can be defined as: a sub-array of length 3, with the first and last digits being the same and the middle digit being different.  
// Create a function that returns the total number of boomerangs in an array

fn main() {
	// test assertions
    assert!(count_boomerangs(vec![3, 7, 3, 2, 1, 5, 1, 2, 2, -2, 2]) == 3);
	assert!(count_boomerangs(vec![1, 7, 1, 7, 1, 7, 1]) == 5);
	assert!(count_boomerangs(vec![9, 5, 9, 5, 1, 1, 1]) == 2);
	assert!(count_boomerangs(vec![5, 6, 6, 7, 6, 3, 9]) == 1);

	// display some of the test cases
	println!("The input array is: {:?}", vec![3, 7, 3, 2, 1, 5, 1, 2, 2, -2, 2]);
	println!("There are {:?} boomerangs in the above list", count_boomerangs(vec![3, 7, 3, 2, 1, 5, 1, 2, 2, -2, 2]));
	println!("They are: {:?}\n", get_boomerangs(&vec![3, 7, 3, 2, 1, 5, 1, 2, 2, -2, 2]));
	println!("The input array is: {:?}", vec![1, 7, 1, 7, 1, 7, 1]);
	println!("There are {:?} boomerangs in the above list", count_boomerangs(vec![1, 7, 1, 7, 1, 7, 1]));
	println!("They are: {:?}\n", get_boomerangs(&vec![1, 7, 1, 7, 1, 7, 1]));
	println!("The input array is: {:?}", vec![9, 5, 9, 5, 1, 1, 1]);
	println!("There are {:?} boomerangs in the above list", count_boomerangs(vec![9, 5, 9, 5, 1, 1, 1]));
	println!("They are: {:?}\n", get_boomerangs(&vec![9, 5, 9, 5, 1, 1, 1]));
	println!("The input array is: {:?}", vec![5, 6, 6, 7, 6, 3, 9]);
	println!("There are {:?} boomerangs in the above list", count_boomerangs(vec![5, 6, 6, 7, 6, 3, 9]));
	println!("They are: {:?}\n", get_boomerangs(&vec![5, 6, 6, 7, 6, 3, 9]));
}

fn count_boomerangs<T: std::cmp::PartialEq>(in_arr: Vec<T>) -> isize {
	let mut count = 0;
	
	for (i, a) in in_arr.iter().enumerate() {
		if (in_arr.len() - i - 1) < 2 {
			break;
		}

		if (a == &in_arr[i + 2]) && (&in_arr[i + 1] != a) {
			// we have found a new boomerang!  Count it
			count = count + 1;
		}
	}

	return count;
}

// We cannot use this commented-out signature because the input array contains data which is destroyed when the get_boomerangs function exits. You can instead take in a reference to data, so that it will live for longer than the function being called: in_arr: &[T]
// fn get_boomerangs<T: std::cmp::PartialEq>(in_arr: Vec<T>) -> Vec<Vec<&'static T>> {
fn get_boomerangs<T: std::cmp::PartialEq>(in_arr: &[T]) -> Vec<Vec<&T>> {
	let mut out_arr: Vec<Vec<&T>> = vec![];
	
	for (i, a) in in_arr.iter().enumerate() {
		if (in_arr.len() - i - 1) < 2 {
			break;
		}

		if (a == &in_arr[i + 2]) && (&in_arr[i + 1] != a) {
			let boomerang: Vec<&T> = vec![&a, &in_arr[i + 1], &a];
			// we have found a new boomerang!  Add it to the array of boomerangs
			out_arr.push(boomerang);
		}
	}

	return out_arr;
}
