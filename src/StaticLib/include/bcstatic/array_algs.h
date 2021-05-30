#ifndef ARRAY_ALGS_H_
#define ARRAY_ALGS_H_

#include <vector>
namespace bc
{
    // Longest consecutive sequence
    class lcs
    {
    public:
        lcs(const std::vector<int>& v);
        size_t execute();
    private:
        std::vector<int> arr_;
    };
}

#endif