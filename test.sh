
# git bash script

set -ex

export VCPKG_PANIC=on
export CARGO=cargo

#  x86_64-pc-windows-gnu i686-pc-windows-gnu
for i in x86_64-pc-windows-msvc i686-pc-windows-msvc; do 
    export VCPKG_ROOT="c:\Users\jim\src\diesel_build\vcpkg-static"
    export RUSTFLAGS=-Ctarget-feature=+crt-static\ -Zunstable-options
    echo $i static $RUSTFLAGS
    echo here
    $CARGO run --target $i --example version
    echo here2
    $CARGO test --target $i
    $CARGO clean
    export VCPKG_ROOT="c:\Users\jim\src\diesel_build\vcpkg-dll"
    unset RUSTFLAGS
    echo $i dynamic
    $CARGO run --target $i --example version
    $CARGO test --target $i
    $CARGO clean
done

#echo linux
#bash -l -c "cargo test --no-default-features"
