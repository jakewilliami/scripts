// #[path = "postcodes.rs"] mod postcodes;
use super::postcodes::Postcode;

use super::response::*;

// use postcodes::Postcode;

extern crate base64;
// extern crate hyper;
// extern crate futures;
// extern crate
extern crate reqwest;
use reqwest::header::*;
// use reqwest::Url
// use hyper::{Client, Uri, HeaderMap, Request};
use hyper::Uri;
// use std::str;
extern crate lazy_static;
use lazy_static::lazy_static;
// extern crate bytes;
// use bytes::Bytes;

extern crate serde_json;

fn print_type_of<T>(_: &T) {
    println!("{}", std::any::type_name::<T>())
}

pub const TOOLS0: &str = "dG9vbHMubnpwb3N0LmNvLm56";
pub const TOOLS1: &str = "aHR0cHM6Ly90b29scy5uenBvc3QuY28ubnovbGVnYWN5L2FwaS9zdWdnZXN0X3BhcnRpYWw=";
pub const TOOLS2: &str = "aHR0cHM6Ly90b29scy5uenBvc3QuY28ubnovbGVnYWN5L2FwaS9wYXJ0aWFsX2RldGFpbHM=";
pub const BASE0: &str = "aHR0cHM6Ly93d3cubnpwb3N0LmNvLm56";
pub const BASE1: &str = "aHR0cHM6Ly93d3cubnpwb3N0LmNvLm56L3Rvb2xzL2FkZHJlc3MtcG9zdGNvZGUtZmluZGVy";

pub const GLOB_BASE_ENCODED: &str = "aHR0cHM6Ly93d3cu";
const BASE_PUBLIC_URI_ENCODED: &str = "bnpwb3N0LmNvLm56";
// const PUBLIC_URI_ENCODED = "aHR0cHM6Ly93d3cubnpwb3N0LmNvLm56L3Rvb2xzL2FkZHJlc3MtcG9zdGNvZGUtZmluZGVy";
pub const PUBLIC_URI_ENCODED: &str = "L3Rvb2xzL2FkZHJlc3MtcG9zdGNvZGUtZmluZGVy";
pub const BASE_API_URI_ENCODED: &str = "dG9vbHMubnpwb3N0LmNvLm56";
pub const API_URI_ENCODED: &str = "aHR0cHM6Ly90b29scy5uenBvc3QuY28ubnovbGVnYWN5L2FwaS8=";

pub const LOCATOR_SUFFIX_ENCODED: &str = "Jk1heERhdGE9bWF4JTNBMTA=";
pub const UID_QUERY_ENCODED: &str = "L3N1Z2dlc3RfcGFydGlhbD9xPQ==";
pub const DPID_QUERY_ENCODED: &str = "L3N1Z2dlc3Q/cT0=";
pub const PC_QUERY_ENCODED: &str = "L3BhcnRpYWxfZGV0YWlscz91bmlxdWVfaWQ9";
pub const ADDR_QUERY_ENCODED: &str = "L2RldGFpbHM/ZHBpZD0=";

pub const COORD_KEY_ENCODED: &str = "TlpHRDJrQ29vcmQ=";
pub const UID_KEY_ENCODED: &str = "VW5pcXVlSWQ=";
pub const PC_KEY_ENCODED: &str = "RnVsbFBhcnRpYWw=";
pub const REGION_KEY_ENCODED: &str = "Q2l0eVRvd24=";

