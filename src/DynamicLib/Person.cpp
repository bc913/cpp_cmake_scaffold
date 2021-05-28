#include "include/BcDynamic/Person.h"
#include <BcStatic/Age.h>
#include <iostream>

namespace BC
{
    std::string Person::GetName() const
    {
        std::cout << "Shared library is consuming static library" << std::endl;
        auto age = BC::Age();
        auto nameToReturn = std::to_string(age.getValue());
        return nameToReturn + name_;
    }

    void Person::SetName(std::string nameVal) { name_ = nameVal;}  
}
