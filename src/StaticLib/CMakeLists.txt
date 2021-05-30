# StaticLib
# variable definitions
set(This BcStatic)

# target_sources() must be used if the sources are blank
add_library(${This} STATIC "")

# Source for the projects
target_sources(${This} 
    PRIVATE
        Calculator.h
        Calculator.cpp
        Age.cpp
    PUBLIC
        include/${This}/Age.h
)

# PUBLIC: specified include directory(s) is required for this target and the consumers.
target_include_directories(${This} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

# Preproccessor definitions
# Whoever consumes or links to this library will have this preprocessor definition since it is PUBLIC
target_compile_definitions(${This} PUBLIC STATICLIBCONSTANT=4)
# PUBLIC: Definition is available to this target and its consumers
# INTERFACE: Definition is only available to the consumer.
# PRIVATE: Definition is only available to this target.

target_compile_definitions(${This} INTERFACE STATIC_LIB_DEF="This is static lib definition")

# Link header-only file
target_link_libraries(
    ${PROJECT_NAME} 
    PRIVATE bc_header_only
)

# Install setup
include(GNUInstallDirs)
install(TARGETS ${This})