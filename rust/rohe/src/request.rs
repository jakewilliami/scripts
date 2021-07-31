extern crate base64;
// extern crate hyper;
// extern crate futures;
// extern crate
extern crate reqwest;
use reqwest::header::*;
// use hyper::{Client, Uri, HeaderMap, Request};
use hyper::Uri;
// use std::str;
extern crate lazy_static;
use lazy_static::lazy_static;
// extern crate bytes;
// use bytes::Bytes;

extern crate serde_json;

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
    
    pub static ref TEST_URI: Uri = "https://httpbin.org/ip".parse().unwrap();
}

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

// #[tokio::main]
// async url: Uri
pub async fn make_request(uri: &str) -> serde_json::Value {
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
    
    println!("Requesting from: {}", uri);
    
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
    
    println!("Resp: {}", body);
    
    let data: serde_json::Value = serde_json::from_str(&body).expect("The JSON response was not well defined");
    
    return data;
}

// pub fn make_
