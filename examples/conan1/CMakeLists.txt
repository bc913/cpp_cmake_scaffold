cmake_minimum_required(VERSION 3.15)
project(bcan CXX)

set(CONAN_PACKAGE_PATH "${CMAKE_SOURCE_DIR}/.conan")
list(APPEND CMAKE_MODULE_PATH ${CONAN_PACKAGE_PATH})
list(APPEND CMAKE_PREFIX_PATH ${CONAN_PACKAGE_PATH})


find_package(ZLIB REQUIRED)
# find_package(fmt REQUIRED)

add_executable(bcan src/bcan.cpp src/main.cpp)
#target_link_libraries(bcan PRIVATE fmt::fmt ZLIB::ZLIB)
target_link_libraries(bcan PRIVATE ZLIB::ZLIB)



install(TARGETS bcan DESTINATION "."
        RUNTIME DESTINATION bin
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        )
