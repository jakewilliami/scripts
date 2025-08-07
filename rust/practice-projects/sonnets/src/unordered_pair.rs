  6 struct Bucket<K, V> {
  7     items: Vec<(K, V)>,
  8 }
  9
 10 pub struct HashMap<K, V> {
 11     buckets: Vec<Bucket<K, V>>,
 12 }
 13
 14 impl<K, V> HashMap<K, V> {
 15     pub fn new() -> Self {
 16         HashMap {
 17             buckets: Vec::new(),
 18         }
 19     }
 20 }
 21
 22 impl<K, V> HashMap<K, V>
 23 where: K: Hash
 24 {
 25     pub fn insert(&mut self, key: K, value: V) -> Option<V> {
 26         let mut hasher = DefaultHasher;
 27         key.hash() % self.buckets.len()
 28     }
 29
 30     fn resize(&mut self) {
 31         let target_size = match.self.buckets.len() {
 32             0 => INITIAL_NBUCKETS,
 33             n => 2 * n,
 34         };
 35
 36         // TODO
 37     }
 38 }

pub struct UPair {
	
}

pub fn unordered_pair () {

}
