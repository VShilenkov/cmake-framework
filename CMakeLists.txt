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

# Project declaration -------------------------------------------------------- #
project(CMakeFramework
    VERSION      0.0.1
    DESCRIPTION  "Collection of modules, finders and scripts"
    HOMEPAGE_URL https://cmake-framework.readthedocs.io/
    LANGUAGES    NONE
)

# Includes ------------------------------------------------------------------- #

include(FeatureSummary)

# framework init
include(cmake/modules/Init.cmake)

# CMake native modules

# Utility modules
include(GlobalOptions)

# Documenting ---------------------------------------------------------------- #
if(WITH_DOCUMENTING)
    add_subdirectory(docs)
endif()

# Testing -------------------------------------------------------------------- #
if(WITH_UNIT_TEST)
    add_subdirectory(tests)
endif()

#TODO:VSH installation

# Feature summary ------------------------------------------------------------ #
feature_summary(WHAT ALL
    DESCRIPTION "-- [${PROJECT_NAME} summary] ---------------------------------"
)