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
UseRailroad
-----------

.. only:: html

   .. contents::

#]=============================================================================]

# include guard -------------------------------------------------------------- #
include_guard(GLOBAL)

if(TARGET all_railroad)
    return()
endif()

# Prologue ------------------------------------------------------------------- #
CF_module_prologue(UseVirtualenv)
# ---------------------------------------------------------------------------- #

#[=============================================================================[.rst:

Synopsis
^^^^^^^^

This module provide convinience with generating Railroads diagrams.
See :cmake:module:`FindRailroad` for information on  Railroad diagram
generator.

.. note::

    This file uses :cmake:module:`FindRailroad` to load Railroad generator if it
    wasn't loaded before

.. note::
    This file requires CXX compiler to be available so it enables ``CXX`` language
    via :cmake:command:`enable_language(CXX) <cmake_latest:command:enable_language>`

#]=============================================================================]

# required to be able to run preprocessing on *.ebnf files
if(NOT CMAKE_CXX_COMPILER)
    enable_language(CXX)
endif()

# dependencies
if(NOT DEFINED Railroad_COMMAND)
    find_package(Railroad REQUIRED)
endif()

# targets
#[=============================================================================[.rst:

Targets
^^^^^^^

This module defines utility target ``all_railroad`` to provide a simple way to
generate all RailRoad diagrams added by :cmake:command:`add_rr`

#]=============================================================================]
add_custom_target(all_railroad)

# macros

#[=============================================================================[.rst:

Commands
^^^^^^^^

    .. cmake:command::  add_rr

        Generates Railroad diagram with given files::

            add_rr(<target_name>
                SOURCES <source1> [<source2> ...]
                DESTINATION <destination>
                [INCLUDE_DIRECTORIES <include_directory1> [<include_directory2> ...]]
            )

        This command creates target ``<target_name>``. Preprocess all the sources
        listed with :doc:`CMAKE_CXX_COMPILER <cmake_latest:variable/CMAKE_LANG_COMPILER>`.
        Products of the preprocessing will be then propagated to the Railroad
        Diagram generator to create ``<sourceX>.xhtml``.

        ``SOURCES``
            List of files that has to be processed via railroad generator.

        ``DESTINATION``
            Folder where the products has to be stored. Will be created in case
            it doesn't exist. Relative path will be evaluated wit respect to the
            :cmake:variable:`CMAKE_CURRENT_SOURCE_DIR <cmake_latest:variable:CMAKE_CURRENT_SOURCE_DIR>`

        ``INCLUDE_DIRECTORIES``
            List of pathes where CXX compiler preprocessor will search for files
            in ``include`` directive.

        If there is a file called `test.ebnf` in current directory then it is possible
        to generate diagram with the next instruction

        .. code-block:: cmake

            add_rr(test_diagram
                SOURCES test.enbnf
                DESTINATION ${CMAKE_BINARY_DIR}
            )
