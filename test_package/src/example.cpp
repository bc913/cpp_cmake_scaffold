#include <bcstatic/array_algs.h>
#include <bcheaderonly/sort.h>
#include <bcdynamic/employee.h>
#include <vector>
#include <cstdlib>
#include <iostream>
#include <algorithm>
#include <iterator>

template<typename Iter>
void print_container(Iter begin, Iter end, std::ostream& os = std::cout, const char* delim = " ")
{
    std::copy(begin, end, std::ostream_iterator<typename std::iterator_traits<Iter>::value_type>(os, delim));
}

int main() {
    std::vector<int> arr = {1, 2, 3};
    auto lcs = bc::lcs(arr);
    std::cout << "LCS: " << lcs.execute() << "\n";

    bc::heap_sort(arr.begin(), arr.end());
    print_container(arr.begin(), arr.end());

    auto e = bc::employee();
    e.set_name("Anelka");
    std::cout << "\nName: " << e.get_name() << "\n";

    return EXIT_SUCCESS;
}
