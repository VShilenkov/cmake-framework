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
Init
----

.. only:: html

   .. contents::

#]=============================================================================]

# include guard -------------------------------------------------------------- #
include_guard(GLOBAL)

if(CF_INITIALIZED)
    return()
endif()

#[=============================================================================[.rst:

Synopsis
^^^^^^^^

This module servers as a starting point to initialize CMake Framework.

.. note::

    Project has to include this module via
    :cmake:command:`include() <cmake_latest:command:include>` with full path
    ``cmake/modules/Init.cmake`` in case of direct usage. In case using
    :cmake:command:`find_package() <cmake_latest:command:find_package>` to find
    CMake Framework this module will be included automatically.

#]=============================================================================]

set(CF_lp "[CF]" CACHE INTERNAL "CMakeFramework logging prefix")

#[=============================================================================[.rst:

Commands
^^^^^^^^

This module introduces commands project may use during development of its own
finders and utility modules.

#]=============================================================================]

#[=============================================================================[.rst:

    .. cmake:command:: CF_module_prologue

        Introduce set of module wide variables

        .. code-block:: cmake

            CF_module_prologue(<module_name>)

        .. note::

            Has to be used in the module beginning.

        Next variables will be created:

        .. cmake:variable:: _cmfm_NAME

            Name of the module file without extension written in original case

        .. cmake:variable:: _cmfm_Q_NAME

            Qualified name of the module - prefixed with relative path to the root

        .. cmake:variable:: CF_lp_<__module_name>

            Logging prefix for module ``<__module_name>``. Cached.

#]=============================================================================]
macro(CF_module_prologue __module_name)
    # module-wide internal variables
    ## module name
    get_filename_component(_cmfm_NAME ${CMAKE_CURRENT_LIST_FILE} NAME_WE)

    ## module qualified name
    get_filename_component(_cmfm_Q_NAME ${CMAKE_CURRENT_LIST_FILE} DIRECTORY)
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" _cmfm_Q_NAME "${_cmfm_Q_NAME}")
    string(APPEND _cmfm_Q_NAME "/${_cmfm_NAME}")

    ## module logging prefix
    set(CF_lp_${__module_name} "${CF_lp} ${_cmfm_NAME}:" CACHE INTERNAL
        "${_cmfm_Q_NAME} logging prefix"
    )

    # entrance
    message(STATUS "${CF_lp_${__module_name}} included")
endmacro()

#[=============================================================================[.rst:

    .. cmake:command:: CF_module_epilogue

        Removes variables introduced by :cmake:command:`CF_module_prologue`

        .. code-block:: cmake

            CF_module_epilogue()

        .. note::

            Has to be used in the module's end after :cmake:command:`CF_module_prologue`

        Example for module `my_module.cmake`

        .. code-block:: cmake

            include_guard(GLOBAL)
            CF_module_prologue(my_module)

            message(STATUS "${CF_lp_my_module} hello from my_module")

            # some business here

            # clean-up
            CF_module_epilogue()
#]=============================================================================]
macro(CF_module_epilogue)
    # clean-up
    unset(_cmfm_Q_NAME)
    unset(_cmfm_NAME)
endmacro()

#[=============================================================================[.rst:

    .. cmake:command:: CF_find_prologue

        Introduce set of find module wide variables

        .. code-block:: cmake

            CF_find_prologue()

        .. note::

            Has to be used in the find module beginning.

        Next variables will be created:

        .. cmake:variable:: _cmff_NAME

            Name of the package to find (shortcut for 
            :cmake:variable:`CMAKE_FIND_PACKAGE_NAME <cmake_latest:variable:CMAKE_FIND_PACKAGE_NAME>`)

        .. cmake:variable:: _CMFF_NAME

            same as :cmake:variable:`_cmff_NAME` in uppercase

        .. cmake:variable:: CF_lp_<package_name>

            Logging prefix for this find module. Cached.

#]=============================================================================]
macro(CF_find_prologue)
    set(_cmff_NAME "${CMAKE_FIND_PACKAGE_NAME}")
    string(TOUPPER "${_cmff_NAME}" _CMFF_NAME)
    set(CF_lp_${_cmff_NAME} "${CF_lp} ${_cmff_NAME}:" CACHE INTERNAL "Find${_cmff_NAME} logging prefix")
endmacro()

#[=============================================================================[.rst:

    .. cmake:command:: CF_find_epilogue

        Removes variables introduced by :cmake:command:`CF_find_prologue`

        .. code-block:: cmake

            CF_find_epilogue()

        .. note::

            Has to be used in the find module's end after :cmake:command:`CF_find_prologue`

        Example for find module `FindSmth.cmake`

        .. code-block:: cmake

            CF_find_prologue()

            message(STATUS "${CF_lp_Smth} hello, I'm looking for Smth")

            # some business here

            # clean-up
            CF_find_epilogue()
