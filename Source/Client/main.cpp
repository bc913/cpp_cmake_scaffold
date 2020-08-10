#include <iostream>
#include <BcStatic/Age.h>
#include <BcDynamic/Person.h>
#include <BcHeaderOnly/Utilities.h>

int main(int argc, char *argv[])
{
    std::cout << "== Client executable target is consuming static library ==" << std::endl;
    auto age = BC::Age();
    std::cout << "Age value: " << age.getValue() << std::endl;
    std::cout << STATIC_LIB_DEF << std::endl;

    std::cout << "== Client executable target is consuming shared library ==" << std::endl;
    auto person = BC::Person();
    person.SetName("bc913 ");
    std::cout << "Person's name: " << person.GetName() << std::endl;
    std::cout << DYNAMIC_LIB_DEF << std::endl;

    std::cout << "== Client executable target is consuming header-only library ==" << std::endl;
    std::cout << "Max(5,6): " << BC::Utilities::Max(5, 6) << std::endl;
    std::cout << HEADER_ONLY_LIB_DEF << std::endl;

    return 0;
}