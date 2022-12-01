use super::dates::TimeSummary;

pub struct StarStats {
	n: usize,
	time_summary: TimeSummary,
	seconds: f64,
}

pub struct DayStats {
	day: usize,
	stats: Vec<StarStats>,
}

pub struct UserStats {
	name: String,
	stats: Vec<DayStats>,
	stars: usize,
}
