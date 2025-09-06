#pragma once

// bar_EXPORTS is defined automatically by cmake
// see: https://cmake.org/cmake/help/latest/prop_tgt/DEFINE_SYMBOL.html
#if defined(bar_EXPORTS) && defined(API_VISIBILITY)
#  define PUBLIC_API_BAR __attribute__((visibility("default")))
#else
#  define PUBLIC_API_BAR
#endif

namespace libbar {

PUBLIC_API_BAR int bar();

}  // namespace libbar
