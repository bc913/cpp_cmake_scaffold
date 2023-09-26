project(bc_client)

add_executable(${PROJECT_NAME} "")

target_sources(${PROJECT_NAME} 
    PRIVATE
        main.cpp
)

set_target_properties(${PROJECT_NAME} PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})

target_link_libraries(
    ${PROJECT_NAME} 
    PRIVATE bc_header_only bc_static bc_dynamic
)

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