#]=============================================================================]

macro(CF_find_epilogue)
    # clean-up
    unset(_CMFF_NAME)
    unset(_cmff_NAME)
endmacro()

# Prologue ------------------------------------------------------------------- #
CF_module_prologue(Init)
# ---------------------------------------------------------------------------- #

#[=============================================================================[.rst:

Details
^^^^^^^

Environment Validation
**********************

Checking if :cmake:variable:`CMakeFramework-ROOT` is set and is a valid directory.
Otherwise it is considered that this is local initialization (cmake-framework is
a part of consuming project's source tree) and directory parent to this file's
directory is taken as a :cmake:variable:`CMakeFramework-ROOT`

#]=============================================================================]

if(DEFINED CMakeFramework-ROOT)                                                 # Framework initialization from Module
    if(NOT (    EXISTS "${CMakeFramework-ROOT}"
            AND IS_DIRECTORY "${CMakeFramework-ROOT}")
    )
        message(FATAL_ERROR "${CF_lp_Init} Initialization failed: broken `CMakeFramework-ROOT`\n"
                            "Invalid path: ${CMakeFramework-ROOT}"
        )
    endif()
else()                                                                          # Framework local initialization
    message(STATUS "${CF_lp_Init} Direct initialization attempt")
    get_filename_component(CMakeFramework-ROOT "${CMAKE_CURRENT_LIST_DIR}" DIRECTORY)
endif()

# Validate required paths
foreach(__dir modules finders tools)
    set(__f_dir "${CMakeFramework-ROOT}/${__dir}")
    if(NOT (EXISTS "${__f_dir}" AND IS_DIRECTORY "${__f_dir}"))
        message(FATAL_ERROR "${CF_lp_Init} Initialization failed: missing `${__dir}`\n"
            "Invalid path: ${__f_dir}"
        )
    endif()
endforeach()
unset(__dir)
unset(__f_dir)

#[=============================================================================[.rst:

Easy usage
**********

Populating :cmake:variable:`CMAKE_MODULE_PATH <cmake_latest:variable:CMAKE_MODULE_PATH>`
to give consuming project ability to use 
:cmake:command:`include() <cmake_latest:command:include>` and 
:cmake:command:`find_package() <cmake_latest:command:find_package>`

#]=============================================================================]
# Populate `CMAKE_MODULE_PATH`
# imitate `list(PREPEND)`
if(CMAKE_MODULE_PATH)
    list(REVERSE CMAKE_MODULE_PATH)
endif()
list(APPEND CMAKE_MODULE_PATH "${CMakeFramework-ROOT}/modules")
list(APPEND CMAKE_MODULE_PATH "${CMakeFramework-ROOT}/finders")
list(REVERSE CMAKE_MODULE_PATH)

#[=============================================================================[.rst:

Picking tools
*************

This module includes next modules:

 - :cmake:module:`Printer`
 - :cmake:module:`ControlFlow`
 - :cmake:module:`Debug`
 - :cmake:module:`Utilities`

#]=============================================================================]
# panoply with tools
include(${CMakeFramework-ROOT}/tools/Printer.cmake)
include(${CMakeFramework-ROOT}/tools/ControlFlow.cmake)
include(${CMakeFramework-ROOT}/tools/Debug.cmake)
include(${CMakeFramework-ROOT}/tools/Utilities.cmake)

#[=============================================================================[.rst:

Variables
^^^^^^^^^

Variables would be declared:

    .. cmake:variable:: CF_INITIALIZED

        indicates if CMake Framework is initialized properly (``true``) or not
        (``false``)

#]=============================================================================]
# and this is how begins
set(CF_INITIALIZED true)

message(STATUS "${CF_lp_Init} Framework initialized successfully")

file(GLOB __modules RELATIVE ${CMakeFramework-ROOT}/finders "${CMakeFramework-ROOT}/finders/Find*.cmake")
list(TRANSFORM __modules REPLACE "Find(.*)\\.cmake" "\\1")
message(STATUS "${CF_lp_Init} available Find modules: ")
CF_print_table(__modules 4)

file(GLOB __modules RELATIVE ${CMakeFramework-ROOT}/modules "${CMakeFramework-ROOT}/modules/*.cmake")
list(TRANSFORM __modules REPLACE "(.*)\\.cmake" "\\1")
message(STATUS "${CF_lp_Init} available modules: ")
CF_print_table(__modules 4)
unset(__modules)


# Epilogue ------------------------------------------------------------------- #
CF_module_epilogue()
# ---------------------------------------------------------------------------- #
