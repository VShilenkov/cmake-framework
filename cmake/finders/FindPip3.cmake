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
FindPip3
--------

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

Locates `package installer for Python <https://pip.pypa.io/en/stable/>`_.

#]=============================================================================]

# declare package properties ------------------------------------------------- #
set_package_properties(${_cmff_NAME}
    PROPERTIES
        URL         "https://pip.pypa.io/en/stable/"
        DESCRIPTION "A package installer for Python"
)

# validate find_package() arguments ------------------------------------------ #
#[=============================================================================[.rst:
Components
^^^^^^^^^^

This module doesn't support components

#]=============================================================================]

## no components supported
if(${_cmff_NAME}_FIND_COMPONENTS AND NOT ${_cmff_NAME}_FIND_QUIETLY)
    message(WARNING "${CF_lp_Pip3} components not supported")
endif()

# requirements --------------------------------------------------------------- #
#[=============================================================================[.rst:
Requirements
^^^^^^^^^^^^

- ``Python 3 Interpreter``

    This module uses :cmake:module:`FindPython3 <cmake_latest:module:FindPython3>`
    to locate ``Python 3 Interpreter``

#]=============================================================================]

if(NOT DEFINED Python3_COMMAND)
    find_package(Python3 COMPONENTS Interpreter REQUIRED)
    set(Python3_COMMAND "${Python3_EXECUTABLE}" CACHE STRING "Command to invoke Python3")
endif()

#[=============================================================================[.rst:

Hints
^^^^^

To provide hints to this module, project code may set next:

CMake Variables
***************

    .. cmake:variable:: Pip3_DIR
                        PIP3_DIR

        Path to the installation root of ``pip3``

Environment variables
*********************

    ..  cmake:envvar:: Pip3_DIR
                       PIP3_DIR

        Same meaning as regular variables have

#]=============================================================================]

# hints ---------------------------------------------------------------------- #
set(${_cmff_NAME}_hints "")
foreach(dir ${_cmff_NAME}_DIR ${_CMFF_NAME}_DIR)
    if(DEFINED ${dir})
        list(APPEND ${_cmff_NAME}_hints "${${dir}}")
    endif()
endforeach()
unset(dir)

execute_process(
    COMMAND ${Python3_COMMAND} -m site --user-base
    RESULT_VARIABLE user_base_dir_result
    OUTPUT_VARIABLE user_base_dir_output
    ERROR_VARIABLE  user_base_dir_error
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_STRIP_TRAILING_WHITESPACE
)

CF_execute_process_fails(user_base_dir WARNING)

if(user_base_dir_result EQUAL 0)
    list(APPEND ${_cmff_NAME}_hints "${user_base_dir_output}")
endif()

CF_execute_process_wipe(user_base_dir)

# find executable ------------------------------------------------------------ #
find_program(${_cmff_NAME}_EXECUTABLE
    NAMES         pip3
    HINTS         ${${_cmff_NAME}_hints}
        ENV       ${_cmff_NAME}_DIR
        ENV       ${_cmff_NAME}_DIR
    PATH_SUFFIXES bin Scripts
    DOC           "The ${_cmff_NAME} executable"
)
unset(${_cmff_NAME}_hints)

## try to find via python
if(NOT ${_cmff_NAME}_EXECUTABLE)
    execute_process(
        COMMAND
            ${Python3_COMMAND} -m pip show pip
        RESULT_VARIABLE pip_command_result
        OUTPUT_VARIABLE pip_command_output
        ERROR_VARIABLE  pip_command_error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
    )

    CF_execute_process_fails(pip_command WARNING)
    if(pip_command_result EQUAL 0)
        set(${_cmff_NAME}_EXECUTABLE "${Python3_COMMAND};-m;pip"
            CACHE
            FILEPATH
            "The ${_cmff_NAME} executable"
        )
    endif()
    CF_execute_process_wipe(pip_command)
endif()

#[=============================================================================[.rst:

Result variables
^^^^^^^^^^^^^^^^
This module will set the following variables in your project:

    .. cmake:variable:: Pip3_FOUND
                        PIP3_FOUND

        Indicates if ``Pip3`` package was found

    .. cmake:variable:: Pip3_EXECUTABLE

        Path to the ``pip3`` executable

    .. cmake:variable:: Pip3_COMMAND

        String that has to be used to call ``pip3``

#]=============================================================================]

# build command -------------------------------------------------------------- #
if(${_cmff_NAME}_EXECUTABLE)
    set(${_cmff_NAME}_COMMAND "${${_cmff_NAME}_EXECUTABLE}" CACHE STRING "The ${_cmff_NAME} command")
    mark_as_advanced(${_cmff_NAME}_EXECUTABLE ${_cmff_NAME}_COMMAND)
endif()

#[=============================================================================[.rst:

    .. cmake:variable:: Pip3_VERSION_STRING

        ``pip3`` full version string

    .. cmake:variable:: Pip3_VERSION_MAJOR

        ``pip3`` major version

    .. cmake:variable:: Pip3_VERSION_MINOR

        ``pip3`` minor version

    .. cmake:variable:: Pip3_VERSION_PATCH

        ``pip3`` version patch

#]=============================================================================]

