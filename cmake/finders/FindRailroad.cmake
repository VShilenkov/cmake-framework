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

#[=============================================================================[.rst:
FindRailroad
------------

.. only:: html

   .. contents::
   
#]=============================================================================]

# includes ------------------------------------------------------------------- #
include(FeatureSummary)
include(FindPackageHandleStandardArgs)

# prologue ------------------------------------------------------------------- #
CF_find_prologue()

#[=============================================================================[.rst:

Synopsis
^^^^^^^^

Locates `Railroad Generator <https://bottlecaps.de/rr/ui>`_
- a tool for generation railroad diagrams.

#]=============================================================================]

# declare package properties ------------------------------------------------- #
set_package_properties(${_cmff_NAME}
    PROPERTIES
        URL         "https://bottlecaps.de/rr/ui"
        DESCRIPTION "A Tool for generation railroad diagrams"
)

# validate find_package() arguments ------------------------------------------ #

#[=============================================================================[.rst:
Components
^^^^^^^^^^

This module doesn't support components

#]=============================================================================]

## no components supported
if(${_cmff_NAME}_FIND_COMPONENTS AND NOT ${_cmff_NAME}_FIND_QUIETLY)
    message(WARNING "${CF_lp_Railroad} components not supported")
endif()

#[=============================================================================[.rst:

Hints
^^^^^

To provide hints to this module, project code may set next:

CMake Variables
***************

    .. cmake:variable:: Railroad_DIR
                        RAILROAD_DIR

        Path to the installation root of ``Railroad`` war file

Environment variables
*********************

    ..  cmake:envvar:: Railroad_DIR
                       RAILROAD_DIR

        Same meaning as regular variables have

#]=============================================================================]

## hints --------------------------------------------------------------------- #
set(${_cmff_NAME}_hints "")
foreach(dir ${_cmff_NAME}_DIR ${_CMFF_NAME}_DIR)
    if(DEFINED ${dir})
        list(APPEND ${_cmff_NAME}_hints "${${dir}}")
    endif()
endforeach()
unset(dir)

#[=============================================================================[.rst:
Dependencies
^^^^^^^^^^^^

This module requires Java Runtime and will use 
:cmake:module:`FindJava <cmake_latest:module:FindJava>`.
Also it will include :cmake:module:`UseJava <cmake_latest:module:UseJava>`
to be able to look for ``.jar``/``.war`` files.

#]=============================================================================]

# dependencies --------------------------------------------------------------- #
find_package(Java REQUIRED COMPONENTS Runtime)

include(UseJava)


set(_find_jar_paths "")
set(_find_jar_version "")

if(${_cmff_NAME}_hints)
    list(APPEND _find_jar_paths "${_cmff_NAME}_hints")
    string(PREPEND _find_jar_paths "PATHS ")
endif()
unset(${_cmff_NAME}_hints)

if(${_cmff_NAME}_FIND_VERSION)
    set(_find_jar_version "VERSIONS ${${_cmff_NAME}_FIND_VERSION}")
endif()

find_jar(${_cmff_NAME}_JAR rr.war
    ${_find_jar_paths}
    ${_find_jar_version}
    DOC "Railroad diagram generator"
)

unset(_find_jar_paths)
unset(_find_jar_version)

# we will try to fetch content
if(NOT ${_cmff_NAME}_JAR)
    set(_try_fetch FALSE)
    if(${_cmff_NAME}_FIND_VERSION)
        set(${_cmff_NAME}_KNOWN_VERSION 1.63)
        if(   (${_cmff_NAME}_FIND_VERSION_EXACT AND ${_cmff_NAME}_FIND_VERSION VERSION_EQUAL ${_cmff_NAME}_KNOWN_VERSION) 
           OR (NOT ${_cmff_NAME}_FIND_VERSION_EXACT AND ${_cmff_NAME}_FIND_VERSION VERSION_LESS_EQUAL ${_cmff_NAME}_KNOWN_VERSION))
            set(_try_fetch TRUE)
        endif()
    else()
        set(_try_fetch TRUE)
    endif()

    if(_try_fetch)
        if(POLICY CMP0135)
            cmake_policy(PUSH)
            cmake_policy(SET CMP0135 NEW)
        endif()

        include(FetchContent)

        FetchContent_Declare(
            ${_cmff_NAME}_jar_package 
            URL "https://github.com/GuntherRademacher/rr/releases/download/v1.63/rr-1.63-java8.zip"
        )

        FetchContent_MakeAvailable(${_cmff_NAME}_jar_package)

        if(EXISTS ${${_cMFF_NAME}_jar_package_SOURCE_DIR}/rr.war)
            set(${_cmff_NAME}_JAR ${${_cMFF_NAME}_jar_package_SOURCE_DIR}/rr.war)
            string(STRIP "${${_cmff_NAME}_JAR}" ${_cmff_NAME}_JAR)
            set(${_cmff_NAME}_JAR "${${_cmff_NAME}_JAR}" CACHE FILEPATH "Path to rr.war file" FORCE)
            set(${_cmff_NAME}_FOUND TRUE CACHE BOOL "" FORCE)
        endif()

        if(POLICY CMP0135)
            cmake_policy(POP)
        endif()
    endif()
    unset(_try_fetch)
endif()

if(${_cmff_NAME}_JAR)
    set(${_cmff_NAME}_COMMAND "${Java_JAVA_EXECUTABLE};-jar;${${_cmff_NAME}_JAR}" CACHE STRING "Railroad command")
endif()

# handle components, version, quiet, required and other flags ---------------- #
find_package_handle_standard_args(${_cmff_NAME}
    REQUIRED_VARS ${_cmff_NAME}_COMMAND
                  ${_cmff_NAME}_JAR
    FAIL_MESSAGE  "rr.war not found, installation: https://github.com/GuntherRademacher/rr/releases"
    HANDLE_COMPONENTS
)

# epilogue ------------------------------------------------------------------- #
CF_find_epilogue()

#[=============================================================================[.rst:

Example usage
^^^^^^^^^^^^^

.. code-block:: cmake

    find_package(Railroad REQUIRED)

    execute_process(
        COMMAND         ${Railroad_COMMAND}
        OUTPUT_VARIABLE Railroad_OUTPUT_RAW
        ERROR_VARIABLE  Railroad_OUTPUT_RAW
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

#]=============================================================================]