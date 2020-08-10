# Tests/Staticib
cmake_minimum_required(VERSION 3.17.3)

set(This BcStaticTests)

add_executable(${This} "")

target_sources(${This} 
    PRIVATE
        TestAge.cpp
)

target_link_libraries(${This} PRIVATE gtest_main BcStatic)

add_test(
    NAME ${This}
    COMMAND ${This} --config Debug|Release
)