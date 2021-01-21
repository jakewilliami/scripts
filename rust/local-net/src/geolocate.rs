extern crate ipgeolocate;

use ipgeolocate::Locator;

// fn print_type_of<T>(_: &T) {
//     println!("{}", std::any::type_name::<T>())
// }

// This API has access to:
// ip
// latitude
// longitude
// city
// region
// country
// timezone


pub fn get_geolocation(ip: &str) -> (String, String, String, String) {
    // services include: freegeoip, ipapi, ipapico, ipwhois
    // let t = match Locator::get("1.1.1.1", "ipapi") {
    //     Ok(ip) => println!("{} {} {} {}", ip.ip, ip.city, ip.region, ip.country),
    //     Err(error) => println!("{}", error),
    // };
    
    let ip_data: Locator = Locator::get(ip, "ipapi").unwrap();
    let t: (String, String, String, String) =
        (ip_data.latitude, ip_data.longitude, ip_data.region, ip_data.country);
    
    return t;
}
