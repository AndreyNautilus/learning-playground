# A setup for shared library development and distribution

Example code for the blog post.

## Setup

- `libfoo` - a library that can be built as either `STATIC` or `SHARED`;
- `app` - an app that consumes `libfoo`. Can consume static library as regular cmake target
  or shared library as imported cmake target.

## Build instructions

Prerequisites

- cmake >= 3.20
- make or ninja
- gcc or clang

**cmake options** (to be passed as `-D` to `cmake` command):

- `BUILD_SHARED_LIBS` - [standard option](https://cmake.org/cmake/help/latest/variable/BUILD_SHARED_LIBS.html) to build libs as shared. Default: OFF.
- `CMAKE_BUILD_TYPE` - [standard option](https://cmake.org/cmake/help/latest/variable/CMAKE_BUILD_TYPE.html) to set the build type (Debug, Release, etc);
- `LIBFOO_SHARED` (for `libfoo` project) - build `libfoo` as shared/static. Overrides `BUILD_SHARED_LIBS`. Default: OFF.
- `LIBFOO_BASE_DIR` (for `app` project) - directory where `libfoo` is installed,
  `${LIBFOO_BASE_DIR}/lib/libfoo.so` must point to a library file,
  `${LIBFOO_BASE_DIR}/include` must point to the include directory of `libfoo`.

**Build everything as one project**

```bash
mkdir build
cd build
cmake .. && cmake --build . && ctest
./app/app  # run the app
```

**Build libfoo**

```bash
cd libfoo
mkdir build
cd build
cmake .. && cmake --build . && ctest
```

**Build libfoo as shared and app consumes it as imported target**

```bash
# build and install libfoo
cd libfoo
mkdir build
cd build
cmake -DLIBFOO_SHARED=1 .. && cmake --build . && ctest && cmake --install . --prefix=../../app/libs
# build the app
cd ../../app
mkdir build
cd build
cmake .. && cmake --build
# run the app
./app
```
