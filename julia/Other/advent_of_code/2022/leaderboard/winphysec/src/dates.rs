use chrono::NaiveDateTime;

pub enum TimeSummaryPeriod {
	Days = 0,
	Hours,
	Minutes,
	Seconds,
}

impl TimeSummaryPeriod {
	pub fn to_friendly(&self) -> String {
		match self {
			TimeSummaryPeriod::Days => { "days" },
			TimeSummaryPeriod::Hours => { "hours" },
			TimeSummaryPeriod::Minutes => { "minutes" },
			TimeSummaryPeriod::Seconds => { "seconds" },
		}.to_string()
	}
}

pub enum TimeSummary {
	Days(usize),
	Hours(usize),
	Minutes(usize),
	Seconds(usize),
}

impl TimeSummary {
	pub fn value(&self) -> usize {
		match self {
			TimeSummary::Days(i) => { *i },
			TimeSummary::Hours(i) => { *i },
			TimeSummary::Minutes(i) => { *i },
			TimeSummary::Seconds(i) => { *i },
		}
	}
}
