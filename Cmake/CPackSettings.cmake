# https://cmake.org/cmake/help/v3.18/module/CPack.html
# https://www.library.illinois.edu/dccdocs/speedwagon/build_installer/build_installer.html

set(CPACK_PACKAGE_VENDOR "BC913")
# Name of the application. Equals to ${PROJECT_NAME} by default.
# set(CPACK_PACKAGE_NAME "MyGreatApp")
# Description
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY ${PROJECT_NAME})
# A text file used to describe the project. Used, for example, the introduction screen of a CPack-generated Windows installer to describe the project.
set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/Packaging/Description.txt")
set(CPACK_PACKAGE_HOMEPAGE_URL "github.com/bc913")
# Versioning
# https://www.zachburlingame.com/2011/02/versioning-a-native-cc-binary-with-visual-studio/
# https://riptutorial.com/cmake/example/32603/using-cmake-to-define-the-version-number-for-cplusplus-usage
set(CPACK_PACKAGE_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${PROJECT_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${PROJECT_VERSION_PATCH})
 #resource
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/Packaging/LICENCE")
set(CPACK_RESOURCE_FILE_README "${CMAKE_CURRENT_SOURCE_DIR}/Packaging/README.md")
set(CPACK_RESOURCE_FILE_WELCOME "${CMAKE_CURRENT_SOURCE_DIR}/Packaging/GenericWelcome.txt")
# set(CPACK_PACKAGE_ICON "${CMAKE_CURRENT_SOURCE_DIR}/Packaging/icons/ship.png")
# packaging

# installation

#Component packaging

# Some settings
# Use NSIS for Windows apps
if(WIN32 AND NOT UNIX)

# https://cmake.org/cmake/help/v3.18/cpack_gen/nsis.html#cpack_gen:CPack%20NSIS%20Generator
# https://martinrotter.github.io/it-programming/2014/05/09/integrating-nsis-cmake/
# https://www.mantidproject.org/NSIS_CPACK_Customisations

  # There is a bug in NSI that does not handle full UNIX paths properly.
  # Make sure there is at least one set of four backlashes.

  # set(CPACK_PACKAGE_ICON "${CMake_SOURCE_DIR}/Utilities/Release\\\\InstallIcon.bmp")
  # set(CPACK_NSIS_INSTALLED_ICON_NAME "bin\\\\MyExecutable.exe")

  # The display name string that appears in the Windows Apps & features in Control Panel
  set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION}-win-Setup")
  set(CPACK_PACKAGE_INSTALL_DIRECTORY "${CPACK_PACKAGE_VENDOR}\\\\${PROJECT_NAME}\\\\${PROJECT_VERSION}")
  set(CPACK_NSIS_DISPLAY_NAME "${PROJECT_NAME}-${PROJECT_VERSION}")
  set(CPACK_NSIS_HELP_LINK "https:\\\\\\\\www.linkedin.com\\\\in\\\\brkcn")
  set(CPACK_NSIS_URL_INFO_ABOUT "https:\\\\\\\\www.linkedin.com\\\\in\\\\brkcn")
  set(CPACK_NSIS_CONTACT "bcan913@gmail.com")
  set(CPACK_NSIS_MODIFY_PATH ON)
  # Windows application details
  set(CPACK_NSIS_MENU_LINKS
    "https:\\\\\\\\www.linkedin.com\\\\in\\\\brkcn"
    "Bc913 Linkedin Account" "https:\\\\\\\\github.com\\\\bc913" "Bc913 Github Account")
  set(CPACK_PACKAGE_EXECUTABLES myApp;TheApp)
else()
  set(CPACK_STRIP_FILES "bin/MyExecutable")
  set(CPACK_SOURCE_STRIP_FILES "")
endif()

#set(CPACK_PACKAGE_ICON "${CMAKE_CURRENT_SOURCE_DIR}/Packaging/icons/ship.png")


include(CPack)

