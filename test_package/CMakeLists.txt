cmake_minimum_required(VERSION 3.15)
project(PackageTest CXX)

MESSAGE( STATUS "CMAKE_INCLUDE_PATH: " ${CMAKE_INCLUDE_PATH} )
find_package(cpp_cmake_scaffold CONFIG REQUIRED)

add_executable(example src/example.cpp)
target_link_libraries(example PRIVATE cpp_cmake_scaffold::cpp_cmake_scaffold)
