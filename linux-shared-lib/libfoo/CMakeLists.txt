cmake_minimum_required(VERSION 3.20)

project(foo)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS OFF)

if(BUILD_SHARED_LIBS)
    set(SHARED_LIBFOO_DEFAULT ON)
else()
    set(SHARED_LIBFOO_DEFAULT OFF)
endif()

option(LIBFOO_SHARED "Build libfoo as shared" ${SHARED_LIBFOO_DEFAULT})
message(STATUS "Build libfoo as shared: ${LIBFOO_SHARED}")

option(LIBFOO_USE_VERSION_SCRIPT "Use version script file to define symbol visibility" OFF)
message(STATUS "Use version script file: ${LIBFOO_USE_VERSION_SCRIPT}")

option(LIBFOO_API_VISIBILITY "Use __attribute__(visibility) to explicitly export symbols" OFF)
message(STATUS "Use __attribute__(visibility): ${LIBFOO_API_VISIBILITY}")

option(LIBFOO_STRIP "Strip debug info into as separate file" OFF)
message(STATUS "Strip debug info into: ${LIBFOO_STRIP}")

option(LIBFOO_VERSIONING "Add version to so file" OFF)
message(STATUS "Strip debug info into: ${LIBFOO_VERSIONING}")

if(LIBFOO_SHARED)
    set(BUILD_TYPE_LIBFOO SHARED)
else()
    set(BUILD_TYPE_LIBFOO STATIC)
endif()

set(PUBLIC_HEADERS
    include/foo.hpp
)

add_library(${PROJECT_NAME} ${BUILD_TYPE_LIBFOO}
    ${PUBLIC_HEADERS}
    src/foo.cpp
    src/internal.hpp
    src/internal.cpp
)
target_include_directories(${PROJECT_NAME}
    PUBLIC
        include
    PRIVATE
        .
)
set_target_properties(${PROJECT_NAME} PROPERTIES
    PUBLIC_HEADER ${PUBLIC_HEADERS}
)

if(LIBFOO_API_VISIBILITY)
    set_target_properties(${PROJECT_NAME} PROPERTIES
        CXX_VISIBILITY_PRESET hidden
        VISIBILITY_INLINES_HIDDEN true
    )
    target_compile_definitions(${PROJECT_NAME}
        PRIVATE
            API_VISIBILITY=1
    )
endif()

if(LIBFOO_USE_VERSION_SCRIPT)
    set(VERSION_SCRIPT_FILE ${CMAKE_CURRENT_SOURCE_DIR}/libfoo.map)
    set_target_properties(${PROJECT_NAME} PROPERTIES
        LINK_FLAGS "-Wl,--version-script='${VERSION_SCRIPT_FILE}'"
        LINK_DEPENDS ${VERSION_SCRIPT_FILE}
    )
endif()

if(LIBFOO_STRIP)
    if(CMAKE_OBJCOPY)
        set(DEBUG_INFO_FILE "$<TARGET_FILE:${PROJECT_NAME}>.debug")
        add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
            COMMENT "Stripping debug symbols of ${PROJECT_NAME} into a separate file"
            COMMAND ${CMAKE_OBJCOPY} --only-keep-debug "$<TARGET_FILE:${PROJECT_NAME}>" "${DEBUG_INFO_FILE}"
            COMMAND ${CMAKE_OBJCOPY} --strip-debug --add-gnu-debuglink="${DEBUG_INFO_FILE}" "$<TARGET_FILE:${PROJECT_NAME}>"
        )
    else()
        message(SEND_ERROR "objcopy not found, cannot strip debug symbols")
    endif()
endif()

if(LIBFOO_VERSIONING)
    set_target_properties(${PROJECT_NAME} PROPERTIES
        VERSION 1.2.3
        SOVERSION 1
    )
endif()

install(TARGETS ${PROJECT_NAME}
    LIBRARY DESTINATION lib
    PUBLIC_HEADER DESTINATION include
)
if(DEBUG_INFO_FILE)
    install(FILES ${DEBUG_INFO_FILE} DESTINATION lib)
endif()

enable_testing()
add_subdirectory(tests)
