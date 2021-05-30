#ifndef EMPLOYEE_H_
#define EMPLOYEE_H_

#include "BcDynApi.h"
#include <string>
#include <vector>

namespace bc
{
    class BCDYN_API employee
    {
    private:
        std::string name_;
    public:
        const std::string& get_name() const;
        void set_name(std::string val);
        std::vector<int> get_badges() const;
    };    
}

#endif