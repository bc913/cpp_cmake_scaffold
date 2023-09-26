cmake_minimum_required(VERSION 3.25)

project(OTutorial VERSION 0.0.1 LANGUAGES CXX)

set( SCAFFOLD_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
set( CMAKE_MODULE_PATH
   ${SCAFFOLD_MODULE_PATH}
   ${CMAKE_MODULE_PATH}
)

include(logvariables)
include(globalsettings)

# Source
add_subdirectory(src)

#Tests
# enable_testing() should be called in the root cmakeLists.txt
enable_testing()
# Uncomment if you want to consume third-party framework using ExternalProject_Add
# include(cmake/gtestsetup.cmake)
include(CTest)
add_subdirectory(tests)

#Pack
include(cmake/cpacksettings.cmake)
