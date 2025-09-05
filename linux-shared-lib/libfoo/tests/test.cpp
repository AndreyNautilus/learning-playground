#include "foo.hpp"

#include <iostream>

int main() {
  const auto n = libfoo::foo();
  std::cout << n << std::endl;

  // fails to compile if libfoo uses PUBLIC_API macro to define symbol
  // visibility
  // const auto b = libfoo::foo2();
  // std::cout << b << std::endl;
  return 0;
}
