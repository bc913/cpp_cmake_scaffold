#include <memory>

namespace BC
{
    class Age
    {
    private:
        int value_ = 5;
    public:
        int getValue() const;
        int getValueWithMultiply(int factor);
        int getValueWithSum(int addition);
    };    
}