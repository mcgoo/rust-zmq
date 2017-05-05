@echo off

set VCPKG_PANIC=on
set CARGO=cargo

rem  x86_64-pc-windows-gnu i686-pc-windows-gnu
for %%i in (x86_64-pc-windows-msvc i686-pc-windows-msvc) DO (
    set VCPKG_ALL_STATIC=on
    set VCPKG_ALL_DYNAMIC=
    set VCPKG_ROOT=c:\Users\jim\src\vcpkg
    echo %%i static
    %CARGO% run --target %%i --example version
    %CARGO% test --target %%i
    %CARGO% clean
    set VCPKG_ALL_STATIC=
    set VCPKG_ALL_DYNAMIC=on
    set VCPKG_ROOT=c:\Users\jim\src\vcpkg
    echo %%i dynamic
    %CARGO% run --target %%i --example version
    %CARGO% test --target %%i
    %CARGO% clean
) 

echo linux
bash -l -c "cargo test --no-default-features"
