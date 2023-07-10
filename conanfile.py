from conan import ConanFile
from conan.tools.cmake import CMake, cmake_layout
from conans import tools

class CppCmakeScaffoldConan(ConanFile):
    name = "cpp_cmake_scaffold"
    version = "0.1"

    # Optional metadata
    license = "<Put the package license here>"
    author = "<Put your name here> <And your email here>"
    url = "<Package recipe repository url here, for issues about the package>"
    description = "<Description of Hello here>"
    topics = ("<Put some tag here>", "<here>", "<and here>")

    # Binary configuration
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False], "fPIC": [True, False]}
    default_options = {"shared": False, "fPIC": True}

    # Sources are located in the same place as this recipe, copy them to the recipe
    exports_sources = "CMakeLists.txt", "src/*", "cmake/*, tests/*"
    generators = "CMakeDeps", "CMakeToolchain"

    def config_options(self):
        if self.settings.os == "Windows":
            del self.options.fPIC

    def layout(self):
        cmake_layout(self)

    # Define this when custom setup is required
    # def generate(self):
    #     tc = CMakeToolchain(self)
    #     tc.generate()

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    def package(self):
        cmake = CMake(self)
        cmake.install()
    
    # this should be defined.
    # cmake_layout is not enough
    # https://docs.conan.io/1/reference/conanfile/attributes.html#cpp-info
    def package_info(self):
        self.cpp_info.libs = tools.collect_libs(self)
