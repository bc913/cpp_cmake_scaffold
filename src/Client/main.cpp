#include <iostream>
#include <bcheaderonly/sort.h>
#include <bcstatic/array_algs.h>
#include <bcdynamic/employee.h>


int main(int argc, char *argv[])
{

    std::cout << "== Client executable target is consuming header-only library ==" << "\n";
    std::vector<std::string> names = {"Anelka", "Appiah", "Alex"};
    bc::heap_sort(names.begin(), names.end());
    for(const auto& s : names)
        std::cout << s << " ";
    std::cout << "\n";
    std::cout << HEADER_ONLY_LIB_DEF << "\n";


    std::cout << "== Client executable target is consuming static library ==" << "\n";
    std::vector<int> arr = {1, 2, 3};
    auto lcs = bc::lcs(arr);
    std::cout << "LCS: " << lcs.execute() << "\n";
    std::cout << STATIC_LIB_DEF << "\n";


    std::cout << "== Client executable target is consuming shared library ==" << "\n";
     auto e = bc::employee();
    e.set_name("Anelka");
    std::cout << "Name: " << e.get_name() << "\n";
    std::cout << DYNAMIC_LIB_DEF << "\n";    

    return 0;
}