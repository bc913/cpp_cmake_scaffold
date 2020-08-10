# Header Only

# Variables/definitions
set(This BcHeaderOnly)

# Library definition
add_library(${This} INTERFACE)

# Consumer targets can access to header-only library header files as 
# #include <BcHeaderOnly/Utilities.h>
target_include_directories(${This} INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}/include)

target_compile_definitions(${This} INTERFACE HEADER_ONLY_LIB_DEF="This is header only lib definition")
