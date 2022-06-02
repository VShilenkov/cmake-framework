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

# Requirements to CMake ------------------------------------------------------ #
cmake_minimum_required(VERSION 3.12)

# Includes ---------------------------------------------------------------------
include(CMakePackageConfigHelpers)

CF_not_defined(${PROJECT_NAME}-INSTALL_DIR FATAL_ERROR)

set(${PROJECT_NAME}-CONFIG_INSTALL_DIR "${PROJECT_NAME}")

# Create config and version files for CMakeFramework ------------------------- #
configure_package_config_file(${PROJECT_NAME}Config.cmake.in
                              ${PROJECT_NAME}Config.cmake
    INSTALL_DESTINATION "${${PROJECT_NAME}-CONFIG_INSTALL_DIR}"
    PATH_VARS           CMakeFramework-INSTALL_DIR
    NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

if(NOT CMAKE_VERSION LESS "3.14")
    write_basic_package_version_file(${PROJECT_NAME}Version.cmake
        VERSION       ${PROJECT_VERSION}
        COMPATIBILITY AnyNewerVersion
        ARCH_INDEPENDENT
    )
else()
    write_basic_package_version_file(${PROJECT_NAME}Version.cmake
        VERSION       ${PROJECT_VERSION}
        COMPATIBILITY AnyNewerVersion
    )
endif()

# installing config and version files ---------------------------------------- #
install(FILES   ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
                ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Version.cmake
    DESTINATION ${${PROJECT_NAME}-CONFIG_INSTALL_DIR}
    COMPONENT   package::config
)
