mod config;

use std::time::SystemTime;
// use totp_rs::{Algorithm, TOTP};
// use otpauth::TOTP;
use libreauth::oath::TOTPBuilder;

fn main() {
    // let time = SystemTime::now()
    //     .duration_since(SystemTime::UNIX_EPOCH)
    //     .unwrap()
    //     .as_secs();
    
    // totp-rs
    // let totp = TOTP::new(
    //     Algorithm::SHA1,
    //     6,
    //     0,
    //     30,
    //     config::SECRET,
    // );
    // let token = totp.generate(time);
    
    // otpauth
    // let totp = TOTP::new(config::SECRET);
    // let token = totp.generate(30, time);
    
    // libreauth
    let key = &config::SECRET.to_string();
    let token = TOTPBuilder::new()
        .base32_key(&key)
        .finalize()
        .unwrap()
        .generate();
    
    println!("{}", format_totp_code(token.to_string()));
}

fn format_totp_code(totp_code: String) -> String {
    return format!("{} {}", &totp_code[0..3], &totp_code[3..]);
}

/*
# Equivalent python code:

from pyotp import TOTP

import config

def format_totp_code(totp_code: str) -> str:
    return f'{totp_code[0:3]} {totp_code[3:]}'

if __name__ == '__main__':
    totp_code = TOTP(config.totp).now()
    print(format_totp_code(totp_code))

# It took me _so_ long to find out the OTP library that gave
# me the same functionality as PyOPT.  The bad thing about
# having a short lifetime is the lack of consensus around
# good libraries.  There were a lot of medium-sized libraries
# that came up on Google before LibreAuth...
*/
