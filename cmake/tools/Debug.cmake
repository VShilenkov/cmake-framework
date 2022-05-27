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
Debug
-----

Synopsis
^^^^^^^^

This module provides commands intended for support debugging of CMake scripts.

.. note::

    This module included during CMake Framework initialization process. Check
    :cmake:module:`Init`

#]=============================================================================]

# include guard -------------------------------------------------------------- #
include_guard(GLOBAL)

# Prologue ------------------------------------------------------------------- #
CF_module_prologue(Debug)
# ---------------------------------------------------------------------------- #

#[=============================================================================[.rst:

Commands
^^^^^^^^
#]=============================================================================]

#[=============================================================================[.rst:
.. cmake:command:: CF_dump_variables

    Prints all the variables available in the current scope.

    .. code-block:: cmake

        CF_dump_variables([NO_CMAKE] [NO_PROJECT] [EXTRA_CLEAN])

    ``NO_CMAKE``

        excludes all the variables related to internals of CMake

    ``NO_PROJECT``

        excludes all the variables related to the last declared project via
        :cmake:command:`project() <cmake_latest:command:project>`.

    ``EXTRA_CLEAN``

        doesn't provide all the variables related to CMake, current project and
        some additional group of variables

#]=============================================================================]
function(CF_dump_variables)
    get_cmake_property(ppt_variables VARIABLES)
    list(SORT ppt_variables)
    set(options NO_PROJECT NO_CMAKE EXTRA_CLEAN)
    cmake_parse_arguments(_opt "${options}" "" "" ${ARGN} )
    if(_opt_EXTRA_CLEAN)
        set(_opt_NO_CMAKE ON)
        set(_opt_NO_PROJECT ON)
        list(FILTER ppt_variables EXCLUDE REGEX "^ARG")
        list(FILTER ppt_variables EXCLUDE REGEX "^RUN_CONFIGURE")
        list(FILTER ppt_variables EXCLUDE REGEX "^UNIX")
        list(FILTER ppt_variables EXCLUDE REGEX "^_INCLUDED_SYSTEM_INFO_FILE")
        list(FILTER ppt_variables EXCLUDE REGEX "^__UNIX_PATHS_INCLUDED")
        list(FILTER ppt_variables EXCLUDE REGEX "^(dir|lang|type|val)$")
        list(FILTER ppt_variables EXCLUDE REGEX "^_?_?Python3_")
        list(FILTER ppt_variables EXCLUDE REGEX "^_fs.*Types?IsSet")
    endif()
    if(_opt_NO_CMAKE)
        list(FILTER ppt_variables EXCLUDE REGEX "^_?CMAKE_")
    endif()
    if(_opt_NO_PROJECT)
        list(FILTER ppt_variables EXCLUDE REGEX "^${PROJECT_NAME}_")
        list(FILTER ppt_variables EXCLUDE REGEX "^PROJECT_")
    endif()
    CF_print_map(ppt_variables)
endfunction()

# Epilogue ------------------------------------------------------------------- #
CF_module_epilogue()
# ---------------------------------------------------------------------------- #