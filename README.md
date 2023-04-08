# CMake - Cpp Scaffold Project
## Introduction
An example scaffold Cpp repo for CMake build system. The purpose is to give some insights on how to structure big projects with internal and/or external dependencies. There are several examples on the web how to create libraries (static/shared/header-only) alone but I couldn't find a good and clean explanation on how to create/consume libraries internally in a big cpp project so I provide this repo.

## Requirements
- CMake (> 3.17)
- Powershell (Windows)
- Bash (Unix)
- NSIS (If packaging with NSIS is chosen)
- VSCode (highly recommended)

## Tested Systems
- Windows w/ MSVC
- Mac OS(Catalina 10.15 and BigSur 11.6) w/ Apple clang version 12.0.5 (clang-1205.0.22.11)

## Project structure
1. **src**: All the source code related to the project lies within this directory. There are four directories:

    - **Header-Only**: It is a header-only library to be consumed by others internally and with no external dependency.
    - **StaticLib**: This is the `STATIC` library which consumes the header-only library.
    - **DynamicLib**: This is the `SHARED` library which consumes the static and header-only libraries internally (w/o using find_package() command).
    - **Client**: This is the executable which consumes all above mentioned libraries.

Please read [Libraries in CMake](doc/libraries_in_cmake.md) section for detailed explanation of how libraries can be defined and consumed in CMake.

> NOTE: Please do not bother with class names and the logic. The purpose of this project is to reflect cmake usage with library creation and consumption within a project.

2. **tests**: Tests should not be part of the `Source` directory so each library's test code is placed under this directory in order not to pollute `Source` directory and the corresponding `CMakeLists.txt` files within. `GoogleTest` API is selected. I'm also planning to have `Catch2` API soon.

3. **cmake**: In order to keep clean the root `CMakeLists.txt`, the common and global CMake logic is placed here.

4. **scripts**: Some convenience scripts for windows and unix are placed under this directory. They are will be useful in remote builds especially.
## Build

### Windows
`win_build.ps1` script takes care of configuring and building the project. It can determine the running OS and specifies the build directory accordingly. The default architecture is `x64`, default configuration is `Release` and default build directory name is `Build`.

i.e. For Windows OS - x64 the build directory will be defined as `Build/win-x64` and the output will reside under `Build/win-x64/out`

- Clean build will configure and build the whole project from scratch. (Default)

```powershell
  .\win_build.ps1
```

- Build w/o configure
```powershell
.\win_build.ps1 -CleanBuild=$false
```

- Complete syntax
```powershell
.\win_build.ps1 -CleanBuild <true|false> -Configuration <Configuration_of_choice> -BuildDir <Top_Build_Dir_Name> -Platform <x86|x64>
```
### Unix
Run convenience bash shell script `unix_build.sh` for configuration and building.
```bash
# Configure and build in Debug
./unix_build.sh -l

# Build in Debug
./unix_build.sh

# Build in Release
./unix_build.sh -c Release

# Configure and build in Release
./unix_build.sh -c Release -l
```
## Testing
`GoogleTest` API is used for testing purposes. The recommended way of consuming `GoogleTest` API is running `ExternalProject_Add` as provided.

**Navigate to the build directory(out/build/ for this repo) (Not to <Configuration> subdir)** and run the following command:
```bash
ctest -C <configuration> --verbose
```
> You don't need to run `cmake --install` command to be able to run the `ctest` command.

> VS Code: Run `CMake: Run Test` task. Since the settings file already have the build dir defined, it will run the tests properly w/o any additional setup.

> For updated `GoogleTest` setup, you can refer this [link](https://google.github.io/googletest/quickstart-cmake.html)
### References
- [GoogleTest](https://cliutils.gitlab.io/modern-cmake/chapters/testing/googletest.html)
## Third-party dependencies (External)
These are the dependencies which are external to this repo and/or created by other library authors. See [Third-Party Dependencies in CMake](doc/DependenciesCMake.md) section for details. Currently, no third-party dependecy is studied under this repo.

## Install
CMake provides a cli command and/or arguments to install generated binary tree to a specified location.

You can install the binary tree in various ways. One can choose one of two methods presented here.
1. Configure stage
```bash
# Configure first
cmake -S src -B build -DCMAKE_INSTALL_PREFIX=%INSTALLDIR%
# or
cmake -S src -B build --install-prefix=$install_dir

# Install (No need to provide it here)
cmake --install build
```
2. Install stage
```bash
cmake --install build --prefix=$install_dir
```
## Packaging
Running the following commands will pack the output as a whole. None of the libraries will be packaged.

Navigate to the build tree and run:
```cmd
cd .\Build\win-x64\
cpack -G <Package_Generator> -C <Configuration> -B <Destitnation_DirName_For_Packaging> -P <Project_Name> -D CPACK_MONOLITHIC_INSTALL=1 --verbose
```

i.e.
```cmd
cd .\Build\win-x64\
cpack -G ZIP -C Release -B packaging -P BcStatic -D CPACK_MONOLITHIC_INSTALL=1 --verbose
```

## [Miscellaneous Topics](doc/Misc.md)
- Using <_d> suffix for Debug config
- Linking targets based on configurations
- Using git submodules for open-source package management
- _WIN32 vs _MSC_VER Predefined Macros
- CMAKE_MODULE_PATH argument
## [Package Management](doc/PackageManagement.md)
## [Useful Links](doc/Links.md)

