mod geolocate;
mod pubip;

fn main() {
	// TODO:
	// With geolocate, default to pub ip if no param.  If param, use that as IP
	
    let p_ip: String = pubip::get_pub_ip();
	// let p_ip: String = "121.72.2.49".to_string();
    let geolocation: (String, String, String, String) = geolocate::get_geolocation(&p_ip);
    
    println!("{}, {}, {}, {}", geolocation.0, geolocation.1, geolocation.2, geolocation.3);
}