#]=============================================================================]
macro(add_rr add_rr_args_TARGET)
    set(cmpa_key_value      DESTINATION)
    set(cmpa_key_multivalue SOURCES INCLUDE_DIRECTORIES)
    cmake_parse_arguments(add_rr_args
                          ""
                          "${cmpa_key_value}"
                          "${cmpa_key_multivalue}"
                          ${ARGN}
    )
    unset(cmpa_key_multivalue)
    unset(cmpa_key_value)

    if(TARGET ${add_rr_args_TARGET})
        message(FATAL_ERROR "${CF_lp_UseRailroad} Target ${add_rr_args_TARGET} is alaready defined")
    endif()

    if(NOT DEFINED add_rr_args_SOURCES)
        message(FATAL_ERROR "${CF_lp_UseRailroad} Omitted mandatory parameter `SOURCES`")
    elseif(add_rr_args_SOURCES STREQUAL "")
        message(FATAL_ERROR "${CF_lp_UseRailroad} Values for parameter `SOURCES` are missing")
    endif()

    if(NOT DEFINED add_rr_args_DESTINATION)
        message(FATAL_ERROR "${CF_lp_UseRailroad} Omitted mandatory parameter `DESTINATION`")
    elseif(add_rr_args_DESTINATION STREQUAL "")
        message(FATAL_ERROR "${CF_lp_UseRailroad} Value for parameter `DESTINATION` is missing")
    endif()

    # process SOURCES
    set(_rr_SOURCES "")
    foreach(_source IN LISTS add_rr_args_SOURCES)
        cmake_path(IS_RELATIVE _source _is_relative)
        if(_is_relative)
            cmake_path(ABSOLUTE_PATH _source NORMALIZE)
        endif()

        if(NOT EXISTS "${_source}")
            message(FATAL_ERROR "${CF_lp_UseRailroad} SOURCES contains not existing file: ${_source}")
        endif()
        list(APPEND _rr_SOURCES "${_source}")
    endforeach()
    list(REMOVE_DUPLICATES _rr_SOURCES)
    unset(add_rr_args_SOURCES)

    # process DESTINATION
    cmake_path(IS_RELATIVE add_rr_args_DESTINATION _is_relative)
    if(_is_relative)
        cmake_path(ABSOLUTE_PATH add_rr_args_DESTINATION NORMALIZE)
    endif()
    if(NOT (EXISTS "${add_rr_args_DESTINATION}" AND IS_DIRECTORY "${add_rr_args_DESTINATION}"))
        file(MAKE_DIRECTORY "${add_rr_args_DESTINATION}")
    endif()

    # process INCLUDE_DIRECTORIES
    ## add current location to includes
    set(_rr_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_LIST_DIR}")
    foreach(_dir IN LISTS add_rr_args_INCLUDE_DIRECTORIES)
        cmake_path(IS_RELATIVE _dir _is_relative)
        if(_is_relative)
            cmake_path(ABSOLUTE_PATH _dir NORMALIZE)
        endif()

        if(NOT EXISTS "${_dir}")
            message(WARNING "${CF_lp_UseRailroad} `INCLUDE_DIRECTORIES` contains not existing directory: ${_dir}")
        elseif(NOT IS_DIRECTORY "${_dir}")
            message(WARNING "${CF_lp_UseRailroad} `INCLUDE_DIRECTORIES` contains not directory: ${_dir}")
        else()
            list(APPEND _rr_INCLUDE_DIRECTORIES "${_dir}")
        endif()
    endforeach()
    list(REMOVE_DUPLICATES _rr_INCLUDE_DIRECTORIES)
    list(TRANSFORM _rr_INCLUDE_DIRECTORIES PREPEND "-I")
    unset(_is_relative)

    set(_rr_PRODUCTS "")
    foreach(_source IN LISTS _rr_SOURCES)
        cmake_path(GET _source STEM LAST_ONLY _source_full_stem)

        add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${_source_full_stem}.pp.ebnf
            COMMAND
                ${CMAKE_CXX_COMPILER}
                    -E
                    -C
                    -x c++-header
                    ${_rr_INCLUDE_DIRECTORIES}
                    -o ${CMAKE_CURRENT_BINARY_DIR}/${_source_full_stem}.pp.ebnf
                    ${_source}
            DEPENDS ${_source}
            COMMENT "${CF_lp_UseRailroad} Preprocess ${_source}"
        )

        add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${_source_full_stem}.s.ebnf
            COMMAND
                grep
                    -v "^#"
                    ${CMAKE_CURRENT_BINARY_DIR}/${_source_full_stem}.pp.ebnf > ${CMAKE_CURRENT_BINARY_DIR}/${_source_full_stem}.s.ebnf
            DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${_source_full_stem}.pp.ebnf
            COMMENT "${CF_lp_UseRailroad} Sanityze ${CMAKE_CURRENT_BINARY_DIR}/${_source_full_stem}.pp.ebnf"
        )

        add_custom_command(OUTPUT ${add_rr_args_DESTINATION}/${_source_full_stem}.xhtml
            COMMAND
                ${Railroad_COMMAND}
                    -out:${add_rr_args_DESTINATION}/${_source_full_stem}.xhtml
                    ${CMAKE_CURRENT_BINARY_DIR}/${_source_full_stem}.s.ebnf
            DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${_source_full_stem}.s.ebnf
            COMMENT "${CF_lp_UseRailroad} Generate ${add_rr_args_DESTINATION}/${_source_full_stem}.xhtml"
        )

        list(APPEND _rr_PRODUCTS "${add_rr_args_DESTINATION}/${_source_full_stem}.xhtml")
        unset(_source_full_stem)
    endforeach()

    unset(_rr_INCLUDE_DIRECTORIES)
    unset(_rr_SOURCES)
    unset(add_rr_args_DESTINATION)

    add_custom_target(${add_rr_args_TARGET}
        DEPENDS ${_rr_PRODUCTS}
    )
    unset(_rr_PRODUCTS)

    add_dependencies(all_railroad ${add_rr_args_TARGET})
endmacro()

# Epilogue ------------------------------------------------------------------- #
CF_module_epilogue()
# ---------------------------------------------------------------------------- #
