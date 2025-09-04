#include "foo.hpp"
#include <iostream>

int main() {
    const auto n = libfoo::foo();
    std::cout << "Number from function: " << n << std::endl;

    libfoo::ClassA obj;
    const auto n_from_obj = obj.foo();
    std::cout << "Number from class: " << n_from_obj << std::endl;

    return 0;
}
