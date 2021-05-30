#include <gtest/gtest.h>
#include <bcstatic/array_algs.h>

TEST(TestLongestConsecutiveSequence, IntArray)
{
    std::vector<int> arr = {1, 2, 3};
    auto lcs = bc::lcs(arr);
    auto res = lcs.execute();
    EXPECT_TRUE(1 == res);    
}