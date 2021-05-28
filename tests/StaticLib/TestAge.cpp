#include <gtest/gtest.h>
#include <BcStatic/Age.h>

TEST(TestAgeFixture, GetValue)
{
    auto age = BC::Age();
    EXPECT_FALSE(9 == age.getValue());
}