#Root
cmake_minimum_required(VERSION 3.17.3)

project(OTutorial VERSION 0.0.1 LANGUAGES CXX)

if(NOT WIN32)
    message(FATAL_ERROR "Only Windows OS is supported currently.")
endif()

include(cmake/logvariables.cmake)
include(cmake/globalsettings.cmake)

# Test setup
# enable_testing() should be called in the root cmakeLists.txt
enable_testing()
include(cmake/gtestsetup.cmake)

# Source
add_subdirectory(Source)

#Tests
include(CTest)
add_subdirectory(Tests)

#Pack
include(cmake/cpacksettings.cmake)
