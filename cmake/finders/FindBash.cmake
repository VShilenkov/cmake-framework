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
FindBash
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

Locates `Bourne Again SHell <http://tiswww.case.edu/php/chet/bash/bashtop.html>`_
- a GNU Project's shell.

#]=============================================================================]

# declare package properties ------------------------------------------------- #
set_package_properties(${_cmff_NAME}
    PROPERTIES
        URL         "http://tiswww.case.edu/php/chet/bash/bashtop.html"
        DESCRIPTION "A GNU Project's shell—the Bourne Again SHell"
)

# validate find_package() arguments ------------------------------------------ #

#[=============================================================================[.rst:
Components
^^^^^^^^^^

This module doesn't support components

#]=============================================================================]

## no components supported
if(${_cmff_NAME}_FIND_COMPONENTS AND NOT ${_cmff_NAME}_FIND_QUIETLY)
    message(WARNING "${CF_lp_Bash} components not supported")
endif()

#[=============================================================================[.rst:

Hints
^^^^^

To provide hints to this module, project code may set next:

CMake Variables
***************

    .. cmake:variable:: Bash_DIR
                        BASH_DIR

    Path to the installation root of ``bash``

Environment variables
*********************

    ..  cmake:envvar:: Bash_DIR
                       BASH_DIR

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

# find executable ------------------------------------------------------------ #
find_program(${_cmff_NAME}_EXECUTABLE
    NAMES         bash
    HINTS         ${${_cmff_NAME}_hints}
        ENV       ${_cmff_NAME}_DIR
        ENV       ${_cmff_NAME}_DIR
    DOC           "The ${_cmff_NAME} executable"
)
unset(${_cmff_NAME}_hints)

#[=============================================================================[.rst:

Imported Targets
^^^^^^^^^^^^^^^^
If :cmake:prop_gbl:`CMAKE_ROLE <cmake_latest:prop_gbl:CMAKE_ROLE>` is ``PROJECT``
this module defines the following :ref:`Imported Targets <Imported Targets>`:

    ``Bash::Bash``

        ``bash`` target, defined if ``bash`` is found.

#]=============================================================================]

# imported targets ----------------------------------------------------------- #
get_property(_${_cmff_NAME}_CMAKE_ROLE GLOBAL PROPERTY CMAKE_ROLE)
if(${_cmff_NAME}_EXECUTABLE AND _${_cmff_NAME}_CMAKE_ROLE STREQUAL "PROJECT")
    if(NOT TARGET ${_cmff_NAME}::${_cmff_NAME})
        add_executable(${_cmff_NAME}::${_cmff_NAME} IMPORTED)
        set_property(TARGET ${_cmff_NAME}::${_cmff_NAME}
            PROPERTY 
                IMPORTED_LOCATION "${${_cmff_NAME}_EXECUTABLE}")
    endif()
endif()
unset(_${_cmff_NAME}_CMAKE_ROLE)

#[=============================================================================[.rst:

Result variables
^^^^^^^^^^^^^^^^
This module will set the following variables in your project:

    .. cmake:variable:: Bash_FOUND
                        BASH_FOUND

        Indicates if ``bash`` package was found

    .. cmake:variable:: Bash_EXECUTABLE

        Path to the ``bash`` executable

    .. cmake:variable:: Bash_COMMAND

        String that has to be used to call ``bash``

#]=============================================================================]

# build command -------------------------------------------------------------- #
if(${_cmff_NAME}_EXECUTABLE)
    set(${_cmff_NAME}_COMMAND "${${_cmff_NAME}_EXECUTABLE}" CACHE STRING "The ${_cmff_NAME} command")
    mark_as_advanced(${_cmff_NAME}_EXECUTABLE ${_cmff_NAME}_COMMAND)
endif()

#[=============================================================================[.rst:

    .. cmake:variable:: Bash_VERSION_STRING

        ``bash`` full version string

    .. cmake:variable:: Bash_VERSION_MAJOR

        ``bash`` major version

    .. cmake:variable:: Bash_VERSION_MINOR

        ``bash`` minor version

    .. cmake:variable:: Bash_VERSION_PATCH

        ``bash`` version patch

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
        if(${_cmff_NAME}_version_output MATCHES "GNU bash, version ([.0-9]+)")
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

# handle components, version, quiet, required and other flags ---------------- #
find_package_handle_standard_args(${_cmff_NAME}
    REQUIRED_VARS ${_cmff_NAME}_EXECUTABLE
                  ${_cmff_NAME}_COMMAND
    VERSION_VAR   ${_cmff_NAME}_VERSION_STRING
    FAIL_MESSAGE  "bash not found, installation: ${PROJECT_HOMEPAGE_URL}"
)

# epilogue ------------------------------------------------------------------- #
CF_find_epilogue()

#[=============================================================================[.rst:

Example usage
^^^^^^^^^^^^^

.. code-block:: cmake

    find_package(Bash REQUIRED)

    execute_process(
        COMMAND         ${Bash_COMMAND} -version
        OUTPUT_VARIABLE Bash_VERSION_RAW
        ERROR_VARIABLE  Bash_VERSION_RAW
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

#]=============================================================================]
