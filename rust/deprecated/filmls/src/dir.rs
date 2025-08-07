// This file provides functions used for dynamically locating the media directory
use std::path::PathBuf;

// Set constant directories
pub const NAS_MEDIA_DIR: &str = "/mnt/Primary/Media/";
pub const MAC_MEDIA_DIR: &str = "/Volumes/Media/";

// Conditionally compiling functions for obtaining media directoried
// Source: https://doc.rust-lang.org/rust-by-example/attribute/cfg.html, https://doc.rust-lang.org/reference/conditional-compilation.html#target_os

#[cfg(any(target_os = "freebsd", target_os = "linux"))]
pub fn get_media_dir() -> PathBuf {
	std::path::PathBuf::from(NAS_MEDIA_DIR)
}

#[cfg(target_os = "macos")]
pub fn get_media_dir() -> PathBuf {
	std::path::PathBuf::from(MAC_MEDIA_DIR)
}

// Fallback on current dir
#[cfg(any(target_family = "windows", target_family = "wasm"))]
pub fn get_media_dir() -> PathBuf {
	std::env::current_dir().expect("Cannot get current directory")
}
