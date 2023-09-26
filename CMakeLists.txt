cmake_minimum_required(VERSION 3.17.3...3.21.2 FATAL_ERROR)

project(OTutorial VERSION 0.0.1 LANGUAGES CXX)

include(cmake/logvariables.cmake)
include(cmake/globalsettings.cmake)

# Test setup
# enable_testing() should be called in the root cmakeLists.txt
enable_testing()
include(cmake/gtestsetup.cmake)

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
