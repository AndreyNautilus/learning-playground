cmake_minimum_required(VERSION 3.20)

project(app)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS OFF)

if(NOT TARGET foo)
    # 'foo' target is not defined, need to define it manually and
    # point it to the file on the disk
    set(LIBFOO_BASE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libs CACHE STRING "Base folder of libfoo location")
    message(STATUS "Expecting libfoo to be in ${LIBFOO_BASE_DIR}")

    file(REAL_PATH ${LIBFOO_BASE_DIR}/lib/libfoo.so LIBFOO_SO_PATH BASE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} EXPAND_TILDE)
    file(REAL_PATH ${LIBFOO_BASE_DIR}/include LIBFOO_INCLUDE BASE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} EXPAND_TILDE)

    message(STATUS "Found libfoo.so in ${LIBFOO_SO_PATH}")
    message(STATUS "Found libfoo headers in ${LIBFOO_INCLUDE}")

    # Imported targets: https://cmake.org/cmake/help/latest/command/add_library.html#imported-libraries
    add_library(foo SHARED IMPORTED)
    set_target_properties(foo PROPERTIES
        IMPORTED_LOCATION ${LIBFOO_SO_PATH}
        IMPORTED_SONAME libfoo.so
    )
    target_include_directories(foo
        INTERFACE
            ${LIBFOO_INCLUDE}
    )
endif()

add_executable(${PROJECT_NAME}
    src/main.cpp
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        foo
)
