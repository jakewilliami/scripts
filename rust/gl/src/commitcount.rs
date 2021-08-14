use std::process::{Command, Stdio};
use super::branch::current_branch;
use super::repo::current_repository;
use chrono::{DateTime, Local, Duration};
use colored::*;

// const local: DateTime<Local> = Local::now();
// const today = Utc.ymd(local.year(), local.month(), local.day())
// let today: Date<Local> = Local::today();
// const yesterday = today - Duration::days(1);

pub fn get_commit_count(input: &str) {
	// determine commit count
	let commit_count_val: Option<String>;
	if &input == &"today" {
		commit_count_val = commit_count_today();
	} else if &input == &"yesterday" {
		commit_count_val = commit_count_yesterday();
	} else {
		let days_ago: isize = input.parse().unwrap_or(0);
		commit_count_val = commit_count_since(days_ago);
	}
    // let commit_count_val = commit_count(days_ago, days_ago_end);
	
	// get repository information
	let repo_name = current_repository();
	let branch_name = current_branch();
	
	// determine human-readable "since when" relative time
	let when: String;
	let mut past_tense: &str = "";
	if &input == &"today" || &input == &"yesterday" {
		when = input.to_string();
		if &input == &"today" {
			past_tense = "have "
		}
	} else {
		// let mut tmp_when = String::new();
		// tmp_when.push_str("in the past ");
		// tmp_when.push_str(&input);
		// tmp_when.push_str("days");
		// when = &tmp_when.clone();
		when = format!("in the past {} days", &input);
	};
	
	// print output if possible
	if !commit_count_val.is_none() && !repo_name.is_none() && !branch_name.is_none(){
		// format output nicely (and ensure it's lovely and green)
		let out_message = format!(
			"You {}made {} commits to {}/{} {}.",
			past_tense,
			commit_count_val.unwrap(),
			repo_name.unwrap(),
			branch_name.unwrap(),
			when.as_str()
		);
		println!("{}", out_message.green().bold());
	}
}

fn commit_count_today() -> Option<String> {
	// get the date of interest as a number of seconds
    let today_start: i64 = Local::today().and_hms_milli(0, 0, 0, 0).timestamp();
	let now: i64 = Local::now().timestamp();
	
	// get the commit count for this period
	let commit_count: Option<String> = commit_count(today_start, now);
	return commit_count;
}

fn commit_count_yesterday() -> Option<String> {
	// get the datetimes of interest
    let today_start: DateTime<Local> = Local::today().and_hms_milli(0, 0, 0, 0);
	let yesterday_start: DateTime<Local> = today_start - Duration::days(1);
	// calculate those values in seconds
	let today_timestamp: i64 = today_start.timestamp();
	let yersterday_timestamp: i64 = yesterday_start.timestamp();
    // let date_of_interest: i64 = (since - before) as i64;
    // let timestamp_of_interest: i64 = (today - Duration::days(date_of_interest)).timestamp();
	
	// get the commit count for this period
	let commit_count: Option<String> = commit_count(yersterday_timestamp, today_timestamp);
	return commit_count;
}

fn commit_count_since(n: isize) -> Option<String> {
	// get the datetimes of interest
    let today_start: DateTime<Local> = Local::today().and_hms_milli(0, 0, 0, 0);
	let since_start: DateTime<Local> = today_start - Duration::days(n as i64);
	let now: i64 = Local::now().timestamp();
	// calculate those values in seconds
	let since_timestamp: i64 = since_start.timestamp();
	
	// get the commit count for this period
	let commit_count: Option<String> = commit_count(since_timestamp, now);
	return commit_count;
}

fn commit_count(since_timestamp: i64, before_timestamp: i64) -> Option<String> {
	// construct git command line arguments
	let mut since_arg = String::new();
	since_arg.push_str("--since=");
	since_arg.push_str(since_timestamp.to_string().as_str());
	let mut before_arg = String::new();
	before_arg.push_str("--before=");
	before_arg.push_str(before_timestamp.to_string().as_str());
	
	// run command
	// git rev-list --count --since=$START_TODAY --before=$NOW HEAD
    let mut cmd = Command::new("git");
	cmd.arg("rev-list");
	cmd.arg("--count");
	cmd.arg(since_arg.as_str());
	cmd.arg(before_arg.as_str());
	cmd.arg("HEAD");
	
	// parse command output
	let output = cmd
		.stdout(Stdio::piped())
		.output()
		.expect("Failed to execute `git rev-list`");
	
	// return appropriately (error silently)
	if output.status.success() {
		let mut commit_count = String::from_utf8_lossy(&output.stdout).into_owned();
		if commit_count.ends_with('\n') {
			commit_count.pop();
			if commit_count.ends_with('\r') {
            	commit_count.pop();
        	}
		}
		return Some(commit_count);
	} else {
		return None;
	}
}
