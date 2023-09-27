project(bc_client)

add_executable(${PROJECT_NAME} "")
target_sources(${PROJECT_NAME} 
    PRIVATE
        main.cpp
)

set_target_properties(${PROJECT_NAME} PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})

# Define dependent shared libraries
set(_SHARED_LIBS)
list(APPEND _SHARED_LIBS bc_dynamic)

target_link_libraries(
    ${PROJECT_NAME} 
    PRIVATE ${_SHARED_LIBS} bc_header_only bc_static
)

# copy the .dll file to the same folder as the executable
if(WIN32) 
    foreach(shared_lib ${_SHARED_LIBS})
        message("Copying dependent ${shared_lib} binary for ${PROJECT_NAME}...")
        add_custom_command(
            TARGET ${PROJECT_NAME}
            POST_BUILD
            COMMAND
                ${CMAKE_COMMAND} -E copy_directory
                $<TARGET_FILE_DIR:${shared_lib}>
                $<TARGET_FILE_DIR:${PROJECT_NAME}>
            VERBATIM
        )
    endforeach()
endif()

## INSTALL
##
set(CMAKE_CONFIG_INSTALL_DIR "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")

install(
    TARGETS ${PROJECT_NAME}
    EXPORT ${PROJECT_NAME}Targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    #PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

# install(
#     DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
# )

# # Make target importable from the install directory
# install(
#     EXPORT
#     ${PROJECT_NAME}Targets
#     FILE ${PROJECT_NAME}Targets.cmake
#     DESTINATION ${CMAKE_CONFIG_INSTALL_DIR}
# )

# ##
# ## BUILD TREE
# ##
# export(
#     EXPORT ${PROJECT_NAME}Targets 
#     FILE ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Targets.cmake
# )