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
Utilities
---------

Synopsis
^^^^^^^^

This module provides utilities commands.

.. note::

    This module included during CMake Framework initialization process. Check
    :cmake:module:`Init`

#]=============================================================================]

# include guard -------------------------------------------------------------- #
include_guard(GLOBAL)

# Prologue ------------------------------------------------------------------- #
CF_module_prologue(Utilities)
# ---------------------------------------------------------------------------- #

#[=============================================================================[.rst:

Commands
^^^^^^^^
#]=============================================================================]

#[=============================================================================[.rst:
.. cmake:command:: CF_execute_process_wipe

    Remove from current scope variables: ``<prefix>_result``, ``<prefix>_output``
    and ``<prefix>_error``

    .. code-block:: cmake

        CF_execute_process_wipe(<prefix>)

    Example:

    .. code-block:: cmake

        execute_process(
            COMMAND ${CMAKE_COMMAND} --version
            RESULT_VARIABLE _cmake_version_result
            OUTPUT_VARIABLE _cmake_version_output
            ERROR_VARIABLE  _cmake_version_error
        )

        CF_execute_process_fails(_cmake_version FATAL_ERROR)
        CF_execute_process_wipe(_cmake_version)
        # _cmake_version_result, _cmake_version_output and _cmake_version_error
        # are not defined after this line

#]=============================================================================]

macro(CF_execute_process_wipe _prefix)
    foreach(_suffix result output error)
        unset(${_prefix}_${_suffix})
    endforeach()
    unset(_suffix)
endmacro()

#[=============================================================================[.rst:
.. cmake:command:: CF_list_difference

    Finds set-theoretic difference of two lists (<left_list> - <right_list>) and
    stores result in <out_var>

    .. code-block:: cmake

        CF_list_difference(<left_list> <right_list> <out_var>)

    Example:

    .. code-block:: cmake

        set(A 1 2 3 4 5)
        set(B 4 5 6 7 8)
        CF_list_difference(A B C)
        CF_print_list(C)

    Output expected::

        1
        2
        3

#]=============================================================================]
macro(CF_list_difference _lhs _rhs _out)
    set(_inner_out "")
    foreach(_var IN LISTS ${_lhs})
        list(FIND ${_rhs} ${_var} i)
        if(i EQUAL -1)
            list(APPEND _inner_out ${_var})
        endif()
    endforeach()
    set(${_out} "${_inner_out}")
    unset(_inner_out)
    unset(_var)
    unset(i)
endmacro()


# Epilogue ------------------------------------------------------------------- #
CF_module_epilogue()
# ---------------------------------------------------------------------------- #
