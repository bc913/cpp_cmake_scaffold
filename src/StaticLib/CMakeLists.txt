# static lib
cmake_minimum_required(VERSION 3.17.3 FATAL_ERROR)
project(bc_static VERSION ${CMAKE_PROJECT_VERSION} LANGUAGES CXX)
include(GNUInstallDirs)

##
## TARGET
##
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
target_compile_definitions(${PROJECT_NAME} PUBLIC STATICLIBCONSTANT=4)
# PUBLIC: Definition is available to this target and its consumers
# INTERFACE: Definition is only available to the consumer.
# PRIVATE: Definition is only available to this target.

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

##
## INSTALL
##
set(CMAKE_CONFIG_INSTALL_DIR "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")

install(
    TARGETS ${PROJECT_NAME}
    EXPORT ${PROJECT_NAME}Targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(
    DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

# Make target importable from the install directory
install(
    EXPORT
    ${PROJECT_NAME}Targets
    FILE ${PROJECT_NAME}Targets.cmake
    DESTINATION ${CMAKE_CONFIG_INSTALL_DIR}
)

##
## BUILD TREE
##
export(
    EXPORT ${PROJECT_NAME}Targets 
    FILE ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Targets.cmake
)