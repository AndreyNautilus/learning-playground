#include "foo.hpp"

#include "internal.hpp"
#ifdef WITH_LIBBAR
#  include <bar.hpp>
#endif
#include <iostream>

namespace libfoo {

int ClassA::foo() {
  const auto msg = internal::foo_internal();
  std::cout << "ClassA::foo: " << msg << std::endl;
  auto result = msg.size();
  return msg.size()
#ifdef WITH_LIBBAR
         + libbar::bar()
#endif
      ;
}

int foo() {
  const auto msg = internal::foo_internal();
  std::cout << "foo: " << msg << std::endl;
  return msg.size()
#ifdef WITH_LIBBAR
         + libbar::bar()
#endif
      ;
}

bool foo2() {
  const auto msg = internal::foo_internal();
  return msg.size() > 5;
}

}  // namespace libfoo