lazy_static!{
    // static ref STATE: Mutex<MyState> = Mutex::new(MyState::whatever());
    
    // AS URIs
    static ref GLOB_BASE: Uri = into_uri(GLOB_BASE_ENCODED);
    static ref BASE_PUBLIC_URI: Uri = into_uri(BASE_PUBLIC_URI_ENCODED);
    static ref FULL_BASE_PUBLIC_URI: Uri = into_uri(
        format!("{}{}",
            base64_into_str(GLOB_BASE_ENCODED),
            base64_into_str(BASE_PUBLIC_URI_ENCODED)
        ).as_str()
    );
    // static ref PUBLIC_URI: String = GLOB_BASE
    //     .push_str(into_uri(BASE_PUBLIC_URI_ENCODED))
    //     .push_str(into_uri(PUBLIC_URI_ENCODED));
    static ref PUBLIC_URI: Uri = into_uri(
        format!("{}{}{}",
            base64_into_str(GLOB_BASE_ENCODED),
            base64_into_str(BASE_PUBLIC_URI_ENCODED),
            base64_into_str(PUBLIC_URI_ENCODED)
        ).as_str()
    );
    // static ref PUBLIC_URI: String = String::new()
    //     .push_str(&GLOB_BASE)
    //     .push_str(&into_uri(BASE_PUBLIC_URI_ENCODED))
    //     .push_str(&into_uri(PUBLIC_URI_ENCODED));
    // PUBLIC_URI.push_str(into_uri(BASE_PUBLIC_URI_ENCODED));
    // PUBLIC_URI.push_str(into_uri(PUBLIC_URI_ENCODED));
    static ref BASE_API_URI: Uri = into_uri(BASE_API_URI_ENCODED);
    static ref API_URI: Uri = into_uri(API_URI_ENCODED);
    
    static ref LOCATOR_SUFFIX: Uri = into_uri(LOCATOR_SUFFIX_ENCODED);
    static ref UID_QUERY: Uri = into_uri(UID_QUERY_ENCODED);
    static ref DPID_QUERY: Uri = into_uri(DPID_QUERY_ENCODED);
    static ref PC_QUERY: Uri = into_uri(PC_QUERY_ENCODED);
    static ref ADDR_QUERY: Uri = into_uri(ADDR_QUERY_ENCODED);
    
    static ref COORD_KEY: Uri = into_uri(COORD_KEY_ENCODED);
    static ref UID_KEY: Uri = into_uri(UID_KEY_ENCODED);
    static ref PC_KEY: Uri = into_uri(PC_KEY_ENCODED);
    static ref REGION_KEY: Uri = into_uri(REGION_KEY_ENCODED);
    
    // AS STRINGS
    static ref GLOB_BASE_STR: String = base64_into_str(GLOB_BASE_ENCODED);
    static ref BASE_PUBLIC_URI_STR: String = base64_into_str(BASE_PUBLIC_URI_ENCODED);
    static ref FULL_BASE_PUBLIC_URI_STR: String = format!("{}{}",
        base64_into_str(GLOB_BASE_ENCODED),
        base64_into_str(BASE_PUBLIC_URI_ENCODED)
    );
    static ref PUBLIC_URI_STR: String = format!("{}{}{}",
        base64_into_str(GLOB_BASE_ENCODED),
        base64_into_str(BASE_PUBLIC_URI_ENCODED),
        base64_into_str(PUBLIC_URI_ENCODED)
    );
    static ref BASE_API_URI_STR: String = base64_into_str(BASE_API_URI_ENCODED);
    static ref API_URI_STR: String = base64_into_str(API_URI_ENCODED);
    
    static ref LOCATOR_SUFFIX_STR: String = base64_into_str(LOCATOR_SUFFIX_ENCODED);
    static ref UID_QUERY_STR: String = base64_into_str(UID_QUERY_ENCODED);
    static ref DPID_QUERY_STR: String = base64_into_str(DPID_QUERY_ENCODED);
    static ref PC_QUERY_STR: String = base64_into_str(PC_QUERY_ENCODED);
    static ref ADDR_QUERY_STR: String = base64_into_str(ADDR_QUERY_ENCODED);
    
    static ref COORD_KEY_STR: String = base64_into_str(COORD_KEY_ENCODED);
    static ref UID_KEY_STR: String = base64_into_str(UID_KEY_ENCODED);
    static ref PC_KEY_STR: String = base64_into_str(PC_KEY_ENCODED);
    static ref REGION_KEY_STR: String = base64_into_str(REGION_KEY_ENCODED);
}

// #[repr(C)]
// union PostCode {
//     I: isize,
//     S: String
// }

// FUNCTIONS BEGIN HERE

// fn str2base64(str: String) {
//     return base64::encode(str.as_bytes());
//     // return str.as_bytes().to_base64(base64::STANDARD);
// }

fn base64_into_str(base64str: &str) -> String {
    // let bytes = base64::decode(Bytes::from(base64str)).unwrap();
    let bytes = base64::decode(base64str).unwrap();
    return String::from_utf8(bytes).expect("Invalid UTF-8 byte sequence");
}

// fn into_uri(base64str: &str) -> Uri {
//     let bytes = base64::decode(base64str).unwrap();
//     return String::from_utf8(bytes)
//         .expect("Invalid UTF-8 byte sequence")
//         .parse()
//         .unwrap();
// }

