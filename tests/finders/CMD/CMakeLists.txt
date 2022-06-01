#[================[ LICENSE ]==================================================]

MIT License

Copyright (c) 2022 Vitalii Shylienkov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

#]================]

cmake_minimum_required(VERSION 3.21)

project(CF-Find-CMD-Test)

set(__test_lp "[CF-test] FindCMD:")

CF_test_collect_status(before)

find_package(CMD)

CF_test_collect_status(after)

CF_not_defined(CMD_FOUND FATAL_ERROR)

if(CMD_FOUND)

    CF_test_expect_targets(${PROJECT_NAME}_imported_targets_before
                           ${PROJECT_NAME}_imported_targets_after
        TARGETS
            CMD::CMD
    )

    CF_test_expect_variables(${PROJECT_NAME}_variables_before
                             ${PROJECT_NAME}_variables_after
        VARIABLES
            CMD_FOUND
        CACHED
            CMD_COMMAND
            CMD_EXECUTABLE
    )

else()
    CF_test_expect_targets(${PROJECT_NAME}_imported_targets_before
                           ${PROJECT_NAME}_imported_targets_after
    )

    CF_test_expect_variables(${PROJECT_NAME}_variables_before
                             ${PROJECT_NAME}_variables_after
        VARIABLES
            CMD_FOUND
        CACHED
            CMD_EXECUTABLE
    )
endif()

CF_test_expect_commands(${PROJECT_NAME}_commands_before
                        ${PROJECT_NAME}_commands_after
)

CF_test_expect_macros(${PROJECT_NAME}_macros_before
                      ${PROJECT_NAME}_macros_after
)
