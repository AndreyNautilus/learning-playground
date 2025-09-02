#include "foo.hpp"
#include "internal.hpp"
#include <iostream>

namespace libfoo {
int foo() {
    const auto msg = internal::foo_internal();
    std::cout << "foo: " << msg << std::endl;
    return msg.size();
}

bool foo2() {
    const auto msg = internal::foo_internal();
    return msg.size() > 5;
}

}