fn into_uri(base64str: &str) -> Uri {
    let bytes = base64::decode(base64str).unwrap();
    // return String::from_utf8(bytes)
    //     .expect("Invalid UTF-8 byte sequence")
    //     .parse()
    //     .unwrap();
    //     let bytes = Bytes::from("http://example.com/foo");
    // let uri = Uri::from_shared(bytes).unwrap();
    // return base64::decode(base64str)
    //     .unwrap()
    //     .Uri::from_shared(bytes)
    //     .unwrap()
    let uri: Uri = String::from_utf8(bytes)
        .expect("Invalid UTF-8 byte sequence")
        .parse()
        .unwrap();
    return uri;
}

// fn error_if_unsuccessful(j: serde_json::Value) {
// 	if j["success"] || () {
// 		let err = String::new();
// 		err.push_str(j["error"]["message"]);
// 		err.push_str("; error code");
// 		err.push_str(j["error"]["code"].to_string());
//
// 	}
// }
//
// error_if_unsuccessful(j::D) where {D <: Dict} =
// 	j["success"] || error(j["error"]["message"] * "; error code " * string(j["error"]["code"]))

// #[tokio::main]
// async url: Uri
pub async fn make_request(uri: &str) -> serde_json::Map<String, serde_json::Value> {
// pub async fn make_request(uri: &str) -> String {
// pub async fn make_request(uri: &str) -> impl Future<Output = serde_json::Value> {
    // build the client using the builder pattern
    let client = reqwest::Client::new();
    //     .user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36")
    //     .build()
    //     .expect("Failed to initilise HTTP interface");
    // let client = reqwest::Client::builder()
    //     .build()
    //     .expect("Failed to initialise HTTP interface");
    // let mut headers = header
    // let mut headers = reqwest::header::HeaderMap::new(); headers.insert(reqwest::header::USER_AGENT,reqwest::header::HeaderValue::from_static("curl"));
    let mut headers = reqwest::header::HeaderMap::new();
    
    //// const reqwest header names
    // headers.append(HOST, BASE_API_URI_STR.parse().unwrap());
    // // headers.append("Sec-Ch-Ua", "\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"90\"".parse().unwrap());
    // headers.append(ACCEPT, "application/json".parse().unwrap());
    // // headers.append("Sec-Ch-Ua-Mobile", "?0".parse().unwrap());
    // headers.append(USER_AGENT, "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36".parse().unwrap());
    // headers.append(ORIGIN, FULL_BASE_PUBLIC_URI_STR.parse().unwrap());
    // // WE CAN IMPLEMENT THIS SOON // headers.append(ACCEPT_ENCODING, "gzip, deflate".parse().unwrap());
    // // headers.append("Sec-Fetch-Site", "same-site".parse().unwrap());
    // // headers.append("Sec-Fetch-Mode", "cors".parse().unwrap());
    // // headers.append("Sec-Fetch-Dest", "empty".parse().unwrap());
    // headers.append(REFERER, PUBLIC_URI_STR.parse().unwrap());
    // headers.append(ACCEPT_LANGUAGE, "en-GB,en-US;q=0.9,en;q=0.8".parse().unwrap());
    // headers.append(CONNECTION, "close".parse().unwrap());
    
    //// string-based header names
    headers.append("host", BASE_API_URI_STR.parse().unwrap());
    // headers.append("Sec-Ch-Ua", "\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"90\"".parse().unwrap());
    headers.append("accept", "application/json".parse().unwrap());
    // headers.append("Sec-Ch-Ua-Mobile", "?0".parse().unwrap());
    headers.append("user-agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36".parse().unwrap());
    headers.append("origin", FULL_BASE_PUBLIC_URI_STR.parse().unwrap());
    // WE CAN IMPLEMENT THIS SOON // headers.append(ACCEPT_ENCODING, "gzip, deflate".parse().unwrap());
    // headers.append("Sec-Fetch-Site", "same-site".parse().unwrap());
    // headers.append("Sec-Fetch-Mode", "cors".parse().unwrap());
    // headers.append("Sec-Fetch-Dest", "empty".parse().unwrap());
    headers.append("referer", PUBLIC_URI_STR.parse().unwrap());
    headers.append("accept-language", "en-GB,en-US;q=0.9,en;q=0.8".parse().unwrap());
    headers.append("connection", "close".parse().unwrap());
    
    // println!("Requesting from: {}", uri);
    
    // let uri: Uri = postcode_uri.parse().unwrap();
    
    let res = client
        .get(uri)
        .headers(headers)
        // .headers_mut()
        // .insert("host", BASE_API_URI_STR.parse().unwrap())
        // .insert("accept", "application/json".parse().unwrap())
        // .insert("user-agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36".parse().unwrap())
        // .insert("origin", FULL_BASE_PUBLIC_URI_STR.parse().unwrap())
        // .insert("referer", PUBLIC_URI_STR.parse().unwrap())
        // .insert("accept-language", "en-GB,en-US;q=0.9,en;q=0.8".parse().unwrap())
        // .insert("connection", "close".parse().unwrap())
        .send()
        .await
        .expect("Failed to access URI");
    
    // match res { // .await
    //     Ok(res) => println!("Resp: {}", res.status()),
    //     Err(err) => println!("Error: {}", err),
    // }
    
    let status = res.status();
    
    let body = res
		.text()
		.await
		.expect("Failed to retrieve body of response");
    
    // println!("Resp: {}", body);
    
    let data: serde_json::Value = serde_json::from_str(&body).expect("The JSON response was not well defined");
    let map: serde_json::Map<String, serde_json::Value> = data.as_object().unwrap().clone();
    
    return map;
    // return body;
}

