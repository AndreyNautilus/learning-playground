#pragma once

// foo_EXPORTS is defined automatically by cmake
// see: https://cmake.org/cmake/help/latest/prop_tgt/DEFINE_SYMBOL.html
#if defined(foo_EXPORTS) && defined(API_VISIBILITY)
#   define PUBLIC_API_FOO __attribute__((visibility("default")))
#else
#   define PUBLIC_API_FOO
#endif

namespace libfoo {

class PUBLIC_API_FOO ClassA {
public:
    int foo();
};

PUBLIC_API_FOO int foo();

bool foo2();

}  // libfoo
