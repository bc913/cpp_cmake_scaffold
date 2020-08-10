#ifndef MYDYNLIB_H
#define MYDYNLIB_H

#include "BcDynApi.h"
#include <string>

namespace BC
{
    class BCDYN_API Person
    {
    private:
        std::string name_;
    public:
        std::string GetName() const;
        void SetName(std::string nameVal);
    };    
}

#endif