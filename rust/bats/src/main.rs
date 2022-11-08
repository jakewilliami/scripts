use battery::{Battery, Manager};
use battery::units::ratio::percent;

use clap::{Parser, crate_version};

#[derive(Parser, Debug)]
#[command(
    name = "bats",
    author = "Jake·W.·Ireland.·<jakewilliami@icloud.com>",
    version = crate_version!(),
    about = "A·simple command·line·interface·to display battery state",
    long_about = None,
)]
struct Cli {
    // /// Use ioreg to determine state of charge
    // #[arg(short = 'i', long = "ioreg")]
    // ioreg: Option<bool>,

    // /// Use pmset to determine state of charge
    // #[arg(short = 'p', long = "pmset")]
    // pmset: Option<bool>,

    // /// Use custom IOPS* Objective C-calls for macOS
    // ///
    // /// This method is almost certainly less efficient than the
    // /// battery crate, from which the main method is implemented,
    // /// however, I think it would be a fun test to implement
    // #[arg(short = 'o', long = "objc")]
    // objc: Option<bool>
}

fn main() {
    let _args = Cli::parse();

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
