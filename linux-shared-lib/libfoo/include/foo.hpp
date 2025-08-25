#pragma once

// foo_EXPORTS is defined automatically by cmake
// see: https://cmake.org/cmake/help/latest/prop_tgt/DEFINE_SYMBOL.html
#ifdef foo_EXPORTS
#   define PUBLIC_API __attribute__((visibility("default")))
#else
#   define PUBLIC_API
#endif

namespace libfoo {

PUBLIC_API int foo();

bool foo2();

}  // libfoo
