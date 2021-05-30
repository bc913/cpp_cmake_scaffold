#include "bcdynamic/employee.h"
#include <bcheaderonly/sort.h>

namespace bc
{
    const std::string& employee::get_name() const {
        return name_;
    }

    void employee::set_name(std::string val) {
        name_ = val;
    }

    std::vector<int> employee::get_badges() const {
        std::vector<int> res = {1, 4, -1, -2, 6};
        bc::heap_sort(res.begin(), res.end());
        return res;
    }
}
