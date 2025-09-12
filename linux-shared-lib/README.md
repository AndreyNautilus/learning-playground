# A setup for shared library development and distribution

Example code for [the blog post](https://andreynautilus.github.io/posts/2025-09-02-distributing-linux-so/).

## Setup

- `libfoo` - a library that can be built as either `STATIC` or `SHARED`;
- `app` - an app that consumes `libfoo`. Can consume static library as regular cmake target
  or shared library as imported cmake target.
- `docker` - contains images for CI;

## Build instructions

Prerequisites

- cmake >= 3.20
- make or ninja
- gcc or clang

**cmake options** (to be passed as `-D` to `cmake` command):

- `BUILD_SHARED_LIBS` - [standard option](https://cmake.org/cmake/help/latest/variable/BUILD_SHARED_LIBS.html) to build libs as shared. Default: OFF.
- `CMAKE_BUILD_TYPE` - [standard option](https://cmake.org/cmake/help/latest/variable/CMAKE_BUILD_TYPE.html) to set the build type (Debug, Release, etc);

**libfoo** options:

- `LIBFOO_SHARED` - build `libfoo` as shared/static. Overrides `BUILD_SHARED_LIBS`. Default: OFF.
- `LIBFOO_USE_VERSION_SCRIPT` - use `libfoo.map` version script file to define symbol visibility. Default: OFF.
- `LIBFOO_API_VISIBILITY` - hide symbols by default and use attributes to annotate symbols to export. Default: OFF.
- `LIBFOO_STRIP` - split debug info into `*.debug` file. Pass `--strip` to `cmake --install` to get stripped binary. Default: OFF.
- `LIBFOO_VERSIONING` - set `SONAME` explicitly. Default: OFF.

**app** options:

- `LIBFOO_BASE_DIR` - directory where `libfoo` is installed.
  `${LIBFOO_BASE_DIR}/lib/libfoo.so` must point to a library file,
  `${LIBFOO_BASE_DIR}/include` must point to the include directory of `libfoo`.

**Build everything as one project**

```bash
mkdir build && cd build
cmake .. && cmake --build . && ctest
./app/app  # run the app
```

**Build libfoo**

```bash
cd libfoo
mkdir build && cd build
cmake .. && cmake --build . && ctest
```

**Build libfoo as shared and app consumes it as imported target**

```bash
# build and install libfoo
cd libfoo
mkdir build && cd build
cmake -DBUILD_SHARED_LIBS=ON .. && cmake --build . && ctest && cmake --install . --prefix=../out
# build the app
cd ../../app
mkdir build && cd build
cmake -DLIBFOO_BASE_DIR=../libfoo/out .. && cmake --build
# run the app
./app
```
