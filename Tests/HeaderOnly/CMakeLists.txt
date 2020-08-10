#Tests/HeaderOnly

cmake_minimum_required(VERSION 3.17.3)

set(This BcHeaderOnlyTests)

add_executable(${This} "")

target_sources(${This} 
    PRIVATE
        TestUtilities.cpp
)

target_link_libraries(${This} PRIVATE gtest_main BcHeaderOnly)

add_test(
    NAME ${This}
    COMMAND ${This} --config Debug|Release
)