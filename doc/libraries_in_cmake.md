# Libraries in CMake

Static, Shared and header-only libraries can be defined and consumed in various ways.

1. **Consume through `add_subdirectory()`**: If the libraries and the consumers are the part of the same repo, the libraries can be consumed w/o packaging or `find_package()` command.

    - Consume as an implementation detail: The target and its exported names are the part of the implementation detail for the consumer target. They are consumed in .cpp files and not exposed through the consumer's interface (headers).
    
    - Consume as part of the API: The client should link to the library as `PUBLIC` so the library's API can be exposed as part of the consumer's API.

2. **Consume using `find_package()` or `find_dependency()`**:
> This section is still not totally grasped so a dedicated section will be provided.

3. **Consume through exporting**: Consume the libraries (targets) through exporting and packaging. 
This requires some additional steps to be defined in the target's CMakeLists file. 
This part is not covered for this repository yet. 
See [**Exporting and Packaging Libraries**](ExportingLibraries.md) for details. 

## Header-Only
### Definition
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

### Consume as an implementation detail 
```cmake
# i.e. StaticLib/CMakeLists.txt

# Link to header-only target
target_link_libraries(${PROJECT_NAME} PRIVATE bc_header_only)

```

## Static Library
### Definition
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

### Consume as an implementation detail
```cmake
#(DynamicLib/CMakeLists.txt)

# Link static library as PRIVATE so any target that links against this (bcdynamic) target does not need to link against bc_static
target_link_libraries(${This} PRIVATE bc_static)

```

## Shared Library
### Definition
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

### Consume as an implementation detail
```cmake
# Client/CMakeLists.txt
target_link_libraries(
    ${PROJECT_NAME} 
    PRIVATE bc_header_only bc_static bc_dynamic
)
```
