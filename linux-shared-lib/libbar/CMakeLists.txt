cmake_minimum_required(VERSION 3.21)

project(bar)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS OFF)

if(BUILD_SHARED_LIBS)
    set(SHARED_LIBBAR_DEFAULT ON)
else()
    set(SHARED_LIBBAR_DEFAULT OFF)
endif()

option(LIBBAR_SHARED "Build libBAR as shared" ${SHARED_LIBBAR_DEFAULT})
message(STATUS "Build libBAR as shared: ${LIBBAR_SHARED}")

option(LIBBAR_API_VISIBILITY "Use __attribute__(visibility) to explicitly export symbols" OFF)
message(STATUS "Use __attribute__(visibility): ${LIBBAR_API_VISIBILITY}")

option(LIBBAR_STRIP "Strip debug info into as separate file" OFF)
message(STATUS "Strip debug info into: ${LIBBAR_STRIP}")

if(LIBBAR_SHARED)
    set(BUILD_TYPE_LIBBAR SHARED)
else()
    set(BUILD_TYPE_LIBBAR STATIC)
endif()

set(PUBLIC_HEADERS
    include/bar.hpp
)

add_library(${PROJECT_NAME} ${BUILD_TYPE_LIBBAR}
    ${PUBLIC_HEADERS}
    src/bar.cpp
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

if(LIBBAR_API_VISIBILITY)
    set_target_properties(${PROJECT_NAME} PROPERTIES
        CXX_VISIBILITY_PRESET hidden
        VISIBILITY_INLINES_HIDDEN true
    )
    target_compile_definitions(${PROJECT_NAME}
        PRIVATE
            API_VISIBILITY=1
    )
endif()

if(LIBBAR_STRIP)
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

install(TARGETS ${PROJECT_NAME}
    LIBRARY DESTINATION lib
    PUBLIC_HEADER DESTINATION include
)
if(DEBUG_INFO_FILE)
    install(FILES ${DEBUG_INFO_FILE} TYPE LIB)
endif()

enable_testing()
add_subdirectory(tests)
