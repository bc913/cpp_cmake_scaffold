#include <gtest/gtest.h>
#include <bcheaderonly/sort.h>
#include <vector>

TEST(TestIntArraySort, IncreasingSort)
{
    std::vector<int> arr = {1, -3, 4};
    bc::heap_sort(arr.begin(), arr.end());
    
    EXPECT_TRUE(-3 == arr.at(0));
    EXPECT_TRUE(1 == arr.at(1));
    EXPECT_TRUE(4 == arr.at(2));
}