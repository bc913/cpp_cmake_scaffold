#Client
set(This BcApp)

add_executable(${This} "")

target_sources(${This} 
    PRIVATE
        main.cpp
)

set_target_properties(${This} PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})

target_link_libraries(${This} PRIVATE BcStatic BcDynamic BcHeaderOnly)

install(TARGETS ${This})