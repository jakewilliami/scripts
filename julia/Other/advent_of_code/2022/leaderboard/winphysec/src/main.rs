use std::env;

use dotenv::dotenv;

mod dates;
mod request;
mod stats;

#[tokio::main]
async fn main() {
    dotenv().ok();

    let leaderboard_id = env::var("LEADERBOARD_ID").expect("Could not find \"LEADERBOARD_ID\" in .env");
    let session_cookie = env::var("SESSION_COOKIE").expect("Could not find \"SESSION_COOKIE\" in .env");

    let res = request::pull_leaderboard_data(leaderboard_id, session_cookie).await;

    println!("{:?}", res);
	// let tp = dates::TimeSummary::Days(1);
	// println!("{:?}", tp.value())
	let tp = dates::TimeSummaryPeriod::Hours;
	println!("{:?}", tp.to_friendly());
}
