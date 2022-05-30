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
FindCMD
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

Locates `A Windows Command line interpreter <https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cmd>`_.

#]=============================================================================]

# declare package properties ------------------------------------------------- #
set_package_properties(${_cmff_NAME}
    PROPERTIES
        URL         "https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cmd"
        DESCRIPTION "A Windows Command line interpreter"
)

# validate find_package() arguments ------------------------------------------ #

#[=============================================================================[.rst:
Components
^^^^^^^^^^

This module doesn't support components

#]=============================================================================]

## no components supported
if(${_cmff_NAME}_FIND_COMPONENTS AND NOT ${_cmff_NAME}_FIND_QUIETLY)
    message(WARNING "${CF_lp_CMD} components not supported")
endif()

#[=============================================================================[.rst:

Hints
^^^^^

To provide hints to this module, project code may set next:

CMake Variables
***************

    .. cmake:variable:: CMD_DIR

    Path to the installation root of ``cmd``

Environment variables
*********************

    ..  cmake:envvar:: CMD_DIR

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
    NAMES         cmd.exe
                  cmd
    HINTS         ${${_cmff_NAME}_hints}
        ENV       ${_cmff_NAME}_DIR
        ENV       ${_cmff_NAME}_DIR
    DOC           "The ${_cmff_NAME} executable"
)
unset(${_cmff_NAME}_hints)

#[=============================================================================[.rst:

Result variables
^^^^^^^^^^^^^^^^
This module will set the following variables in your project:

    .. cmake:variable:: CMD_FOUND

        Indicates if ``cmd`` package was found

    .. cmake:variable:: CMD_EXECUTABLE

        Path to the ``cmd`` executable

    .. cmake:variable:: CMD_COMMAND

        String that has to be used to call ``cmd``

#]=============================================================================]

# build command -------------------------------------------------------------- #
if(${_cmff_NAME}_EXECUTABLE)
    set(${_cmff_NAME}_COMMAND "${${_cmff_NAME}_EXECUTABLE}" CACHE STRING "The ${_cmff_NAME} command")
    mark_as_advanced(${_cmff_NAME}_EXECUTABLE ${_cmff_NAME}_COMMAND)
endif()

# handle components, version, quiet, required and other flags ---------------- #
find_package_handle_standard_args(${_cmff_NAME}
    REQUIRED_VARS ${_cmff_NAME}_EXECUTABLE
                  ${_cmff_NAME}_COMMAND
)

# epilogue ------------------------------------------------------------------- #
CF_find_epilogue()

#[=============================================================================[.rst:

Example usage
^^^^^^^^^^^^^

.. code-block:: cmake

    find_package(CMD REQUIRED)

    execute_process(
        COMMAND         ${CMD_COMMAND} /C "where ipconfig"
        OUTPUT_VARIABLE ipconfig_path_output
        ERROR_VARIABLE  ipconfig_path_error
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

#]=============================================================================]
