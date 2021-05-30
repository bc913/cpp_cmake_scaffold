#include <gtest/gtest.h>
#include <bcdynamic/employee.h>

TEST(TestEmployee, SetName)
{
    auto e = bc::employee();
    e.set_name("Anelka");
    EXPECT_TRUE("Anelka" == e.get_name());
}