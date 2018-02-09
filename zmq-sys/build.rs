extern crate metadeps;

#[cfg(target_env="msvc")]
extern crate vcpkg;

use std::env;
use std::path::Path;

fn prefix_dir(env_name: &str, dir: &str) -> Option<String> {
    env::var(env_name).ok().or_else(|| {
        env::var("LIBZMQ_PREFIX").ok()
            .map(|prefix| Path::new(&prefix).join(dir))
            .and_then(|path| path.to_str().map(|p| p.to_owned()))
    })
}

fn main() {
    let lib_path = prefix_dir("LIBZMQ_LIB_DIR", "lib");
    let include = prefix_dir("LIBZMQ_INCLUDE_DIR", "include");

    match (lib_path, include) {
        (Some(lib_path), Some(include)) => {
            println!("cargo:rustc-link-search=native={}", lib_path);
            println!("cargo:include={}", include);
        }
        (Some(_), None) => {
            panic!("Unable to locate libzmq include directory.")
        }
        (None, Some(_)) => {
            panic!("Unable to locate libzmq library directory.")
        }
        (None, None) => {
            if try_vcpkg() {
                return;
            }

            if let Err(e) = metadeps::probe() {
                panic!("Unable to locate libzmq:\n{}", e);
            }
        }
    }
}

#[cfg(not(target_env="msvc"))]
fn try_vcpkg() -> bool {
    false
}

#[cfg(target_env="msvc")]
fn try_vcpkg() -> bool {
    match  vcpkg::Config::new().probe2("zeromq") {
        Err(e) => {
            println!("vcpkg did not find zeromq: {}", e);
            false
        }
        Ok(_) => {
            println!("cargo:rustc-link-lib=iphlpapi");
            true
        }
    }
}