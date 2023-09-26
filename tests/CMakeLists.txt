include(FetchContent)

# Bring Googletest dep
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/f8d7d77c06936315286eb55f8de22cd23c188571.zip
)
# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)
# GoogleTest: `gtest_discover_tests` discovers tests by asking the _compiled test executable_
# to enumerate its tests. `PRE_TEST` delays test discovery until just prior to test execution;
# this avoids calling the executables during the build phase.
# https://jugit.fz-juelich.de/mlz/bornagain/-/merge_requests/390
set(CMAKE_GTEST_DISCOVER_TESTS_DISCOVERY_MODE PRE_TEST)

# Tests
add_subdirectory(StaticLib)
add_subdirectory(DynamicLib)
add_subdirectory(HeaderOnly)