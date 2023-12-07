# Package Management

## Scope of `FetchContent` and `find_package`
When `find_package` is called within a directory, its `IMPORTED_TARGETS` and Result variables are ONLY available to where it is called and its child directories.
> As stated in the [docs](https://cmake.org/cmake/help/v3.25/command/find_package.html), when `GLOBAL` is passed to the command, the IMPORTED_TARGETS and its result_variables would be available to every other target regardless to their relative location of where `find_package` is declared.
> However, I can't make it work so as quick fix: Declared `find_package` in the root `CMakeLists.txt`

Looks like `FetchContent` is marked as GLOBAL by default which means wherever you declare your `FetchContent` commands, the `IMPORTED_TARGETS` and result_variables are available to any other target regardless their (relative) location. 

## Resources
- [Trying Conan with Modern CMake: Dependencies](https://jfreeman.dev/blog/2019/05/22/trying-conan-with-modern-cmake:-dependencies/)
- [The state of package management in C++ - Mathieu Ropert](https://accu.org/conf-docs/PDFs_2019/mathieu_ropert_-_the_state_of_package_management_in_cpp.pdf)

- [What use is find_package() when you need to specify CMAKE_MODULE_PATH?](https://stackoverflow.com/questions/20746936/what-use-is-find-package-when-you-need-to-specify-cmake-module-path)
- [Github - gui starter template](https://github.com/cpp-best-practices/gui_starter_template)
- [Another package manager - CPM_CMake](https://github.com/cpm-cmake/CPM.cmake)
- [Vcpkg Vs Conan: Best Package Manager For C++?](https://matgomes.com/vcpkg-vs-conan-for-cpp/)
- [Managing dependencies in a C++ project with vcpkg](https://decovar.dev/blog/2022/10/30/cpp-dependencies-with-vcpkg/)
### CMake forums
- [Idea for CMake-based package manager](https://discourse.cmake.org/t/idea-for-cmake-based-package-manager/5197)
- [fetchcontent vs vcpkg, conan?](https://discourse.cmake.org/t/fetchcontent-vs-vcpkg-conan/6578)
- [FetchContent in dependency management](https://discourse.cmake.org/t/fetchcontent-in-dependency-management/6038)