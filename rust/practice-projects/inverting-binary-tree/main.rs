use std::fmt::Display;

// type alias for a commonly used option for reference for generic node
type NodeRef<T> = Option<Box<Node<T>>>;

#[derive(Debug, Clone)]
struct Node<T> {
	value: T,
	left: NodeRef<T>,
	right: NodeRef<T>
}

fn generate_tree(level: usize, counter: &mut isize) -> NodeRef<isize> {
	if level == 0 {
		return None;
	}
	
	let mut node = Node {
		value: *counter,
		left: None,
		right: None
	};
	*counter += 1;
	node.left = generate_tree(level - 1, counter);
	node.right = generate_tree(level - 1, counter);
	
	return Some(Box::new(node));
}

// make sure we are able to copy the contents of the tree, 
// so need the generic to be clonable
fn invert_tree<T: Clone>(root: NodeRef<T>) -> NodeRef<T> {
	match root {
		Some(node) => {
			let node = Node {
				value: node.value, // .clone() ???
				left: invert_tree(node.right),
				right: invert_tree(node.left)
			};
			return Some(Box::new(node));
		}
		None => None
	}
}

// We make sure the generic is printable
fn print_tree<T: Display>(root: &NodeRef<T>, level: usize) {
	match root {
		Some(node) => {
			print_tree(&node.right, level + 1);
			// indent
			for _ in 0..level {
				print!("  ");
			}
			println!("{}", node.value);
			print_tree(&node.left, level + 1);
		}
		None => {}
	}
}

fn main() {
	let mut counter = 1;
	let tree = generate_tree(3, &mut counter);
	print_tree(&tree, 0);
	println!("------------------------------");
	print_tree(&invert_tree(tree), 0);
}
