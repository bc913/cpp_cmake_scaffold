# Tests/DynamicLib
project(bc_dynamic_tests)

add_executable(${PROJECT_NAME} "")

target_sources(${PROJECT_NAME} 
    PRIVATE
        test_employee.cpp
)

# FetchContent (GoogleTest)
target_link_libraries(${PROJECT_NAME} PRIVATE GTest::gtest_main bc_dynamic)
include(GoogleTest)
gtest_discover_tests(${PROJECT_NAME})

# ==============================================================
# ExternalProject Setup

# target_link_libraries(
#     ${PROJECT_NAME} 
#     PRIVATE gtest_main bc_dynamic
# )

# add_test(
#     NAME ${PROJECT_NAME}
#     COMMAND ${PROJECT_NAME} --config Debug|Release
#     WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
# )