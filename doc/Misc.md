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

