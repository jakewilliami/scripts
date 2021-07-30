// NO LONGER USED

extern crate base64;
extern crate lazy_static;
use lazy_static::lazy_static;

fn into_URI(base64str: &str) -> String {
    let bytes = base64::decode(base64str).unwrap();
    return String::from_utf8(bytes).expect("Invalid UTF-8 byte sequence");
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
    
    static ref GLOB_BASE: String = intoURI(GLOB_BASE_ENCODED);
    static ref BASE_PUBLIC_URI: String = intoURI(BASE_PUBLIC_URI_ENCODED);
    static ref PUBLIC_URI: String = GLOB_BASE.to_string();
    PUBLIC_URI.push_str(intoURI(BASE_PUBLIC_URI_ENCODED));
    PUBLIC_URI.push_str(intoURI(PUBLIC_URI_ENCODED));
    static ref BASE_API_URI: String = intoURI(BASE_API_URI_ENCODED);
    static ref API_URI: String = intoURI(API_URI_ENCODED);

    static ref LOCATOR_SUFFIX: String = intoURI(LOCATOR_SUFFIX_ENCODED);
    static ref UID_QUERY: String = intoURI(UID_QUERY_ENCODED);
    static ref DPID_QUERY: String = intoURI(DPID_QUERY_ENCODED);
    static ref PC_QUERY: String = intoURI(PC_QUERY_ENCODED);
    static ref ADDR_QUERY: String = intoURI(ADDR_QUERY_ENCODED);

    static ref COORD_KEY: String = intoURI(COORD_KEY_ENCODED);
    static ref UID_KEY: String = intoURI(UID_KEY_ENCODED);
    static ref PC_KEY: String = intoURI(PC_KEY_ENCODED);
    static ref REGION_KEY: String = intoURI(REGION_KEY_ENCODED);
}
