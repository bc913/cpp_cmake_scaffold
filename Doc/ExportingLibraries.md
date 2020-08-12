# Exporting and Packaging Libraries

## Export library
```cmake

set(Target_NAME "${This}Targets")
set(TargetsFileName "${Target_NAME}.cmake")
set(ConfigFileName "${This}Config.cmake")
set(ConfigVersionFileName "${This}ConfigVersion.cmake")
set(INSTALL_CONFIGDIR 
    ${CMAKE_INSTALL_LIBDIR}/cmake/${This}
    CACHE STRING "Path to BcStatic cmake files"
)

include(GNUInstallDirs)
install(TARGETS ${This}
  EXPORT ${Target_NAME}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
          COMPONENT ${This}_RunTime
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
          COMPONENT ${This}_RunTime
          NAMELINK_COMPONENT ${This}_Development
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
          COMPONENT ${This}_Development
)


install(EXPORT ${Target_NAME}
    DESTINATION ${INSTALL_CONFIGDIR}
    NAMESPACE BC::
    FILE ${TargetsFileName}
    COMPONENT ${This}_Development    
)
# 

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/${ConfigVersionFileName}
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
)

configure_package_config_file(
    ${ConfigFileName}.in
    ${CMAKE_CURRENT_BINARY_DIR}/${ConfigFileName}
    INSTALL_DESTINATION ${INSTALL_CONFIGDIR}
)

## Export config files
install(
    FILES
      ${CMAKE_CURRENT_BINARY_DIR}/${ConfigFileName}
      ${CMAKE_CURRENT_BINARY_DIR}/${ConfigVersionFileName}
    DESTINATION ${INSTALL_CONFIGDIR}
)

#export headers
install(DIRECTORY include/${This}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    FILES_MATCHING PATTERN "*.h"
)

export(EXPORT ${Target_NAME}
    FILE ${CMAKE_CURRENT_BINARY_DIR}/${TargetsFileName}
    NAMESPACE BC::
)

export(PACKAGE ${This})
```

## Some essential links
- https://github.com/forexample/package-example
- https://codingnest.com/basic-cmake-part-2/
- https://cliutils.gitlab.io/modern-cmake/chapters/install.html
- https://coderwall.com/p/qej45g/use-cmake-enabled-libraries-in-your-cmake-project-iii