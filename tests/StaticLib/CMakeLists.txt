# Tests/Staticib
cmake_minimum_required(VERSION 3.17.3)
project(bc_static_tests VERSION ${CMAKE_PROJECT_VERSION} LANGUAGES CXX)

add_executable(${PROJECT_NAME} "")

target_sources(${PROJECT_NAME} 
    PRIVATE
        test_lcs.cpp
)

target_link_libraries(${PROJECT_NAME} PRIVATE gtest_main bc_static)

add_test(
    NAME ${PROJECT_NAME}
    COMMAND ${PROJECT_NAME} --config Debug|Release
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)