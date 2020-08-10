# Tests/DynamicLib
cmake_minimum_required(VERSION 3.17.3)

set(This BcDynamicTests)

add_executable(${This} "")

target_sources(${This} 
    PRIVATE
        TestPerson.cpp
)

target_link_libraries(${This} PRIVATE gtest_main BcDynamic)

add_test(
    NAME ${This}
    COMMAND ${This} --config Debug|Release
)