# find version --------------------------------------------------------------- #
if(${_cmff_NAME}_COMMAND)
    execute_process(
        COMMAND
            ${${_cmff_NAME}_COMMAND} --version
        RESULT_VARIABLE ${_cmff_NAME}_version_result
        OUTPUT_VARIABLE ${_cmff_NAME}_version_output
        ERROR_VARIABLE  ${_cmff_NAME}_version_error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
    )

    CF_execute_process_fails(${_cmff_NAME}_version WARNING)
    if(${_cmff_NAME}_version_result EQUAL 0)
        if(${_cmff_NAME}_version_output MATCHES "pip ([.0-9]+)")
            set(${_cmff_NAME}_VERSION_STRING "${CMAKE_MATCH_1}")

            string(REGEX REPLACE "([0-9]+)\\.[0-9]+\\.[0-9]+" "\\1"
                ${_cmff_NAME}_VERSION_MAJOR ${${_cmff_NAME}_VERSION_STRING}
            )
            string(REGEX REPLACE "[0-9]+\\.([0-9]+)\\.[0-9]+" "\\1"
                ${_cmff_NAME}_VERSION_MINOR ${${_cmff_NAME}_VERSION_STRING}
            )
            string(REGEX REPLACE "[0-9]+\\.[0-9]+\\.([0-9]+)" "\\1"
                ${_cmff_NAME}_VERSION_PATCH ${${_cmff_NAME}_VERSION_STRING}
            )
        endif()
    endif()
    CF_execute_process_wipe(${_cmff_NAME}_version)
endif()

# commands ------------------------------------------------------------------- #
if(${_cmff_NAME}_COMMAND)
    macro(find_pip_package package_name)
        if(NOT ${package_name}_FOUND)

            cmake_parse_arguments(__opts "REQUIRED;QUIET" "" "" ${ARGN})

            execute_process(
                COMMAND
                    ${Pip3_COMMAND} show ${package_name}
                RESULT_VARIABLE pip_show_result
                OUTPUT_VARIABLE pip_show_output
                ERROR_VARIABLE  pip_show_error
                OUTPUT_STRIP_TRAILING_WHITESPACE
                ERROR_STRIP_TRAILING_WHITESPACE
            )

            if(__opts_REQUIRED)
                CF_execute_process_fails(pip_show FATAL_ERROR "find_pip_package: REQUIRED module ${package_name} not found")
            endif()
            if(NOT __opts_QUIET)
                CF_execute_process_fails(pip_show WARNING)
            endif()

            unset(__opts_REQUIRED)
            unset(__opts_QUIET)

            if(pip_show_result EQUAL 0)
                string(REPLACE "\n" ";" pip_show_output "${pip_show_output}")

                foreach(__line IN LISTS pip_show_output)
                    if(__line MATCHES "Version: ([.0-9]+)")
                        set(${package_name}_VERSION_STRING "${CMAKE_MATCH_1}" CACHE STRING "")
                    elseif(__line MATCHES "Summary: (.*)$")
                        set(${package_name}_DESCRIPTION "${CMAKE_MATCH_1}" CACHE STRING "")
                    elseif(__line MATCHES "Location: (.*)$")
                        set(${package_name}_LOCATION "${CMAKE_MATCH_1}" CACHE STRING "")
                    elseif(__line MATCHES "Home-page: (.*)$")
                        set(${package_name}_HOMEPAGE_URL "${CMAKE_MATCH_1}" CACHE STRING "")
                    endif()
                endforeach()

                if(DEFINED ${package_name}_HOMEPAGE_URL OR DEFINED ${package_name}_DESCRIPTION)
                    include(FeatureSummary)
                    set_package_properties(${package_name}
                        PROPERTIES
                            URL         "${${package_name}_HOMEPAGE_URL}"
                            DESCRIPTION "${${package_name}_DESCRIPTION}"
                    )
                endif()

                set(${package_name}_FOUND TRUE)
                string(TOUPPER "${package_name}" PACKAGE_NAME)
                set(${PACKAGE_NAME}_FOUND TRUE)
                set_property(GLOBAL APPEND PROPERTY PACKAGES_FOUND ${package_name})
            endif()
            unset(__line)
            CF_execute_process_wipe(pip_show)
        endif()
    endmacro()
endif()

# handle components, version, quiet, required and other flags ---------------- #
find_package_handle_standard_args(${_cmff_NAME}
    REQUIRED_VARS ${_cmff_NAME}_EXECUTABLE
                  ${_cmff_NAME}_COMMAND
    VERSION_VAR   ${_cmff_NAME}_VERSION_STRING
    FAIL_MESSAGE  "pip3 not found, installation: https://pip.pypa.io/en/stable/installation/"
)

# epilogue ------------------------------------------------------------------- #
CF_find_epilogue()

#[=============================================================================[.rst:

Example usage
^^^^^^^^^^^^^

.. code-block:: cmake

    find_package(Pip3 REQUIRED)

    execute_process(
        COMMAND         ${Pip3_COMMAND} -version
        OUTPUT_VARIABLE Pip3_VERSION_RAW
        ERROR_VARIABLE  Pip3_VERSION_RAW
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

#]=============================================================================]
