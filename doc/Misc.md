# Miscellaneous

- [Using <_d> suffix for Debug config](#Using-<_d>-suffix-for-Debug-config)
- [Linking targets based on configurations](#Linking-targets-based-on-configurations)
- [Using `git submodules` for open-source package management](#Using-`gitsubmodules`-for-opensource-package-management)
- [_WIN32 vs _MSC_VER Predefined Macros](#_WIN32-vs-_MSC_VER-Predefined-Macros)
- [CMAKE_MODULE_PATH argument should be passed as an absolute path](#CMAKE_MODULE_PATH-argument-should-be-passed-as-an-absolute-path)
- [RPATH Handling](#RPATH-Handling)
- [TARGET_FILE Generator expression](#TARGET_FILE-Generator-expression)
- [Copy files&directory after build before install](#Copy-files&directory-after-build-before-install)
- [Linking Windows DLL during CMake after build before install](#Linking-Windows-DLL-during-CMake-after-build-before-install)
- [`find_package()` usage](#`find_package()`-usage)
- [Installation of public & private headers](#installation-of-public-&-private-headers)
- [Custom CMake functions](#Custom-CMake-functions)
- [CMake install for presets](#CMake-install-for-presets)
- [Target architecture definition](#Target-architecture-definition)

## Using <_d> suffix for Debug config
In order to append "_d" suffix for the targets based on configurations, use the
following command:
```cmake
set(CMAKE_DEBUG_POSTFIX "_d")
```
Define this command within root level CMakeLists.txt to make this setting global.

> Configuration based suffix does not work for executables. Some tricks have to be made.
- [Ref](https://stackoverflow.com/questions/49672264/cmake-add-d-suffix-for-debug-build-of-static-library)

## Linking targets based on configurations
Based on the active configuration, you can link your project to targets based on configuration.
`debug` and `optimized` keywords should be used before the target name
```cmake
# Sample 1
target_link_libraries(
    ${PROJECT_NAME} 
    PRIVATE debug debug_lib1 debug_lib2 debug_lib3
    PRIVATE optimized rel_lib1 rel_lib2 rel_lib3
)
# Sample 2
target_link_libraries ( ${PROJECT_NAME}
    debug ${Boost_FILESYSTEM_LIBRARY_DEBUG}
    optimized ${Boost_FILESYSTEM_LIBRARY_RELEASE} )

target_link_libraries ( ${PROJECT_NAME}
    debug ${Boost_LOG_LIBRARY_DEBUG}
    optimized ${Boost_LOG_LIBRARY_RELEASE} )

target_link_libraries ( ${PROJECT_NAME}
    debug ${Boost_PROGRAM_OPTIONS_LIBRARY_DEBUG}
    optimized ${Boost_PROGRAM_OPTIONS_LIBRARY_RELEASE} )
```

- [Ref](https://stackoverflow.com/questions/2209929/linking-different-libraries-for-debug-and-release-builds-in-cmake-on-windows)

## Using `git submodules` for opensource package management
You can use `git submodules` to bring external dependencies to your current project. If the repo has cmake support, you only need to add the target (link) to your projects i.e. GLFW. However, if the external repo has NO cmake setup available i.e. imgui, some additional setup has to be made to be consumed by other cmake targets.

Steps:
- Generate .gitmodules in the root directory:
```gitmodules
[submodule "src/external/glfw"]
	path = src/external/glfw
	url = https://github.com/glfw/glfw.git
```
- Run `git submodules` command.

To trigger `git submodules` command from cmake:

```cmake
# Make sure git is installed in the system so one can use git submodules
# To make the submodules download when running the cmake
find_package(Git QUIET)
if(GIT_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.git")
    # Update submodules as needed
    option(GIT_SUBMODULE "Check submodules during build" ON)
    if(GIT_SUBMODULE)
        message(STATUS "Submodule update")
        execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive
                        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                        RESULT_VARIABLE GIT_SUBMOD_RESULT)
        if(NOT GIT_SUBMOD_RESULT EQUAL "0")
            message(FATAL_ERROR "git submodule update --init failed with ${GIT_SUBMOD_RESULT}, please checkout submodules")
        endif()
    endif()
endif()
```
If you navigate to submodule dir and run `git status`, you have to see the status for the submodule repo, NOT the main repo.

> `git submodules` by default, detached to HEAD state of the repository. If you want to detach for a specific commit or tag, you have navigate to the submodule directory and checkout the specific commit/tag. [link](https://stackoverflow.com/questions/10914022/how-do-i-check-out-a-specific-version-of-a-submodule-using-git-submodule)

## _WIN32 vs _MSC_VER Predefined Macros
As stated in the [reference](https://github.com/osmcode/libosmium/issues/224#issuecomment-323811903):

> Well, there is no right or wrong. Both are correct - each for their purpose.

- `_WIN32` is for generally checking if the app is built for/on Windows.
- `_MSC_VER` is specifically targeted towards the Microsoft compiler (aka Visual Studio or C++ Build Tools) and checking the version thereof as each version might have different bugs aehm features 😏
```txt
MSVC++ 4.x  _MSC_VER == 1000
MSVC++ 5.0  _MSC_VER == 1100
MSVC++ 6.0  _MSC_VER == 1200
MSVC++ 7.0  _MSC_VER == 1300
MSVC++ 7.1  _MSC_VER == 1310 (Visual Studio 2003)
MSVC++ 8.0  _MSC_VER == 1400 (Visual Studio 2005)
MSVC++ 9.0  _MSC_VER == 1500 (Visual Studio 2008)
MSVC++ 10.0 _MSC_VER == 1600 (Visual Studio 2010)
MSVC++ 11.0 _MSC_VER == 1700 (Visual Studio 2012)
MSVC++ 12.0 _MSC_VER == 1800 (Visual Studio 2013)
MSVC++ 14.0 _MSC_VER == 1900 (Visual Studio 2015)
MSVC++ 14.1 _MSC_VER == 1910 (Visual Studio 2017)
```

## CMAKE_MODULE_PATH argument should be passed as an absolute path
When passing a value for argument `CMAKE_MODULE_PATH` through CMake CLI, make sure it is absolute (full) path.

```bash
conan install ./src/conan/conanfile.txt --profile ./src/conan/conanprofile.txt -if conan
cmake ./src -B ./src/build -DCMAKE_MODULE_PATH=$PWD/conan
```

## RPATH Handling
- [CMake RPATH handling](https://gitlab.kitware.com/cmake/community/-/wikis/doc/cmake/RPATH-handling)
- [Why is CMake designed so that it removes runtime path when installing](https://stackoverflow.com/questions/32469953/why-is-cmake-designed-so-that-it-removes-runtime-path-when-installing)

## TARGET_FILE Generator expression
- [CMake TARGET_FILE Docs](https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html#genex:TARGET_FILE)
- [CMake TARGET_FILE generator expression](https://www.scivision.dev/cmake-genex-target-file/)

## Copy files&directory after build before install
- [How to copy contents of a directory into build directory after make with CMake?](https://stackoverflow.com/questions/13429656/how-to-copy-contents-of-a-directory-into-build-directory-after-make-with-cmake)
- [Installing additional files with CMake](https://stackoverflow.com/a/15696080)

## Linking Windows DLL during CMake after build before install
Unless otherwise stated, Windows OS searches for a [dependent DLL in the load time](https://learn.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-search-order) and the first location it looks for is the same directory of the running executable. Keeping this fact in mind that, when you try to link a shared library to an executable within CMake, you have to explicitly adjust the search paths for the CMake post-build.

> NOTE: If you try to run the executable CMake target without adjusting the search path, the run will fail.
> NOTE: The belowmentioned methods are NOT related to or part of CMake `install` process. As long as, you adjust the install locations properly for executables and their dependent shared libs, it will work fine. 

There are several ways to do so:
1. Copying the dependent shared library binaries as a `POST_BUILD` operation using `add_custom_command` and [`copy_directory` or `copy_if_different` or `copy`](https://cmake.org/cmake/help/latest/manual/cmake.1.html#cmdoption-cmake-E-arg-copy).

```cmake

# Define dependent shared libraries
set(_SHARED_LIBS)
list(APPEND _SHARED_LIBS bc_dynamic)

target_link_libraries(
    ${PROJECT_NAME} 
    PRIVATE ${_SHARED_LIBS} bc_header_only bc_static
)

# copy the .dll file to the same folder as the executable
if(WIN32) 
    foreach(shared_lib ${_SHARED_LIBS})
        message("Copying dependent ${shared_lib} binary for ${PROJECT_NAME}...")
        add_custom_command(
            TARGET ${PROJECT_NAME}
            POST_BUILD
            COMMAND
                ${CMAKE_COMMAND} -E copy_directory
                $<TARGET_FILE_DIR:${shared_lib}>
                $<TARGET_FILE_DIR:${PROJECT_NAME}>
            VERBATIM
        )
    endforeach()
endif()

```
- References
    - [cmake-examples github repo](https://github.com/pr0g/cmake-examples/tree/main/examples/core/shared)
    - [SDL2d.dll not found when building with cmake](https://github.com/libsdl-org/SDL/issues/6399)
    - [How to copy DLL files into the same folder as the executable using CMake?](https://stackoverflow.com/questions/10671916/how-to-copy-dll-files-into-the-same-folder-as-the-executable-using-cmake)
    - 
2. Define the shared library as `IMPORTED` target.

- References
    - [Importing and Exporting Guide](https://cmake.org/cmake/help/latest/guide/importing-exporting/index.html)

## `find_package()` usage
In order to arrange dependencies between projects within the same build root, there is no need to use `find_package()`, `find_library()` etc. However, if one wants to consume an out-of-build (external) cmake project other than using package managers, several steps should be taken.

> It is always advised to use `GNUInstallDirs` CMake module.

1. The library (to-be consumed) CMake project has to define `export` properties using `install` command.
    - The .config file has to be written to a location and that location should be passed to consumer build root using `CMAKE_PREFIX_PATH`.
    ```cmake
    include(GNUInstallDirs)
    # If no destination is provided, default locations are used.
    # https://cmake.org/cmake/help/v3.25/command/install.html#installing-targets
    install(
        TARGETS ${PROJECT_NAME}
        EXPORT ${PROJECT_NAME}-config
    )
    # Write config 
    install(
        EXPORT ${PROJECT_NAME}-config
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
    )
    # OPTIONAL: IF you want to copy headers
    install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
    ```
    - This location is basically the `CMAKE_INSTALL_PREFIX` of the to-be-consumed library.
    
    ```bash
    #!/bin/bash
    cmake -B build/debug -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=install
    ```
2. The consumer CMake build root should be configured by passing `-DCMAKE_PREFIX_PATH` with the value from the previous step.
    - Configure
    ```bash
    cmake -B build/debug -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_PREFIX_PATH=$(pwd)/../library/install
    ```
    - The consumer projects within the build root, now can use `find_package()`
    ```cmake
    #....
    find_package(calculator-static REQUIRED CONFIG)
    target_link_libraries(${PROJECT_NAME} PRIVATE the_lib)
    ```
3. `find_package()` with config mode will execute a search under `CMAKE_PREFIX_PATH` with a [procedure](https://cmake.org/cmake/help/latest/command/find_package.html#config-mode-search-procedure) for the file `<lowercasePackageName>-config.cmake`.

4. If one wants to use `MODULE` mode for `find_package()`, it will execute search under `CMAKE_MODULE_PATH` for the file `Find<PackageName>.cmake`.
    - Package managers (`conan`) usually handles this by implicitly.
### References
- [cmake examples](https://github.com/pr0g/cmake-examples/tree/main/examples/core)

## Installation of public & private headers
1. Using `target_sources` with `FILE_SET` of type `HEADERS` 
```cmake
# target_include_directories() definition is NOT required (except header only libs)

add_library(${PROJECT_NAME} STATIC "")

target_sources(
    ${_LOGGING_PROJECT} 
    PRIVATE
        logging/logger.cpp
    PUBLIC
        FILE_SET ${_LOGGING_PROJECT}_header_files 
        TYPE HEADERS
        BASE_DIRS logging/include
        FILES
            logging/include/core/logger.h
# NOT TESTED
    PRIVATE
        FILE_SET private_header_files 
        TYPE HEADERS
        BASE_DIRS logging
        FILES
            logging/impl.h
)

# Make sure you pass FILE_SET to install(TARGET) command
# File sets are defined by the target_sources(FILE_SET) command. 
# If the file set <set> exists and is PUBLIC or INTERFACE, any files in the set are installed under the destination
include(GNUInstallDirs)
install(
    TARGETS ${_LOGGING_PROJECT}
    EXPORT ${_LOGGING_PROJECT}Targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    FILE_SET ${_LOGGING_PROJECT}_header_files DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
```
2. Using `install(DIRECTORY)` or `install(FILES)` command
```cmake
target_include_directories(
    ${PROJECT_NAME}
    PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include> # or ${PROJECT_SOURCE_DIR}/include
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}> # or include
)

# Only define .cpp and private header files here
target_sources(${PROJECT_NAME} 
                    PRIVATE 
                        mylib.cpp
                        impl.h
)

# Only expose public header files
include(GNUInstallDirs)
install(
    TARGETS ${PROJECT_NAME}
    EXPORT ${PROJECT_NAME}Targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(
    DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
```

3. Using `PUBLIC_HEADERS` and `PRIVATE_HEADERS` target property. (This feature is mostly used for MacOS amd iOS)
```cmake
# Set the target property
set_target_properties(
    ${PROJECT_NAME} 
    PROPERTIES
    PUBLIC_HEADER "include/static/mylib.h"
)

# Pass it over to install
include(GNUInstallDirs)
install(
    TARGETS ${PROJECT_NAME}
    EXPORT ${PROJECT_NAME}Targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
```
> The problem with this approach is that `PUBLIC_HEADER` output artifact for `install(TARGETS)` command can NOT keep the nested include directory structure so for this example, `mylib.h` file will sit directly under `include` dir in the installation.
### References
- [Installing headers the modern way, regurgitated and revisited](https://discourse.cmake.org/t/installing-headers-the-modern-way-regurgitated-and-revisited/3238/4)

## Custom CMake functions
CMake provides custom scripting using `function` and `macro` mechanisms. The better approach is to place common functionality in `.cmake` files and make them available through `include()` command.
1. Make sure the `.cmake` file's dir location is registered through `CMAKE_MODULE_PATH`.
```cmake
# Update CMAKE_MODULE_PATH in the root CMakeLists.txt
# Option1:
set( CUSTOM_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake" )
set( CMAKE_MODULE_PATH ${CUSTOM_MODULE_PATH} ${CMAKE_MODULE_PATH} )

# Option2: Use list 
if(NOT CMAKE_MODULE_PATH)
    set(CMAKE_MODULE_PATH)
endif()
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
```
> Do NOT directly set `CMAKE_MODULE_PATH` and `CMAKE_FIND_ROOT_PATH` using `set(CMAKE_MODULE_PATH <some_path>)`
2. Define the functions/macros in `.cmake` files
```cmake
function(bc_header_only_library TARGET_NAME)
    # TARGET_NAME argument is the required argument
    # Arg definitions
    # boolean flag arguments with no value
    set(flags)
    # Single-valued arguments
    set(args BASE_DIR)
    # Multiple-valued(list) arguments
    set(listArgs DEP_TARGETS DEFINES)
    cmake_parse_arguments(arg "${flags}" "${args}" "${listArgs}" ${ARGN})
    # check target_definitions.cmake file for details
    # ...
endfunction()
```
3. Make it available via `include(target_definitions)`
4. Usage in any other `CMakeLists.txt` file.
```cmake
set(_header_files)
list(APPEND _header_files 
            header_only/print_utils.h
)

bc_header_only_library_file_set(${PROJECT_NAME} #-->TARGET_NAME
                                BASE_DIR include
                                PUBLIC_HEADERS ${_header_files}
)
```

## CMake install for presets
CMake does NOT provide any preset capability for install operations as of now. If you're using CMake presets and want to carry out install command, try one of the following.

1. `cmake --build --preset win_debug --target install`. (Preferred) 
    - To install w/o building:
    ```cmake
    set(CMAKE_SKIP_INSTALL_ALL_DEPENDENCY ON)
    ```

2. Defining custom target that refers to generate `cmake_install.cmake` file. (Only works for Release.)
```cmake
add_custom_target(INSTALL_TARGETS
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_BINARY_DIR}/cmake_install.cmake
)
set_target_properties(INSTALL_TARGETS PROPERTIES EXCLUDE_FROM_ALL TRUE)
```
Then, call `cmake --build --preset win_release --target INSTALL_TARGETS`. Again, even if you had sucessfull Debug build, this call will result in error.

3. This option requires the user explicitly pass hardcoded `CMAKE_BINARY_DIR` location to the command so not really preferred. However, it is still working.
```bash
cmake --install out/build/msvc --config Debug 
```

### References
- [presets: Add install presets for `cmake --install --preset](https://gitlab.kitware.com/cmake/cmake/-/issues/24875)
- [CMAKE_SKIP_INSTALL_ALL_DEPENDENCY - CMake Documentation](https://cmake.org/cmake/help/v3.26/variable/CMAKE_SKIP_INSTALL_ALL_DEPENDENCY.html)

## Target architecture definition
The architecture definition for target platforms in CMake is not very well documented. There are some solutions scattered around the web but no one explains it clearly. This is my clear and concise attempt to do so:
> This topic has nothing to do with cross compiling.
### Some CMake variables:
- `CMAKE_HOST_SYSTEM_NAME` – name of the platform, on which CMake is running (host platform). On major operating systems this is set to the Linux, Windows or Darwin (MacOS) value.

- `CMAKE_SYSTEM_NAME` – name of the platform, for which we are building (target platform). By default, this value is the same as CMAKE_HOST_SYSTEM_NAME, which means that we are building for local platform (no cross-compilation).

- `CMAKE_HOST_SYSTEM_PROCESSOR`: The name of the CPU CMake is running on.

- `CMAKE_SYSTEM_PROCESSOR`: When not cross-compiling, this variable has the same value as the CMAKE_HOST_SYSTEM_PROCESSOR variable. In many cases, this will correspond to the target architecture for the build, but this is not guaranteed. (E.g. on Windows, the host may be AMD64 even when using a MSVC cl compiler with a 32-bit target.)

### Windows:
Defining the target architecture is only available when `CMAKE_GENERATOR_PLATFORM` is defined. I typically use `Visual Studio Generators` for Windows builds. Use one of the following:
1. CMakePresets.json `architecture` field under `configurePresets` section.
```json
{
    "name": "msvc",
    "displayName": "msvc config",
    "generator": "Visual Studio 16 2019",
    "architecture": {
        "value": "x64",
        "strategy": "set"
    },
    "hidden": false,
    "binaryDir": "${sourceDir}/out/build/${presetName}",
    "installDir": "${sourceDir}/out/install/${presetName}",
    "condition": {
        "type": "equals",
        "lhs": "${hostSystemName}",
        "rhs": "Windows"
    }
}
```
2. CMake CLI by passing target platform value to `A` argument. 
```bash
cmake -G "Visual Studio 16 2019" -A Win32
cmake -G "Visual Studio 16 2019" -A x64
cmake -G "Visual Studio 16 2019" -A ARM
cmake -G "Visual Studio 16 2019" -A ARM64
```
#### References
- [Documentation - CMAKE_GENERATOR_PLATFORM](https://cmake.org/cmake/help/v3.30/variable/CMAKE_GENERATOR_PLATFORM.html#variable:CMAKE_GENERATOR_PLATFORM)
- [VSCode-cmake-tools doc - Select your compilers](https://github.com/microsoft/vscode-cmake-tools/blob/main/docs/cmake-presets.md#select-your-compilers)
- [How to cross-compile for embedded with CMake like a champ](https://kubasejdak.com/how-to-cross-compile-for-embedded-with-cmake-like-a-champ)

### Linux - Ubuntu:
- Some commands to get cpu (arch) info
```bash
uname -m
uname -p
lscpu
cat /proc/cpuinfo
```
### MacOS [TODO]:
### References
- [Github-dotnet/runtime -> Some definition samples](https://github.com/dotnet/runtime/blob/main/src/mono/CMakeLists.txt)
- [What are the possible values of CMAKE_SYSTEM_PROCESSOR?](https://stackoverflow.com/questions/70475665/what-are-the-possible-values-of-cmake-system-processor)