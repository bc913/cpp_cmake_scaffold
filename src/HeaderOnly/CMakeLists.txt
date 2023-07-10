# Header-Only library definitions
cmake_minimum_required(VERSION 3.17.3 FATAL_ERROR)
project(bc_header_only VERSION ${CMAKE_PROJECT_VERSION} LANGUAGES CXX)

##
## TARGET
##
add_library(${PROJECT_NAME} INTERFACE)

# Consumer targets can access to header-only library header files as 
# #include <bcheaderonly/Utilities.h>
# make sure install(GNUInstallDirs)
target_include_directories(
    ${PROJECT_NAME}
    INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include> # or ${PROJECT_SOURCE_DIR}/include
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}> # or include
)

target_compile_definitions(
    ${PROJECT_NAME}
    INTERFACE 
    HEADER_ONLY_LIB_DEF="This is bc_header_only lib definition"
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

# # Make target importable from the install directory
# install(
#     EXPORT
#     ${PROJECT_NAME}Targets
#     FILE ${PROJECT_NAME}Targets.cmake
#     DESTINATION ${CMAKE_CONFIG_INSTALL_DIR}
# )

# ##
# ## BUILD TREE
# ##
# export(
#     EXPORT ${PROJECT_NAME}Targets 
#     FILE ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Targets.cmake
# )