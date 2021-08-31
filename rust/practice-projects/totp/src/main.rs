mod config;

use std::time::SystemTime;
use totp_rs::{Algorithm, TOTP};

fn main() {
	let totp = TOTP::new(
		Algorithm::SHA1,
		6,
		1,
		30,
		config::SECRET,
	);
	let time = SystemTime::now()
		.duration_since(SystemTime::UNIX_EPOCH)
		.unwrap()
		.as_secs();
	let url = totp.get_url();
	let token = totp.generate(time);
	println!("{:?}", token);
}
