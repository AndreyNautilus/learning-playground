#include "foo.hpp"

#include "internal.hpp"

#include <iostream>

namespace libfoo {

int ClassA::foo() {
  const auto msg = internal::foo_internal();
  std::cout << "ClassA::foo: " << msg << std::endl;
  auto result = msg.size();
  return msg.size();
}

int foo() {
  const auto msg = internal::foo_internal();
  std::cout << "foo: " << msg << std::endl;
  return msg.size();
}

bool foo2() {
  const auto msg = internal::foo_internal();
  return msg.size() > 5;
}

}  // namespace libfoo
