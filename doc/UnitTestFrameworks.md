# Unit Test Frameworks
## 1. Unity
### 1.1 CMake Setup
```cmake
# --------------
#  Get the dependency
# --------------
include(FetchContent)
add_definitions(-DUNITY_INCLUDE_DOUBLE -DUNITY_DOUBLE_PRECISION=0.000001 -DUNITY_FLOAT_PRECISION=0.0001f)

FetchContent_Declare(
    unity
    GIT_REPOSITORY https://github.com/ThrowTheSwitch/Unity.git
    GIT_TAG 860062d51b2e8a75d150337b63ca2a472840d13c #v2.6.0
)

FetchContent_MakeAvailable(unity)

# --------------
#  SETUP
# --------------
set(TESTS_TARGET "some_tests")

set(TESTS_SOURCE_FILES)
list(APPEND TESTS_SOURCE_FILES
    main.c
)

set(SUBPROJECT_TEST_SOURCE_FILES)
list(APPEND SUBPROJECT_TEST_SOURCE_FILES
    lib1/lib1_tests.c
    lib2/lib2_tests.c
)

add_executable(${TESTS_TARGET} "")
target_sources(${TESTS_TARGET}
    PRIVATE
        ${TESTS_SOURCE_FILES}
        ${SUBPROJECT_TEST_SOURCE_FILES}
)

target_link_libraries(${TESTS_TARGET} 
    PRIVATE 
        unity::framework
)

# --------------
#  Register
# --------------
# In order to run all the tests available, I wanted to automate this process
# during the configure time. The following commands basically:
# - collects the name of the test source files which has unity unit test functions
# make sure the files ends with _tests.c
file(GLOB_RECURSE TEST_FILES "${CMAKE_CURRENT_SOURCE_DIR}/**/*_tests.c")
# - Register all of the functions by generating test_functions.h with the 
# function declerations to be included by the main.c
register_test_functions(TARGET ${_BELIK_TESTS_TARGET} 
                        TEST_SOURCES ${TEST_FILES}
)
# Check TestUtils.cmake for details
# main.c runs all the tests registered in test_functions.h

# --------------
#  CTEST
# --------------
# CTest Setup
set(TEST_NAME "belik_hydroelas_core_tests")
add_test( ${TEST_NAME} COMMAND ${TESTS_TARGET})

```

### 1.2 Unit tests
```c
// some_tests.c
#include "unity.h"
// Include required headers

// It is declared as static to eliminate linkage errors
static void setUp(void) {
    // set stuff up here
}

static void tearDown(void) {
    // clean stuff up here
}

void test_stuff(void)
{
    // GIVEN
    const real input1 = 23;
    //WHEN
    const real cb = some_method(input1);
    //THEN
#ifdef UNITY_INCLUDE_DOUBLE
    TEST_ASSERT_EQUAL_DOUBLE(11.2571018, cb);
#else
    TEST_ASSERT_EQUAL_FLOAT(11.25710, cb);
#endif
}
```

### 1.3 main.c
```c
#include "unity.h"
#include "test_functions.h"  // Include the auto-generated header
#include <stdio.h>
#include <string.h>

// not needed when using generate_test_runner.rb
int main(int argc, char* argv[]) {
    UNITY_BEGIN();
    // First key has to be --test
    if (argc > 2 && strcmp(argv[1], "--test") == 0)
    {
        for (int i = 0; test_functions[i].name != NULL; ++i) {
            for (int j = 2; j < argc; ++j) {
                if (strcmp(argv[j], test_functions[i].name) == 0) {
                    RUN_TEST(test_functions[i].func);
                }
            }
        }
    }
    else
    {
        for (int i = 0; test_functions[i].name != NULL; ++i) {
            RUN_TEST(test_functions[i].func);
        }
    }
    return UNITY_END();
}
```

### 1.4 References
- [https://github.com/ThrowTheSwitch/Unity](https://github.com/ThrowTheSwitch/Unity)
- [https://github.com/ThrowTheSwitch/Unity/blob/master/docs/UnityGettingStartedGuide.md](https://github.com/ThrowTheSwitch/Unity/blob/master/docs/UnityGettingStartedGuide.md)
- [https://github.com/ThrowTheSwitch/Unity/issues/755](https://github.com/ThrowTheSwitch/Unity/issues/755)
- [https://www.throwtheswitch.org/build/cmake](https://www.throwtheswitch.org/build/cmake)
- [https://github.com/microsoft/vscode-cmake-tools/issues/3153](https://github.com/microsoft/vscode-cmake-tools/issues/3153)
- [https://github.com/microsoft/vscode-cmake-tools/blob/main/docs/debug-launch.md](https://github.com/microsoft/vscode-cmake-tools/blob/main/docs/debug-launch.md)

## 2. Boost.Test
- [How to set up a CMake project using Unit Test Framework (extended)](https://www.boost.org/doc/libs/1_68_0/libs/test/doc/html/boost_test/section_faq.html#boost_test.section_faq.how_to_set_up_a_cmake_project_us)