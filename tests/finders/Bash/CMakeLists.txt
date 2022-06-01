cmake_minimum_required(VERSION 3.21)

project(CF-Find-Bash-Test)

set(__test_lp "[CF-test] FindBash:")

CF_test_collect_status(before)

find_package(Bash)

CF_test_collect_status(after)

CF_not_defined(Bash_FOUND FATAL_ERROR)

if(Bash_FOUND)

    CF_test_expect_targets(${PROJECT_NAME}_imported_targets_before
                           ${PROJECT_NAME}_imported_targets_after
        TARGETS
            Bash::Bash
    )

    CF_test_expect_variables(${PROJECT_NAME}_variables_before
                             ${PROJECT_NAME}_variables_after
        VARIABLES
            BASH_FOUND
            Bash_FOUND
            Bash_VERSION_MAJOR
            Bash_VERSION_MINOR
            Bash_VERSION_PATCH
            Bash_VERSION_STRING
        CACHED
            Bash_COMMAND
            Bash_EXECUTABLE
    )

else()
    CF_test_expect_targets(${PROJECT_NAME}_imported_targets_before
                           ${PROJECT_NAME}_imported_targets_after
    )

    CF_test_expect_variables(${PROJECT_NAME}_variables_before
                             ${PROJECT_NAME}_variables_after
        VARIABLES
            BASH_FOUND
            Bash_FOUND
        CACHED
            Bash_EXECUTABLE
    )
endif()

CF_test_expect_commands(${PROJECT_NAME}_commands_before
                        ${PROJECT_NAME}_commands_after
)

CF_test_expect_macros(${PROJECT_NAME}_macros_before
                      ${PROJECT_NAME}_macros_after
)
