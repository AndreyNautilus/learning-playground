set(TERGET_NAME ${PROJECT_NAME}_test)

add_executable(${TERGET_NAME}
    test.cpp)

target_link_libraries(${TERGET_NAME}
    PUBLIC
        ${PROJECT_NAME}
)

add_test(
    NAME ${TERGET_NAME}
    COMMAND ${TERGET_NAME}
)
