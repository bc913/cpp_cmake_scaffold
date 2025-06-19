from conans import ConanFile, CMake, tools
from conan.tools.cmake import CMakeToolchain, CMake, cmake_layout, CMakeDeps


class bcanRecipe(ConanFile):
    name = "bcan"
    version = "1.0"
    package_type = "application"

    # Optional metadata
    license = "<Put the package license here>"
    author = "<Put your name here> <And your email here>"
    url = "<Package recipe repository url here, for issues about the package>"
    description = "<Description of bcan package here>"
    topics = ("<Put some tag here>", "<here>", "<and here>")

    # Binary configuration
    settings = "os", "compiler", "build_type", "arch"

    # Sources are located in the same place as this recipe, copy them to the recipe
    exports_sources = "CMakeLists.txt", "src/*"
    generators = "cmake_find_package", "cmake"

    def layout(self):
        cmake_layout(self)

    def requirements(self):
        self.requires("zlib/1.2.11")

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    def package(self):
        cmake = CMake(self)
        cmake.install()

    

    
