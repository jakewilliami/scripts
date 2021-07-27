extern crate base64;
// extern crate reqwest;
use hyper::{Client, Uri, HeaderMap};
// use std::str;
extern crate lazy_static;
use lazy_static::lazy_static;
// extern crate bytes;
// use bytes::Bytes;

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
    
    static ref GLOB_BASE: Uri = into_uri(GLOB_BASE_ENCODED);
    static ref BASE_PUBLIC_URI: Uri = into_uri(BASE_PUBLIC_URI_ENCODED);
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
// async
pub async fn make_request(url: Uri) {
    let client = Client::new();
    // let mut headers = header
    // let mut headers = reqwest::header::HeaderMap::new(); headers.insert(reqwest::header::USER_AGENT,reqwest::header::HeaderValue::from_static("curl"));
    let mut headers = HeaderMap::new();
    headers.append(HOST, "world".parse().unwrap())
    let res = client
        .get(url)
        .header()
        .await
    match res { // .await
        Ok(res) => println!("Resp: {}", res.status()),
        Err(err) => println!("Error: {}", err),
    }
}

// pub fn make_
