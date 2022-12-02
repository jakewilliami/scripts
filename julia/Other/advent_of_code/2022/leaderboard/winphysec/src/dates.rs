use chrono::{NaiveDate, NaiveDateTime};

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
    pub fn period_type(&self) -> TimeSummaryPeriod {
        match self {
            TimeSummary::Days(_) => { TimeSummaryPeriod::Days },
            TimeSummary::Hours(_) => { TimeSummaryPeriod::Hours },
            TimeSummary::Minutes(_) => { TimeSummaryPeriod::Minutes },
            TimeSummary::Seconds(_) => { TimeSummaryPeriod::Seconds },
        }
    }

    pub fn value(&self) -> usize {
        match self {
            TimeSummary::Days(i) => { *i },
            TimeSummary::Hours(i) => { *i },
            TimeSummary::Minutes(i) => { *i },
            TimeSummary::Seconds(i) => { *i },
        }
    }

    pub fn new(mut seconds: i64) -> Vec<Self> {
        let num_seconds_in_day = 86_400;  // 24 * 60 * 60
        let num_minutes_in_day = 3600;  // 60 * 60

        let days = seconds / num_seconds_in_day;
        seconds %= num_seconds_in_day;
        let hours = seconds / num_minutes_in_day;
        seconds %= num_minutes_in_day;
        let minutes = seconds / 60;
        seconds %= 60;

        vec![
            TimeSummary::Days(days as usize),
            TimeSummary::Hours(hours as usize),
            TimeSummary::Minutes(minutes as usize),
            TimeSummary::Seconds(seconds as usize),
        ]
    }
}

pub fn format_time_summary(time_summary: Vec<TimeSummary>) -> String {
    let mut out = String::new();
    let unit_map: Vec<&TimeSummary> = time_summary.iter().filter(|t| { t.value() != 0 }).collect();

    for (i, t) in unit_map.iter().enumerate() {
        let at_last_nonzero_unit = i == unit_map.len() - 1;
        if at_last_nonzero_unit {
            out.push_str("and ");
        }
        out.push_str(format!("{} {}", t.value(), (*t).period_type().to_friendly()).as_str());
        if !at_last_nonzero_unit {
            let sep = if unit_map.len() == 2 { " " } else { ", " };
            out.push_str(sep);
        }
    }

    out
}

pub fn get_seconds_since_day_start(d_i: usize, ts: i64) -> i64 {
    let d = NaiveDate::from_ymd_opt(2022, 12, d_i as u32).unwrap().and_hms_opt(0, 0, 0).unwrap();
    let p = d - NaiveDateTime::from_timestamp_opt(ts, 0).unwrap();
    p.num_seconds()
}
