#include "foo.hpp"
#include <iostream>

int main() {
    const auto n = libfoo::foo();
    std::cout << "Number: " << n << std::endl;

    return 0;
}
