# Conan 2.0 Setup
## Main differences from usual CMake practices
- `conan install` is run during CMake configure step
- `CMAKE_BUILD_TYPE` is passed to configure presets for `conan install` to work. Configuration is usually set within
`build` and `test` presets.
- The compiler, runtime settings are determined by CMake
- CMakeToolchain is not used since it generates conan defined CMakePresets.json which limits your compiler, sdk choice.
- Host profile is determined by CMake.

## Available Conan Settings
- [Available settings values](https://docs.conan.io/2/reference/config_files/settings.html#reference-config-files-settings-yml)

## References
- [CMake Wrapper for Conan](https://github.com/conan-io/cmake-conan)
- https://www.youtube.com/watch?v=kKGglzm5ous
- https://docs.conan.io/2/reference/conanfile/methods/requirements.html
- https://docs.conan.io/2/reference/conanfile/methods/build_requirements.html