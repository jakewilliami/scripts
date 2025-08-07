// use std::io::{stdout, Write};
use curl::easy::Easy;

// myip=$(curl -s ipinfo.io/ip | sed 's/[a-zA-Z<>/ :]//g')  # Get ip address
/// ip_specs "json" "${myip}"

// fn print_type_of<T>(_: &T) {
//     println!("{}", std::any::type_name::<T>())
// }

// pub fn get_pub_ip() {
//     let mut dst = Vec::new();
//     let mut easy = Easy::new();
//     easy.url("ipinfo.io/ip").unwrap();
//
//     let mut transfer = easy.transfer();
//     transfer.write_function(|data| {
//         dst.extend_from_slice(data);
//         Ok(data.len())
//     }).unwrap();
//     transfer.perform().unwrap();
//
//     // println!("{:?}", dst);
// }

pub fn get_pub_ip() -> String {
    // First write everything into a `Vec<u8>`
    let mut data = Vec::new();
    let mut handle = Easy::new();
    handle.url("ipinfo.io/ip").unwrap();
    {
        let mut transfer = handle.transfer();
        transfer.write_function(|new_data| {
            data.extend_from_slice(new_data);
            Ok(new_data.len())
        }).unwrap();
        transfer.perform().unwrap();
    }

    // Convert it to `String`
    let ip = String::from_utf8(data).expect("body is not valid UTF8!");
    return ip;
}
