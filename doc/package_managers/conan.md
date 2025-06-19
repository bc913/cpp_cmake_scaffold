# Conan C/C++ Package Manager

## Installation
```bash
# Latest version
pip install conan
# Previous versions
pip install -v "conan==1.59.0"
```
> (Unix) Prefer using virtual environment `virtualenv` over `sudo pip install conan` for installation.

## Usage
- Remote repositories
```bash
# Add repository
conan remote add <repo_name> <repo_url>
# Authenticate for a remote
conan user <user_name> -p <password> -r <remote_name>
# List recipes in remote repo
conan search -r <remote_name>
```

- Local cache
```bash
# List recipes in local cache
conan search
```

## Local package development flow
```powershell
# Install the dependencies (if exists any)
# Generates generator files e.g. conaninfo.txt/conanbuildinfo.txt
conan install .\conanfile.py -if .\build\ -pr .\conan\profiles\msvc_win.txt -s build_type=Release

# Build the package
## -if: directory where the generator files are at from previous step
conan build .\conanfile.py -if .\build\

# Since cmake_layout is used in conanfile, the expected cmake build folder is build and it is recommended to place generator files under build so install command uses build dir for install folder.

# Create package and expose it in the local cache.
conan export-pkg .\conanfile.py demo/testing --profile .\conan\profiles\msvc_win.txt -s build_type=Release -bf .\build\

# Test package
conan test .\test_package\ cpp_cmake_scaffold/0.1@demo/testing --build=never -pr .\conan\profiles\msvc_win.txt -s build_type=Release

```

## Misc
- Using `conan` with `ninja` build tool: `ninja` complains about `CMAKE_GENERATOR_PLATFORM` being defined.
    1. Make sure you're using `CMakeDeps` and/or `CMakeToolchain` generators in `conanfile.txt` or `conanfile.py`.
    2. Add `tools.cmake.cmaketoolchain:generator=Ninja` to your profile txt file under `[conf].
    3. [Windows only] When you run `conan install ..` for that profile, it will generate `conanvcvars.bat` under given directory for `-if` argument. It is used for initializing the required environment for `Ninja`.
    >  Before applying step 4, run this `bat` file from the command line to activate the environment.
    4. Run `cmake . -B build -G Ninja ...` and other `cmake` or `ninja` commands.

- [How to define Components](https://docs.conan.io/en/1.59/creating_packages/package_information.html)

- `cmake_find_package` generator needs to be used with by setting `CMAKE_MODULE_PATH` and `CMAKE_PREFIX_PATH` as defined [here](https://github.com/conan-io/conan/issues/7636#issuecomment-685035623) and in [audacity repo](https://github.com/audacity/audacity/blob/796603d8644b8c0440f1fd44a60bbf3dbc317925/CMakeLists.txt#L122)

- [Available conan settings and options](https://docs.conan.io/1/extending/custom_settings.html)

- Host & Build Context
    - [Build and Host contexts](https://docs.conan.io/1/devtools/build_requires.html#build-and-host-contexts)
    - [Build, Host and Target Platform](https://docs.conan.io/1/systems_cross_building/cross_building.html#gnu-triplet-convention)

- [cpp_info reference - Required for package_info() method](https://docs.conan.io/1/reference/conanfile/attributes.html#cpp-info)

## References
### Misc
- [CLion keeps generating CMAKE_GENERATOR_PLATFORM when using Ninja](https://youtrack.jetbrains.com/issue/CPP-32953)
- [Github - question - CMakeToolchain requires VCVars](https://github.com/conan-io/conan/issues/12855)
- [Conan - CMakeToolchain](https://docs.conan.io/1/reference/conanfile/tools/cmake/cmaketoolchain.html)
- [Simple Example](https://www.codingwiththomas.com/blog/building-and-publishing-conan-packages-on-artifactory)