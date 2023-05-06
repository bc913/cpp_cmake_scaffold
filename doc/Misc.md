# Miscellaneous

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

## Using `git submodules` for open-source package management
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

## CMAKE_MODULE_PATH argument should be absolute path
When passing a value for argument `CMAKE_MODULE_PATH` through CMake CLI, make sure it is absolute (full) path.

```bash
conan install ./src/conan/conanfile.txt --profile ./src/conan/conanprofile.txt -if conan
cmake ./src -B ./src/build -DCMAKE_MODULE_PATH=$PWD/conan
```
## RPATH Handling
- [CMake RPATH handling](https://gitlab.kitware.com/cmake/community/-/wikis/doc/cmake/RPATH-handling)
- [Why is CMake designed so that it removes runtime path when installing](https://stackoverflow.com/questions/32469953/why-is-cmake-designed-so-that-it-removes-runtime-path-when-installing)