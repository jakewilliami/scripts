use battery::{Battery, Manager};
use battery::units::ratio::percent;

fn main() {
    display_state_of_charge();
}

fn display_state_of_charge() {
    // A convenience function to get the battery charge as a percentage
    fn state_of_charge_percent(battery: &Battery) -> f32 {
        battery.state_of_charge().get::<percent>()
    }

    // Get the batteries of the present machine
    let manager = Manager::new().unwrap();
    let batteries: Vec<Battery> = manager.batteries().unwrap().filter_map(|b| b.ok()).collect();

    if batteries.len() == 1 {
        println!("{:.2}%", state_of_charge_percent(&batteries[0]));
    } else {
        for (i, battery) in batteries.iter().enumerate() {
            println!("Battery #{}: {:.2}%", i + 1, state_of_charge_percent(battery));
        }
    }
}
