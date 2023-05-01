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

## Misc
- Using `conan` with `ninja` build tool: `ninja` complains about `CMAKE_GENERATOR_PLATFORM` being defined.
    1. Make sure you're using `CMakeDeps` and/or `CMakeToolchain` generators in `conanfile.txt` or `conanfile.py`.
    2. Add `tools.cmake.cmaketoolchain:generator=Ninja` to your profile txt file under `[conf].
    3. [Windows only] When you run `conan install ..` for that profile, it will generate `conanvcvars.bat` under given directory for `-if` argument. It is used for initializing the required environment for `Ninja`.
    >  Before applying step 4, run this `bat` file from the command line to activate the environment.
    4. Run `cmake . -B build -G Ninja ...` and other `cmake` or `ninja` commands.

## References
### Misc
- [CLion keeps generating CMAKE_GENERATOR_PLATFORM when using Ninja](https://youtrack.jetbrains.com/issue/CPP-32953)
- [Github - question - CMakeToolchain requires VCVars](https://github.com/conan-io/conan/issues/12855)
- [Conan - CMakeToolchain](https://docs.conan.io/1/reference/conanfile/tools/cmake/cmaketoolchain.html)