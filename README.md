# CMake - Cpp Scaffold Project
## Introduction
An example scaffold Cpp repo for CMake build system. The purpose is to give some insights on how to structure big projects with internal and/or external dependencies. There are several examples on the web how to create libraries (static/shared/header-only) alone but I couldn't find a good and clean explanation on how to create/consume libraries internally in a big cpp project so I provide this repo.

## Requirements
- CMake (> 3.17)
- Powershell
- NSIS (If packaging with NSIS is chosen)

## Tested Systems
- Windows

## Third-party dependencies (External)
These are the dependencies which are external to this repo and/or created by other library authors. See [Third-Party Dependencies in CMake](doc/DependenciesCMake.md) section for details. Currently, no third-party dependecy is studied under this repo.

## Build
`BuildProject.ps1` script takes care of configuring and building the project. It can determine the running OS and specifies the build directory accordingly. The default architecture is `x64`, default configuration is `Release` and default build directory name is `Build`.

i.e. For Windows OS - x64 the build directory will be defined as `Build/win-x64` and the output will reside under `Build/win-x64/out`

- Clean build will configure and build the whole project from scratch. (Default)

```powershell
  .\BuildProject.ps1
```

- Build w/o configure
```powershell
.\BuildProject.ps1 -CleanBuild=$false
```

- Complete syntax
```powershell
.\BuildProject.ps1 -CleanBuild <true|false> -Configuration <Configuration_of_choice> -BuildDir <Top_Build_Dir_Name> -Platform <x86|x64>
```

## Project structure
1. **Source**: All the source code related to the project lies within this directory. There are four directories:

- **Header-Only**: It is a header-only library to be consumed by others internally and with no external dependency.
- **StaticLib**: This is the `STATIC` library which consumes the header-only library.
- **DynamicLib**: This is the `SHARED` library which consumes the static and header-only libraries internally (w/o using find_package() command).
- **Client**: This is the executable which consumes all above mentioned libraries.

> NOTE: Please do not bother with class names and the logic. The purpose of this project is to reflect cmake usage with library creation and consumption within a project.

2. **Tests**: Tests should not be part of the `Source` directory so each library's test code is placed under this directory in order not to pollute `Source` directory and the corresponding `CMakeLists.txt` files within. `GoogleTest` API is selected. I'm also planning to have `Catch2` API soon.

3. **CMake**: In order to keep clean the root `CMakeLists.txt`, the common and global CMake logic is placed here.

## Libraries with CMake
Static, Shared and header-only libraries can be defined and consumed in various ways.

1. **Consume through `add_subdirectory()`**: If the libraries and the consumers are the part of the same repo, the libraries can be consumed w/o packaging or `find_package()` command.

- Consume as an implementation detail: The target and its exported names are the part of the implementation detail for the consumer target. They are consumed in .cpp files and not exposed through the consumer's interface (headers).
- Consume as part of the API: The client should link to the library as `PUBLIC` so the library's API can be exposed as part of the consumer's API.

2. **Consume through `find_package()` or `find_dependency()`**:
> This section is still not totally grasped so a dedicated section will be provided.

3. **Consume through exporting**: Consume the libraries (targets) through exporting and packaging. This requires some additional steps to be defined in the target's CMakeLists file. This part is not covered for this repository yet. See [**Exporting and Packaging Libraries**](doc/ExportingLibraries.md) for details. 

### Header-Only
#### Definition
```cmake
# HeaderOnly/CMakeLists.txt
project(bc_header_only VERSION ${CMAKE_PROJECT_VERSION} LANGUAGES CXX)

# Library definition
add_library(${PROJECT_NAME} INTERFACE)

# Consumer targets can access to header-only library header files as 
# #include <bcheaderonly/sort.h>
target_include_directories(
    ${PROJECT_NAME}
    INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include> # or ${PROJECT_SOURCE_DIR}/include
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}> # or include
)
```
Notes: 
- `target_compile_definitions(<target_name> INTERFACE)` only supported for Imported targets.
- `target_sources(<target_name> INTERFACE)` is only supported for Imported targets.

#### Consume as an implementation detail 
```cmake
# i.e. StaticLib/CMakeLists.txt

# Link to header-only target
target_link_libraries(${PROJECT_NAME} PRIVATE bc_header_only)

```

### Static Library
#### Definition
```cmake
project(bc_static VERSION ${CMAKE_PROJECT_VERSION} LANGUAGES CXX)

# target_sources() must be used if the sources are blank
add_library(${PROJECT_NAME} STATIC "")

# Source for the projects
target_sources(
    ${PROJECT_NAME} 
    PRIVATE
        array_algs.cpp
)

# PUBLIC: specified include directory(s) is required for this target and the consumers.
target_include_directories(
    ${PROJECT_NAME}
    PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include> # or ${PROJECT_SOURCE_DIR}/include
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}> # or include
)

# Preproccessor definitions
# Whoever consumes or links to this library will have this preprocessor definition since it is PUBLIC
# PUBLIC: Definition is available to this target and its consumers
# INTERFACE: Definition is only available to the consumer.
# PRIVATE: Definition is only available to this target.

target_compile_definitions(${PROJECT_NAME} PUBLIC STATICLIBCONSTANT=4)
target_compile_definitions(
    ${PROJECT_NAME} 
    INTERFACE 
    STATIC_LIB_DEF="This is static lib definition"
)

# Link header-only file
target_link_libraries(
    ${PROJECT_NAME} 
    PRIVATE bc_header_only
)

```

#### Consume as an implementation detail
```cmake
#(DynamicLib/CMakeLists.txt)

# Link static library as PRIVATE so any target that links against this (bcdynamic) target does not need to link against bc_static
target_link_libraries(${This} PRIVATE bc_static)

```

### Shared Library
#### Definition
```cmake
# DynamicLib
project(bc_dynamic VERSION ${CMAKE_PROJECT_VERSION} LANGUAGES CXX)

# target_sources() must be used if the sources are blank
add_library(${PROJECT_NAME} SHARED "")

# Source for the projects
target_sources(${PROJECT_NAME} 
    PRIVATE
        employee.cpp
)

# Anyone consuming this library will have this public include dir by default
# No need to define INCLUDES in install command unless one wants to have a custom design
target_include_directories(
    ${PROJECT_NAME}
    PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include> # or ${PROJECT_SOURCE_DIR}/include
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}> # or include
)

# Link static library as PRIVATE so any target that links against this (bcdynamic) target does not need to link against BcStatic
target_link_libraries(${PROJECT_NAME} PRIVATE bc_header_only)

# Preproccessor definitions
target_compile_definitions(
    ${PROJECT_NAME} 
    PRIVATE "DYNLIB_EXPORT"
    INTERFACE DYNAMIC_LIB_DEF="This is dynamic lib def"
)
```
Notes:
- `include(GenerateExportHeaders)` didn't work for this repo but it is the recommended way to be used in exporting a shared library.

#### Consume as an implementation detail
```cmake
# Client/CMakeLists.txt
target_link_libraries(
    ${PROJECT_NAME} 
    PRIVATE bc_header_only bc_static bc_dynamic
)
```

## Testing
`GoogleTest` API is used for testing purposes. The recommended way of consuming `GoogleTest` API is running `ExternalProject_Add` as provided.

Navigate to the build tree and run the following command:
```cmd
cd .\Build\win-x64\
ctest -C Release --verbose
```

## Application Packaging
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

## [Useful Links](doc/Links.md)

