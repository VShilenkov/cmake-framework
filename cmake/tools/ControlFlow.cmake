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
ControlFlow
-----------

Synopsis
^^^^^^^^

This module provides commands that act as smart wrappers for CMake native checks.

.. note::

    This module included during CMake Framework initialization process. Check
    :cmake:module:`Init`

#]=============================================================================]

# include guard -------------------------------------------------------------- #
include_guard(GLOBAL)

# Prologue ------------------------------------------------------------------- #
CF_module_prologue(ControlFlow)
# ---------------------------------------------------------------------------- #

#[=============================================================================[.rst:

Commands
^^^^^^^^
#]=============================================================================]

#[=============================================================================[.rst:
.. cmake:command:: CF_not_exists

    Check if provided path not exists and print output:

    .. code-block:: cmake

        CF_not_exists(<path_var> <mode> [<custom_message>])
    
    ``path_var``

        Variable containing path to validate

    ``mode``

        First argument of :cmake:command:`message() <cmake_latest:command:message>`
        used to print output.

    ``custom_message``

        Additional information to print

    Example:

    .. code-block:: cmake

        set(path_to_smth_important "/here/was/this/important/smth")

        CF_not_exists(path_to_smth_important FATAL_ERROR "where it was?")

#]=============================================================================]
macro(CF_not_exists __path_var __mode)
    if(NOT EXISTS "${${__path_var}}")
       set(__message "┌${CF_lp_ControlFlow} Invalid path `${__path_var}`"
                   "\n├ Not exists: ${${__path_var}}"
        )
        if(${ARGC} GREATER 2)
            string(APPEND __message "\n├ ${ARGV2}")
        endif()
        string(APPEND __message "\n└${CF_lp_ControlFlow} CF_not_exists")
        message(${__mode} "${__message}")
        unset(__message)
    endif()
endmacro()

#[=============================================================================[.rst:
.. cmake:command:: CF_not_defined

    Check if provided path not exists and print output:

    .. code-block:: cmake

        CF_not_defined(<var> <mode> [<custom_message>])
    
    ``var``

        Variable to check if defined

    ``mode``

        First argument of :cmake:command:`message() <cmake_latest:command:message>`
        used to print output.

    ``custom_message``

        Additional information to print

    Example:

    .. code-block:: cmake

        CF_not_defined(BUILD_TYPE FATAL_ERROR "BUILD_TYPE is mandatory")

#]=============================================================================]
macro(CF_not_defined __var __mode)
    if(NOT DEFINED ${__var})
       set(__message "┌${CF_lp_ControlFlow} Variable not defined `${__var}`")
        if(${ARGC} GREATER 2)
            string(APPEND __message "\n├ ${ARGV2}")
        endif()
        string(APPEND __message "\n└${CF_lp_ControlFlow} CF_not_defined")
        message(${__mode} "${__message}")
        unset(__message)
    endif()
endmacro()


#[=============================================================================[.rst:
.. cmake:command:: CF_execute_process_fails

    Check if :cmake:command:`execute_process() <cmake_latest:command:execute_process>`
    succeeds.

    .. code-block:: cmake

        CF_execute_process_fails(<prefix> <mode> [<custom_message>])
    
    ``prefix``

        Prefix to variable ``<prefix>_result`` to compare with 0, which indicates
        that executed process was successful, and failure in all other cases.
        If ``<prefix>_error`` and ``<prefix>_output`` are defined the also will
        be printed.

    ``mode``

        First argument of :cmake:command:`message() <cmake_latest:command:message>`
        used to print output.

    ``custom_message``

        Additional information to print

    Example:

    .. code-block:: cmake

        execute_process(
            COMMAND generate_perfect_sources.sh
            RESULT_VARIABLE generation_result
            OUTPUT_VARIABLE generation_output
            ERROR_VARIABLE  generation_error
        )

        CF_execute_process_fails(generation STATUS "something went wrong :-(")

#]=============================================================================]
macro(CF_execute_process_fails __prefix __mode)
    if(NOT (${__prefix}_result STREQUAL "0" OR ${__prefix}_result EQUAL 0))
        set(__message "┌${CF_lp_ControlFlow} execute_process() fails with code: "
                      "${${__prefix}_result}"
        )
        if(DEFINED ${__prefix}_error)
            string(APPEND __message "\n├ error: ${${__prefix}_error}")
        endif()
        if(DEFINED ${__prefix}_output)
            string(APPEND __message "\n├ output: ${${__prefix}_output}")
        endif()
        if(${ARGC} GREATER 2)
            string(APPEND __message "\n├ ${ARGV2}")
        endif()
        string(APPEND __message "\n└${CF_lp_ControlFlow} CF_execute_process_fails")
        message(${__mode} ${__message})
        unset(__message)
    endif()
endmacro()

# Epilogue ------------------------------------------------------------------- #
CF_module_epilogue()
# ---------------------------------------------------------------------------- #
