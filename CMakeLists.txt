cmake_minimum_required(VERSION 3.25)

project(OTutorial VERSION 0.0.1 LANGUAGES CXX)

set( SCAFFOLD_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
set( CMAKE_MODULE_PATH
   ${SCAFFOLD_MODULE_PATH}
   ${CMAKE_MODULE_PATH}
)

include(logvariables)
include(globalsettings)

# RPATH
#-------------------
# use, i.e. don't skip the full RPATH for the build tree
set(CMAKE_SKIP_BUILD_RPATH FALSE)
# when building, don't use the install RPATH already
# (but later on when installing)
set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
# add the automatically determined parts of the RPATH
# which point to directories outside the build tree to the install RPATH
# Disable the automatic stripping of RPATH on install.
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

# To define rpaths as relative paths
set(CMAKE_BUILD_RPATH_USE_ORIGIN TRUE)

# the RPATH to be used when installing, but only if it's not a system directory
# list(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${CMAKE_INSTALL_PREFIX}/lib" isSystemDir)
# if("${isSystemDir}" STREQUAL "-1")
#     set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
# endif("${isSystemDir}" STREQUAL "-1")

if(APPLE)
    #set(CMAKE_MACOSX_RPATH TRUE) if this set use @rpath
    #TODO: Requires testing | Also try @executable_path
    set(CMAKE_INSTALL_RPATH "@executable_path/../${CMAKE_INSTALL_LIBDIR};@loader_path;@executable_path")
elseif(UNIX)
    set(CMAKE_INSTALL_RPATH "$ORIGIN/../${CMAKE_INSTALL_LIBDIR};$ORIGIN")
endif()

# Source
add_subdirectory(src)

#Tests
# enable_testing() should be called in the root cmakeLists.txt
enable_testing()
# Uncomment if you want to consume third-party framework using ExternalProject_Add
# include(cmake/gtestsetup.cmake)
include(CTest)
add_subdirectory(tests)

#Pack
include(cmake/cpacksettings.cmake)
