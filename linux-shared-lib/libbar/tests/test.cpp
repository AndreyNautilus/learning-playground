#include <bar.hpp>
#include <iostream>

int main() {
  const auto n = libbar::bar();
  std::cout << n << std::endl;

  return 0;
}
