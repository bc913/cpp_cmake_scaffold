#include "bcstatic/array_algs.h"
#include <bcheaderonly/sort.h>

namespace bc
{
    lcs::lcs(const std::vector<int>& v) : arr_(v) {}

    size_t lcs::execute() {
        if(arr_.empty())
            return 0;
        
        bc::heap_sort(arr_.begin(), arr_.end());
        size_t max_len = 0, curr = 1;
        for(auto i = arr_.size() - 1; 1 <= i; --i){
            
            if(arr_[i] - arr_[i-1] == 1) curr++;
            else if(arr_[i] == arr_[i-1]) continue;
            else {
                max_len = curr > max_len ? curr : max_len;
                curr = 1;
            }
        }

        max_len = curr > max_len ? curr : max_len;
        return max_len;
    }
}

