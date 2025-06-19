cmake_minimum_required(VERSION 3.15)
project(bcan CXX)

find_package(ZLIB REQUIRED)
find_package(fmt REQUIRED)

add_executable(bcan src/bcan.cpp src/main.cpp)
target_link_libraries(bcan PRIVATE fmt::fmt ZLIB::ZLIB)



install(TARGETS bcan DESTINATION "."
        RUNTIME DESTINATION bin
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        )
