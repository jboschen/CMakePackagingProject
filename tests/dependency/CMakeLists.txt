set(
        DEPEND_TESTS find_dependency
                     find_or_build_dependency
                     record_find
                     sanitize_version
                     special_find
)

foreach(test_i ${DEPEND_TESTS})
    cpp_cmake_unit_test(${test_i})
endforeach()
