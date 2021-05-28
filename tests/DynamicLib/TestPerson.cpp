#include <gtest/gtest.h>
#include <BcDynamic/Person.h>

TEST(TestPersonFixture, SetName)
{
    auto person = BC::Person();
    person.SetName("Alex");
    EXPECT_TRUE("Alex" == person.GetName());
}