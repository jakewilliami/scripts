use std::Collections::hash_map::DefaultHasher;
use std::hash::Hash;

const INITIAL_NBUCKETS: usize = 1; // 1024?

struct Bucket<K, V> {
	items: Vec<(K, V)>,
}

pub struct HashMap<K, V> {
	buckets: Vec<Bucket<K, V>>,
}

impl<K, V> HashMap<K, V> {
	pub fn new() -> Self {
		HashMap {
			buckets: Vec::new(),
		}
	}
}

impl<K, V> HashMap<K, V>
where: K: Hash
{
	pub fn insert(&mut self, key: K, value: V) -> Option<V> {
		let mut hasher = DefaultHasher;
		key.hash() % self.buckets.len()
	}

	fn resize(&mut self) {
		let target_size = match.self.buckets.len() {
			0 => INITIAL_NBUCKETS,
			n => 2 * n,
		};

		// TODO
	}
}
