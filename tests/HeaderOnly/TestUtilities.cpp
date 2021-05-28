#include <gtest/gtest.h>
#include <BcHeaderOnly/Utilities.h>

TEST(TestUtilitiesFixture, GetMax)
{
    auto x = 4;
    auto y = 5;
    EXPECT_TRUE(5 == BC::Utilities::Max(x, y));
}