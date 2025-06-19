#include "bcan.h"
#include <vector>
#include <string>
#include "fmt/color.h"
#include <zlib.h>

int main() {
    bcan();

    std::vector<std::string> vec;
    vec.push_back("test_package");

    bcan_print_vector(vec);

    fmt::print(fg(fmt::terminal_color::cyan), "Hello fmt {}!\n", FMT_VERSION );

    char buffer_in [256] = {"Conan is a MIT-licensed, Open Source package manager for C and C++ development "
                            "for C and C++ development, allowing development teams to easily and efficiently "
                            "manage their packages and dependencies across platforms and build systems."};
    char buffer_out [256] = {0};

    z_stream defstream;
    defstream.zalloc = Z_NULL;
    defstream.zfree = Z_NULL;
    defstream.opaque = Z_NULL;
    defstream.avail_in = (uInt) strlen(buffer_in);
    defstream.next_in = (Bytef *) buffer_in;
    defstream.avail_out = (uInt) sizeof(buffer_out);
    defstream.next_out = (Bytef *) buffer_out;

    deflateInit(&defstream, Z_BEST_COMPRESSION);
    deflate(&defstream, Z_FINISH);
    deflateEnd(&defstream);

    printf("Uncompressed size is: %lu\n", strlen(buffer_in));
    printf("Compressed size is: %lu\n", strlen(buffer_out));

    printf("ZLIB VERSION: %s\n", zlibVersion());

    return EXIT_SUCCESS;

    return 0;
}
