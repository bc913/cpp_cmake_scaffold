project(bc_dynamic)

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

# $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}> does the same job as 
# install (INCLUDES DESTINATION include) so no need to expose it in install command. 

# Link to a library as PRIVATE so any target that links against this (bcdynamic) 
# target does not need to link against that library
target_link_libraries(${PROJECT_NAME} PRIVATE bc_header_only)

# Preproccessor definitions
# Whoever consumes or links to this library will have this preprocessor definition since it is PUBLIC
# export symbol is private to this target
target_compile_definitions(
    ${PROJECT_NAME} 
    PRIVATE "DYNLIB_EXPORT"
    INTERFACE DYNAMIC_LIB_DEF="This is dynamic lib def"
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