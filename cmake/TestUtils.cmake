function(generate_test_header)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs TEST_KEYS TEST_FUNCTION_NAMES)
    cmake_parse_arguments(arg "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT arg_TEST_KEYS)
        message(FATAL_ERROR "TEST_KEYS must be specified.")
    endif()

    if(NOT arg_TEST_FUNCTION_NAMES)
        message(FATAL_ERROR "TEST_FUNCTION_NAMES must be specified.")
    endif()

    set(TEST_HEADER_FILENAME "test_functions")
    string(TOUPPER "${TEST_HEADER_FILENAME}" TEST_HEADER_FILENAME_UPPER)

    # Generate a header file for test function declarations
    set(TEST_FUNCTION_HEADER "${CMAKE_CURRENT_SOURCE_DIR}/${TEST_HEADER_FILENAME}.h")
    file(WRITE ${TEST_FUNCTION_HEADER} "// Auto-generated header file for test functions\n")
    string(TIMESTAMP CURRENT_TIME "%s")
    file(APPEND ${TEST_FUNCTION_HEADER} "#ifndef BELIK_${CURRENT_TIME}_${TEST_HEADER_FILENAME_UPPER}_H\n")
    file(APPEND ${TEST_FUNCTION_HEADER} "#define BELIK_${CURRENT_TIME}_${TEST_HEADER_FILENAME_UPPER}_H\n\n")

    # Extern declarations
    foreach(TEST_FUNC_NAME ${TEST_FUNC_NAMES})
        file(APPEND ${TEST_FUNCTION_HEADER} "extern void ${TEST_FUNC_NAME}(void);\n")
    endforeach()
    # Add a section for the test function array in the header
    file(APPEND ${TEST_FUNCTION_HEADER} "\n\n// Array of test functions\n")
    file(APPEND ${TEST_FUNCTION_HEADER} "typedef struct {\n")
    file(APPEND ${TEST_FUNCTION_HEADER} "    const char* name;\n")
    file(APPEND ${TEST_FUNCTION_HEADER} "    void (*func)(void);\n")
    file(APPEND ${TEST_FUNCTION_HEADER} "} TestFunction;\n\n")
    file(APPEND ${TEST_FUNCTION_HEADER} "TestFunction test_functions[] = {\n")

    list(LENGTH arg_TEST_KEYS NUM_KEYS)
    math(EXPR STOP_VAL "${NUM_KEYS}-1")
    foreach(i RANGE 0 ${STOP_VAL})
        list(GET arg_TEST_KEYS ${i} TEST_KEY)
        list(GET arg_TEST_FUNCTION_NAMES ${i} TEST_FUNC_NAME)
        message(STATUS "KEY:${TEST_KEY} - VALUE: ${TEST_FUNC_NAME}")
        file(APPEND ${TEST_FUNCTION_HEADER} "    {\"${TEST_KEY}\", ${TEST_FUNC_NAME}},\n")
    endforeach()

    # Close the array
    file(APPEND ${TEST_FUNCTION_HEADER} "    {NULL, NULL}\n};\n")
    file(APPEND ${TEST_FUNCTION_HEADER} "#endif\n")

endfunction()

# Function to recursively find and register all test functions from .c files starting with "test_"
function(register_test_functions)
    set(options)
    set(oneValueArgs TARGET)
    set(multiValueArgs TEST_SOURCES)
    cmake_parse_arguments(arg "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT arg_TARGET)
        message(FATAL_ERROR "TARGET must be specified.")
    endif()

    if(NOT arg_TEST_SOURCES)
        message(FATAL_ERROR "TEST_SOURCES must be specified.")
    endif()

    set(TEST_KEYS)
    set(TEST_FUNC_NAMES)

    foreach(TEST_SOURCE ${arg_TEST_SOURCES})
        # Given source file should exist under root/tests/ AND under its module directory
        # Test source files should NOT be under tests root path directly.
        cmake_path(APPEND TESTS_DIR_ROOT_PATH "${CMAKE_SOURCE_DIR}" "tests")        
        get_filename_component(CURR_TEST_FILE_PARENT_DIR_PATH ${TEST_SOURCE} DIRECTORY)
        if("${CURR_TEST_FILE_PARENT_DIR_PATH}" STREQUAL "${TESTS_DIR_ROOT_PATH}")
            message(FATAL_ERROR "Given test source file: ${TEST_SOURCE} should NOT exist directly under root/tests. Make sure it is under a child dir: i.e. [root/tests/<module_name>]")
        endif()

        get_filename_component(PARENT_DIR_NAME ${CURR_TEST_FILE_PARENT_DIR_PATH} NAME)
        cmake_path(APPEND REQUIRED_CURR_TEST_PARENT_DIR_PATH "${TESTS_DIR_ROOT_PATH}" "${PARENT_DIR_NAME}")
        if(NOT "${CURR_TEST_FILE_PARENT_DIR_PATH}" STREQUAL "${REQUIRED_CURR_TEST_PARENT_DIR_PATH}")
            message(FATAL_ERROR "Given test source file should reside under the directory: ${REQUIRED_CURR_TEST_PARENT_DIR_PATH}.")
        endif()

        set(MODULE_NAME ${PARENT_DIR_NAME})

        # Strip off the test_ prefix from the test file name
        # As prefix
        #string(REGEX REPLACE "^test_" "" FILENAME_STRIPPED ${FILENAME_WE})
        
        # Get the name of the test source file without extension
        get_filename_component(FILENAME_WE ${TEST_SOURCE} NAME_WE)
        # First make sure if the file ends with _tests suffix
        string(REGEX MATCH "_tests$" ENDS_WITH_SUFFIX ${FILENAME_WE})
        if(NOT ENDS_WITH_SUFFIX)
            message(FATAL_ERROR "Processed test file names should end with _tests suffix.")
        endif()
        # As suffix
        # string(REGEX REPLACE "_tests$" "" FILENAME_STRIPPED ${FILENAME_WE})

        # Read the content of the test file into a variable
        file(READ ${TEST_SOURCE} FILE_CONTENTS)

        # Use a regex to extract all function names that start with "test_"
        string(REGEX MATCHALL "test_[a-zA-Z0-9_]+" TEST_FUNCTIONS ${FILE_CONTENTS})

        foreach(TEST_FUNCTION ${TEST_FUNCTIONS})
            list(APPEND TEST_FUNC_NAMES ${TEST_FUNCTION})
            # Strip the "test_" prefix from the function name
            string(REGEX REPLACE "^test_" "" TEST_NAME_STRIPPED ${TEST_FUNCTION})
            # Test key
            string(CONCAT TEST_KEY ${MODULE_NAME} "_" ${TEST_NAME_STRIPPED})
            # Register the test case using the stripped function name (ignoring "test_")
            add_test(
                NAME ${TEST_KEY}
                COMMAND ${arg_TARGET} --test ${TEST_KEY}
            )
            list(APPEND TEST_KEYS ${TEST_KEY})
        endforeach()
    endforeach()

    generate_test_header(TEST_KEYS ${TEST_KEYS}
                        TEST_FUNCTION_NAMES ${TEST_FUNC_NAMES}
    )

endfunction()