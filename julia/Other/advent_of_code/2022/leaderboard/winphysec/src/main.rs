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
    let user_stats = stats::parse_user_stats(res);

    for user in user_stats {
        println!("{}:", user.name);
        for day in user.stats {
            println!("    Day {}:", day.day);
            for star in day.stats {
                println!("        {}: {}", star.n, dates::format_time_summary(star.time_summary));
            }
        }
    }
}
