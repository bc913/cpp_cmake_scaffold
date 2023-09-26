# specify the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# VS compilers symbols are hidden by default.
# For GCC/Clang it is public by default so make it hidden.
# https://www.youtube.com/watch?v=m0DwB4OvDXk
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN ON)
#set(CMAKE_POSITION_INDEPENDENT_CODE ON)
# using set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -c") will break this visibility feature and will not compile

# To ensure maximum portability across various compilers and platforms
# deactivate any compiler extensions
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_CXX_EXTENSIONS OFF)


include(GNUInstallDirs)
# output
#CMAKE_BINARY_DIR if you are building in-source, this is the same as CMAKE_SOURCE_DIR, otherwise this is the top level directory of your build tree
# set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/out/lib)
# set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/out/lib)
# set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/out/bin)

# if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
#   set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_BINARY_DIR/install} CACHE PATH "..." FORCE)
#   MESSAGE(STATUS "CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT = TRUE")
#   MESSAGE(STATUS "CMAKE_INSTALL_PREFIX = ${CMAKE_CURRENT_BINARY_DIR/install}")
# endif()

set(CMAKE_DEBUG_POSTFIX "_d")
