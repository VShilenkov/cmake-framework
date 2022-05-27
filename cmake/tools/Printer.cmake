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
Printer
-------

Synopsis
^^^^^^^^

This module provides commands that unifies messaging information to the terminal.

.. note::

    This module included during CMake Framework initialization process. Check
    :cmake:module:`Init`

#]=============================================================================]


# include guard -------------------------------------------------------------- #
include_guard(GLOBAL)

# Prologue ------------------------------------------------------------------- #
CF_module_prologue(Printer)
# ---------------------------------------------------------------------------- #

#[=============================================================================[.rst:

Commands
^^^^^^^^
#]=============================================================================]

#[=============================================================================[.rst:
.. cmake:command:: CF_print_var

    Prints given variable if it is defined, warns otherwise. See 
    :ref:`cmake language variables`

    .. code-block:: cmake

        CF_print_var(<var>)

    ``var``

        variable to print
#]=============================================================================]
macro(CF_print_var __var)
    if(DEFINED ${__var})
        message(STATUS "${CF_lp_Printer} `${__var}` : ${${__var}}")
    else()
        message(WARNING "${CF_lp_Printer} `${__var}` not defined")
    endif()
endmacro()

#[=============================================================================[.rst:
.. cmake:command:: CF_print_env

    Prints given environment variable if it is defined, warns otherwise. See
    :ref:`cmake language environment variables`

    .. code-block:: cmake

        CF_print_env(<var>)

    ``var``

        environment variable to print
#]=============================================================================]
macro(CF_print_env _env_var)
    if(DEFINED ENV{${_env_var}})
        message(STATUS "${CF_lp_Printer} `ENV:${_env_var}` : $ENV{${_env_var}}")
    else()
        message(WARNING "${CF_lp_Printer} `ENV:${_env_var}` not defined")
    endif()
endmacro()

#[=============================================================================[.rst:
.. cmake:command:: CF_print_list

    Prints given list if it is defined, warns otherwise. See
    :ref:`cmake language lists`

    .. code-block:: cmake

        CF_print_list(<var>)

    ``var``

        variable that holds list to print

    For example:

    .. code-block:: cmake

        set(my_list 1 2 3 4 5 6 7)
        CF_print_list(my_list)
    
    expected output::

        1
        2
        3
        4
        5
        6
        7

#]=============================================================================]
macro(CF_print_list _list_var)
    if(DEFINED ${_list_var})
        set(i 0)
        foreach(item IN LISTS ${_list_var})
            message(STATUS "${CF_lp_Printer} `${_list_var}[${i}]` : ${item}")
            math(EXPR i "${i} + 1")
        endforeach()
        unset(i)
        unset(item)
    else()
        message(WARNING "${CF_lp_Printer} `${_list_var}` not defined")
    endif()
endmacro()

#[=============================================================================[.rst:
.. cmake:command:: CF_print_table

    Prints given list if it is defined in given number of columns, warns otherwise.
    See :ref:`cmake language lists`

    .. code-block:: cmake

        CF_print_table(<var> <columns>)

    ``var``

        variable that holds list to print

    ``columns``

        number of columns, should be positive

    For example:
    
    .. code-block:: cmake

        set(my_list 1 2 3 4 5 6 7)
        CF_print_table(my_list 3)
    
    expected output::

        1 2 3
        4 5 6
        7

#]=============================================================================]

function(CF_print_table _list_var _columns)
    if(_columns LESS_EQUAL 0)
        message(WARNING "${CF_lp_Printer} Columns must non negative")
        return()
    endif()
    if(NOT DEFINED ${_list_var})
        message(WARNING "${CF_lp_Printer} `${_list_var}` not defined")
    endif()
    set(i 0)
    set(__line "${CF_lp_Printer}")

    foreach(__item IN LISTS ${_list_var})
    if(i EQUAL ${_columns})
        message(STATUS  "${__line}")
        set(__line "${CF_lp_Printer}")
        set(i 0)
    endif()

    math(EXPR i "${i} + 1")
    string(APPEND __line " ${__item}")
    endforeach()
    message(STATUS "${__line}")
endfunction()

#[=============================================================================[.rst:
.. cmake:command:: CF_print_map

    Prints given list of variables with its values.

    .. code-block:: cmake

        CF_print_map(<var>)

    ``var``

        variable that holds list of variables

    For example:
    
    .. code-block:: cmake

        set(a 1)
        set(b 2)
        set(c 3)
        set(my_map a b c)
        CF_print_map(my_map)
    
    expected output::

        a: 1
        b: 2
        c: 3

#]=============================================================================]
macro(CF_print_map _map_var)
    if(DEFINED ${_map_var})
        foreach(item IN LISTS ${_map_var})
            CF_print_var(${item})
        endforeach()
        unset(item)
    else()
        message(WARNING "${CF_lp_Printer} `${_map_var}` not defined")
    endif()
endmacro()

# Epilogue ------------------------------------------------------------------- #
CF_module_epilogue()
# ---------------------------------------------------------------------------- #
