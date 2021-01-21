mod geolocate;
mod pubip;

fn main() {
    let p_ip: String = pubip::get_pub_ip();
    let geolocation: (String, String, String, String) = geolocate::get_geolocation(&p_ip);
    
    println!("{}, {}, {}, {}", geolocation.0, geolocation.1, geolocation.2, geolocation.3);
}
