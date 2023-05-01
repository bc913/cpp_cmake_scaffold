# Ninja Build Tool

## Installation
`Ninja` build tool can be installed using one of two ways:
1. Build and install from sources:
    1. [Windows only] open a Visual Studio x64 native tools command prompt
    2. `git clone https://github.com/ninja-build/ninja.git`
    3. cd ninja && python configure.py –bootstrap
2. Using the binaries
    1. Download the release from [here](https://github.com/ninja-build/ninja/releases) based on your OS.
    2. Place the binary to an appropriate location.
    3. Add that placed binary location to `PATH`. 

## Usage
### With CMake
```bash
# Generate (configure)
cmake . -B build -G Ninja ...
# Make sure build.ninja is generated under build directory

# Build (compile, link)
# Option 1
cmake -- build build --config <...>
# Option 2
cd build
ninja

# Install
# Option 1
cmake --install build --config <...>
# Option 2
cd build
ninja install
```
## References
- [CMake Ninja Combo: The Gist](https://www.incredibuild.com/blog/cmake-ninja-combo-the-gist)
- [Let's Build Chuck Norris! - Part 1: CMake and Ninja](https://dmerej.info/blog/post/chuck-norris-part-1-cmake-ninja/)