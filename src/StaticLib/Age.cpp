#include "include/BcStatic/Age.h"
#include "Calculator.h"
#include <BcHeaderOnly/Utilities.h>
#include <iostream>

namespace BC
{
    int Age::getValue() const
    {
        std::cout << "Static library is consuming header-only library..." << std::endl;
        std::cout << "Max(age, 8): " << BC::Utilities::Max(value_, 8) << std::endl;
        return value_;
    }

    int Age::getValueWithMultiply(int factor)
    {
        auto calc = BC::Calculator();
        return calc.Multiply(value_, factor);
    }

    int Age::getValueWithSum(int addition)
    {
        auto calc = BC::Calculator();
        return calc.Sum(value_, addition);
    }
}


