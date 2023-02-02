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

