use super::dates::{TimeSummary, get_seconds_since_day_start};

pub struct StarStats {
    pub n: usize,
    pub time_summary: Vec<TimeSummary>,
    pub seconds: i64,
}

pub struct DayStats {
    pub day: usize,
    pub stats: Vec<StarStats>,
}

impl DayStats {
    fn new(day: usize) -> Self {
        DayStats {
            day,
            stats: vec![],
        }
    }
}

pub struct UserStats {
    pub name: String,
    pub stats: Vec<DayStats>,
    pub stars: usize,
}

impl UserStats {
    fn new(name: String) -> Self {
        Self {
            name,
            stats: vec![],
            stars: 0,
        }
    }
}

pub fn parse_user_stats(json_data: serde_json::Map<String, serde_json::Value>) -> Vec<UserStats> {
    // Initialise results
    let mut user_stats: Vec<UserStats> = Vec::new();

    // Iterate over users
    for (_user_id, data) in json_data["members"].as_object().unwrap() {
        let user_data = data["completion_day_level"].as_object().unwrap();

        // If they have no completed days, skip user
        if user_data.is_empty() {
            continue;
        }

        let mut this_user_stats = UserStats::new(data["name"].to_string());

        for d_i in 1..=25 {
            let d_i_str = d_i.to_string();

            // Skip day if haven't done yet
            if !user_data.contains_key(&d_i_str) {
                continue;
            }

            let mut day_stats = DayStats::new(d_i);
            for s_i in 1..=2 {
                let s_i_str = s_i.to_string();

                // Skip part/level/star if incomplete for this day
                let day_data = user_data[&d_i_str].as_object().unwrap();
                if !day_data.contains_key(&s_i_str) {
                    continue;
                }
                this_user_stats.stars += 1;
                let star_data = day_data[&s_i_str].as_object().unwrap();

                // Calculate the minutes since problem released
                let ts = &star_data["get_star_ts"];
                let s = get_seconds_since_day_start(d_i, ts.as_i64().unwrap());
                let t = TimeSummary::new(s);

                // Add star stats to day stats
                let star_stats = StarStats {
                    n: s_i,
                    time_summary: t,
                    seconds: s,
                };
                day_stats.stats.push(star_stats);
            }

            // Add day stats to user stats
            this_user_stats.stats.push(day_stats);
        }

        // Add user stats to results
        user_stats.push(this_user_stats);
    }

    user_stats
}