// I have made the decision to use Option rather than Result because I don't actually want anything to error if it doesn't find anything, just want it to silently return.
// pub async fn get_suggested_postcodes(postcode: Postcode) -> Result<serde_json::Value, &'static serde_json::Value> {
// pub async fn get_suggested_postcodes(postcode: Postcode) -> Option<&'static serde_json::Value> {
// pub async fn get_suggested_postcodes(postcode: Postcode) -> Option<Vec<EachPostcode>> {
// pub async fn get_suggested_postcodes(postcode: Postcode) -> Option<serde_json::Map<String, serde_json::Value>> {
pub async fn get_suggested_postcodes(postcode: Postcode) -> Option<Vec<EachPostcode>> {
    let mut base_URL: String = String::new();
    base_URL.push_str(&API_URI_STR);
    base_URL.push_str(&UID_QUERY_STR);
    base_URL.push_str(postcode.postcode.as_str());
    
    let data: serde_json::Map<String, serde_json::Value> = make_request(base_URL.as_str()).await;
    // let data = make_request(base_URL.as_str()).await;
    // let deserialised: PostcodeResponse = serde_json::from_str(data.as_str()).unwrap();
    // println!("{}", base_URL);
    // let resp = make_request(base_URL.as_str());
    // print_type_of(&resp);
    
    let is_success = &data["success"];
    // let is_success: bool = deserialised.success;
    if is_success != true {
        // let err = String::new();
		// err.push_str(data["error"]["message"].as_str().unwrap());
		// err.push_str("; error code");
		// err.push_str(data["error"]["code"].as_str());
		// return Err(err);
        // let err = &data["error"]["message"];
        // let err = serde_json::from_value(json["subtree"][0].take())?
        // return Err(err);
        return None;
	}
    
    // let deserialised: PostcodeSearchResponse = serde_json::value::from_value(data["addresses"]).unwrap();
    let res = &data["addresses"];
    // let potential_postcodes: serde_json::Map<String, serde_json::Value> = res.as_object().unwrap().clone();
    let potential_postcodes: Vec<EachPostcode> = serde_json::value::from_value(res.to_owned()).unwrap();
    
    // println!("{:?}", deserialised);
    // println!("{:?}", potential_postcodes);
    
    // let response_key = "addresses";
    
    // match res { // .await
    //     Ok(res) => println!("Resp: {}", res.status()),
    //     Err(err) => println!("Error: {}", err),
    // }
    
    // return Ok(data[response_key]);
    // let potential_postcodes = data.get(response_key);
    // return potential_postcodes;
    // let potential_postcodes = &data[response_key];
    
    return Some(potential_postcodes);
    // return Some(potential_postcodes);
    // return Some(deserialised.addresses)
    // return Some(potential_postcodes);
    
    // if potential_postcodes.is_some() {
    //     // return Some(potential_postcodes.unwrap())
    //     return potential_postcodes;
    // } else {
    //     return None;
    // }
    // return Some(data.get(response_key).unwrap())
}

// pub fn make_
