# Third-Party Dependencies in CMake
## Introduction
One of the biggest challenges in big C++ projects is managing the library dependencies. There are several tools are available (Nuget, Conan, vcpkg, Build2, etc.) for this purpose with their pros and cons. I have always been looking for a solution considering the following aspects:

- Cross-platform usage
- Availability to automation through builds(locally and remotely)
- Compatibility to CI/CD
- Easy to use & maintain

It seems that vcpkg is the most convenient and promising solution for this purpose at least imo. It can easily be set through CLI and can be adjusted to remote build or cloud systems easily. The biggest impact is its cross platform availability.

## Current Status
I've decided to use `vcpg` but currently, no third-party dependency and usage of a package manager is available for this repo. I can't setup `vcpkg` on my machine due to an existing issue. [#12271](https://github.com/microsoft/vcpkg/issues/12771) and [#9848](https://github.com/microsoft/vcpkg/issues/9848)

As soon as the issue is fixed, third-party library usage will be available within the repo.

## [Boost](https://cmake.org/cmake/help/latest/module/FindBoost.html)
Boost libraries can be consumed in several ways. Check CMake documentation for details.

Before proceeding, it is better to know some aspects of Boost CMake packages. Following variables can be set before running the `find_package(Boost ...)` command: (If you don't use vcpkg, it'd be better to set the `BOOST_ROOT` to the path of your choice. The other ones will automatically be set accordingly.)

- **Boost_DEBUG**: Set to ON to debug find_package and build process.
- **BOOST_ROOT** (or BOOSTROOT):  Preferred installation prefix
- **BOOST_INCLUDEDIR**: Preferred include directory e.g. <prefix>/include
- **BOOST_LIBRARYDIR**: Preferred library directory e.g. <prefix>/lib
- **Boost_NO_SYSTEM_PATHS**: Set to ON to disable searching in locations not specified by these hint variables. Default is OFF.
- **Boost_ADDITIONAL_VERSIONS**: List of Boost versions not known to this module (Boost install locations may contain the version)

Also, the following variables can be set to define how your project consume Boost dependency:
- **Boost_USE_DEBUG_LIBS** : Set to ON or OFF to specify whether to search and use the debug libraries.  Default is ON.
- **Boost_USE_RELEASE_LIBS**: Set to ON or OFF to specify whether to search and use the release libraries.  Default is ON.
- **Boost_USE_MULTITHREADED**:  - Set to OFF to use the non-multithreaded libraries ('mt' tag).  Default is ON.
- **Boost_USE_STATIC_LIBS**:  Set to ON to force the use of the static libraries.  Default is OFF.
- **Boost_USE_STATIC_RUNTIME**: Set to ON or OFF to specify whether to use libraries linked statically to the C++ runtime ('s' tag). Default is platform dependent.
- **Boost_USE_DEBUG_RUNTIME**: Set to ON or OFF to specify whether to use libraries linked to the MS debug C++ runtime

`find_package(Boost ...)` command also produces some result variables. Some of them are listed here: (Check the documentation for the full list.)
- **Boost_FOUND**: True if headers and requested libraries were found
- **Boost_INCLUDE_DIRS**: Boost include directories
- **Boost_LIBRARY_DIRS**: Link directories for Boost libraries
- **Boost_LIBRARIES**: Boost component libraries to be linked

These variables can be consumed accordingly.

### Consume as header-only
```cmake
find_package(Boost 1.36.0)
if(Boost_FOUND)
    include_directories(${Boost_INCLUDE_DIRS})
endif()
```

### Consume as library
```cmake
find_package(Boost 1.36.0 REQUIRED COMPONENTS date_time filesystem iostreams)

# Since it is REQUIRED, no need to have found check.
target_link_libraries(<consumer-target> Boost::date_time Boost::filesystem Boost::iostreams)

```

### Consume as static library
```cmake
set(Boost_USE_STATIC_LIBS        ON)  # only find static libs
set(Boost_USE_DEBUG_LIBS         OFF) # ignore debug libs and
set(Boost_USE_RELEASE_LIBS       ON)  # only find release libs
set(Boost_USE_MULTITHREADED      ON)
set(Boost_USE_STATIC_RUNTIME    OFF)

find_package(Boost 1.66.0 COMPONENTS date_time filesystem system ...)
if(Boost_FOUND)
  include_directories(${Boost_INCLUDE_DIRS})
  target_link_libraries(foo ${Boost_LIBRARIES})
endif()

```
### Resources
(https://cmake.org/cmake/help/latest/module/FindBoost.html)
(https://stackoverflow.com/questions/6646405/how-do-you-add-boost-libraries-in-cmakelists-txt)


## [Qt5](https://doc.qt.io/qt-5/cmake-manual.html)
Basic syntax:
```cmake
#set up
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

Use this way to locate the Qt installation if the other ways do not work
#set(Qt5_DIR "C:/Qt/5.15.0/msvc2019_64/lib/cmake/Qt5")
SET(CMAKE_INCLUDE_CURRENT_DIR ON)

# find it
find_package(Qt5 REQUIRED COMPONENTS Core Widgets Gui)

# set the files
set(project_ui custommainwindow.ui)
set(project_headers custommainwindow.h)
set(project_sources 
    main.cpp
    custommainwindow.cpp)

# ADd to executable target
add_executable(${This} ${project_headers} ${project_sources} ${project_ui})

# Link
target_link_libraries(${This} PRIVATE mySlib myDynLib PUBLIC Qt5::Core Qt5::Widgets Qt5::Gui)

```

There are some aspects to point out:
- As stated in Qt documentation, in order `find_package()` command to be successful one of the following ways should be picked:
1. Set `CMAKE_PREFIX_PATH` env variable to Qt installation directory when running cmake.`cmake -DCMAKE_PREFIX_PATH=path\to\qt`. This is recommended way.
2. Set `Qt5_DIR` variable to Qt installation directory.
3. Use vcpkg and install Qt5:x64-windows. vcpkg handles it implicitly.(Not tested yet)

- The ui files should be created using `Qt Creator` or other tools if available and should be saved accordingly.

- Be careful about the include statements for the Qt headers. The ones shown in Qt tutorials should work. VS Code might complain even you have the correct settings so do not bother.
```cpp
#include "custommainwindow.h"
#include <QtWidgets/QApplication>
```

- `target_sources()` command does not work with Qt so use non empty `add_executable()` or `add_library()` with sources.

- With this syntax, no need to use `wrap_ui()` and `wrap_cpp` syntax.

 