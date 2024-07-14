# CMake - Cpp Scaffold Project
## Introduction
An example scaffold Cpp repo for CMake build system. The purpose is to give some insights on how to structure big projects with internal and/or external dependencies. There are several examples on the web how to create libraries (static/shared/header-only) alone but I couldn't find a good and clean explanation on how to create/consume libraries internally in a big cpp project so I provide this repo.

## Requirements
- CMake (> 3.17)
- Powershell (Windows)
- Bash (Unix)
- NSIS (If packaging with NSIS is chosen)
- VSCode (highly recommended)

### How to install CMake to Docker containers?
- Linux (Ubuntu image)
1. Default way (brings up the latest version available in package manager, NOT the latest CMake version)
```dockerfile
FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
  cmake
```
2. Custom version
```dockerfile
FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
  wget

RUN wget https://github.com/Kitware/CMake/releases/download/v3.25.3/cmake-3.25.3-Linux-x86_64.sh \
      -q -O /tmp/cmake-install.sh \
      && chmod u+x /tmp/cmake-install.sh \
      && mkdir /opt/cmake-3.25.3 \
      && /tmp/cmake-install.sh --skip-license --prefix=/opt/cmake-3.25.3 \
      && rm /tmp/cmake-install.sh \
      && ln -s /opt/cmake-3.25.3/bin/* /usr/local/bin
```
#### References:
- [Docker/Ubuntu: Installing the latest cmake on Docker Image](https://www.softwarepronto.com/2022/09/dockerubuntu-installing-latest-cmake-on.html)
- [Ubuntu: Upgrade to the latest cmake](https://www.softwarepronto.com/2022/09/ubuntu-upgrade-to-latest-cmake.html)
- [How to install cmake 3.2 on Ubuntu](https://askubuntu.com/questions/610291/how-to-install-cmake-3-2-on-ubuntu)

## Tested Systems
- Windows w/ MSVC
- Ubuntu 22.04 w/ gcc-11 and g++-11
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

## VS Code integration
I prefer using `CMakePresets` for development with VSCode since it eases the in advance setup. With the `CMake Tools` VS Code extension installed and few VSCode settings, CMake works smoothly using the UI without the need of manipulating VS Code files such as `launch.json` and `tasks.json`.

```json
{
    "cmake.useCMakePresets": "always",
    "cmake.buildBeforeRun": false,
    "cmake.configureOnEdit": false,
    "cmake.configureOnOpen": false,
}
```

If you are using `CMake Tools` Visual Studio extension, you don't need to define/use `c_cpp_properties.json` file under `.vscode` directory.


## Development using CMake
There are several ways to configure, build, test and package the repositories using CMake CLI or GUI. I will present methods here using CLI w and w/o `CMake Presets`

> In order to use `CMake Presets`, generate `CMakePresets.json` in the root directory.

### Configure
The basic syntax for CMake configuration:
```bash
# w/o presets
cmake -S <root_dir> -B <build_output_dir> -G <Generator_name> -DCMAKE_<VARIABLE>=<VALUE>  
# w presets
cmake --preset <config_preset_name>
```

Navigate to root directory where root CMakeLists.txt is sitting.
```bash
# w/o presets
# Windows
cmake -S . -B build -G "Visual Studio 16 2019" -DCMAKE_INSTALL_PREFIX=install
# Linux
cmake -S . -B build -G "Ninja Multi-Config" -DCMAKE_INSTALL_PREFIX=install

# w presets
## Windows
cmake --preset msvc
## Linux
cmake --preset ninja_lnx
```
> The generators used here are based on `multi-config` so you don't have to configure for each build type (configuration) (i.e. Debug, Release). 
### Build
Basic syntax:
```bash
# Navigate to root dir
# w/o presets
cmake --build <build_output_dir> --config <config_type>
# w presets
cmake --build --preset <build_preset>
```
Example:
```bash
# w/o presets
cmake --build build --config Release
# w presets
cmake --build --preset win_debug 
```

<details>
  <summary>[OPTIONAL] Build using convenience scripts</summary>
  
  #### Windows

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
  
  #### Unix

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

</details>

### Testing
Several third-party testing frameworks are available in the open source world such as [`googletest`](https://github.com/google/googletest), [`catch`](https://github.com/catchorg/Catch2/blob/devel/docs/cmake-integration.md#top) and [`boostTest`](https://www.boost.org/doc/libs/1_83_0/libs/test/doc/html/index.html)

These frameworks can be integrated into the consumer repos using different methods within CMake i.e. `ExternalProject_Add` or `FetchContent` modules. `GoogleTest` is selected as third-party testing framework and integrated using `FetchContent` module. [[GoogleTest CMake integration]](https://google.github.io/googletest/quickstart-cmake.html)

```bash
# w/o preset
# Navigate to the build directory(out/build/ for this repo) (Not to <Configuration> subdir)
ctest -C <configuration> --verbose
# w preset
# No need to navigate to build dir. Run this command on the root.
ctest --preset <test_preset_name>
```
> You don't need to run `cmake --install` command to be able to run the `ctest` command.

> VS Code: Run `CMake: Run Test` task. Since the settings file already have the build dir defined, it will run the tests properly w/o any additional setup.

> Other types of setups for [GoogleTest](https://cliutils.gitlab.io/modern-cmake/chapters/testing/googletest.html)

### Install
CMake provides a cli command and/or arguments to install generated binary tree to a specified location. You can install the binary tree in various ways. One can choose one of two methods presented here.
> There is NO `preset` way of doing installation.
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

### Packaging
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

## Third-party dependencies (External)
These are the dependencies which are external to this repo and/or created by other library authors. See [Third-Party Dependencies in CMake](doc/DependenciesCMake.md) section for details. Currently, no third-party dependecy is studied under this repo.


## [Miscellaneous Topics](doc/Misc.md)
- Using <_d> suffix for Debug config
- Linking targets based on configurations
- Using git submodules for open-source package management
- _WIN32 vs _MSC_VER Predefined Macros
- CMAKE_MODULE_PATH argument should be passed as an absolute path
- RPATH Handling
- TARGET_FILE generator expression
- Copy files&directory after build before install
- Linking Windows DLL during CMake after build before install
- `find_package()` usage
- Installation of public & private headers
- Custom CMake functions
- CMake install for presets

## [Package Management](doc/PackageManagement.md)
- [Conan](doc/package_managers/conan.md)

## Build Tools
- [Ninja](doc/build_tools/ninja.md)

## [Useful Links](doc/Links.md)
## [Generator Expressions](doc/GeneratorExpressions.md)

## Installers
- [NSIS - Windows](https://nsis.sourceforge.io/Main_Page)
- [Inno Setup](https://jrsoftware.org/isinfo.php)

