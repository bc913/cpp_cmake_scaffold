# DynamicLib
set(This BcDynamic)

# target_sources() must be used if the sources are blank
add_library(${This} SHARED "")

# Source for the projects
target_sources(${This} 
    PRIVATE
        Person.cpp
    PUBLIC
        include/${This}/BcDynApi.h
        include/${This}/Person.h
)

# Anyone consuming this library will have this public include dir by default
# No need to define INCLUDES in install command unless one wants to have a custom design
target_include_directories(${This} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

# Link to a library as PRIVATE so any target that links against this (bcdynamic) 
# target does not need to link against that library
target_link_libraries(${PROJECT_NAME} PRIVATE bc_header_only)

# Preproccessor definitions
# Whoever consumes or links to this library will have this preprocessor definition since it is PUBLIC
# export symbol is private to this target
target_compile_definitions(${This} PRIVATE "DYNLIB_EXPORT" INTERFACE DYNAMIC_LIB_DEF="This is dynamic lib def")

# Install setup
include(GNUInstallDirs)
install(TARGETS ${This})
