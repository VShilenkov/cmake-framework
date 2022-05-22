# include guard -------------------------------------------------------------- #
include_guard(GLOBAL)

# Prologue ------------------------------------------------------------------- #
CF_module_prologue(DocSphinx)
# ---------------------------------------------------------------------------- #

find_package(Pip3 REQUIRED)
find_package(Sphinx COMPONENTS build REQUIRED)

# Meta targets --------------------------------------------------------------- #

add_custom_target(documentation_sphinx_generate
    COMMENT "Generate Sphinx-doc documentation"
)

add_custom_target(documentation_sphinx_clean
    COMMENT "Clean Sphinx-doc documentation"
)

set(${_cmfm_NAME}_formats_supported html
                                    dirhtml
                                    singlehtml
                                    htmlhelp
                                    qthelp
                                    devhelp
                                    epub
                                    applehelp
                                    latex
                                    man
                                    texinfo
                                    text
                                    gettext
                                    xml
                                    pseudoxml
)

# Commands ------------------------------------------------------------------- #

function(directory_sphinx_doc __master_doc_dir)
    set(oneValueArgs DESTINATION CONFIG)
    set(multiValueArgs FORMATS EXTENSIONS)
    cmake_parse_arguments(_dsd_opts "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    string(REPLACE "${CMAKE_SOURCE_DIR}/" "" _target_name "${__master_doc_dir}")
    string(REPLACE "/" "_" _target_name "${_target_name}")


    if(NOT _dsd_opts_DESTINATION)
        set(_dsd_opts_DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/sphinx-doc")
    endif()

    if(NOT _dsd_opts_CONFIG)
        set(_dsd_opts_CONFIG "${__master_doc_dir}")
    endif()

    if(NOT _dsd_opts_FORMATS)
        set(_dsd_opts_FORMATS html)
    endif()

    foreach(_f IN LISTS _dsd_opts_FORMATS)
        if(NOT ${_f} IN_LIST DocSphinx_formats_supported)
            message(FATAL_ERROR "${CF_lp_DocSphinx} Unknown format: ${_f}")
        endif()
    endforeach()

    if(NOT Sphinx-build_COMMAND)
        set(__run_in_venv true)
    endif()

    if(NOT __run_in_venv AND _dsd_opts_EXTENSIONS)
        foreach(__ext IN LISTS _dsd_opts_EXTENSIONS)
            find_pip_package(${__ext})
            if(NOT ${__ext}_FOUND)
                set(__run_in_venv true)
                break()
            endif()
        endforeach()
    endif()

    if(__run_in_venv)
        include(UseVirtualenv)

        virtualenv_install(Sphinx)
        set(__gen_command "${venv_executor_COMMAND};sphinx-build")

        if(_dsd_opts_EXTENSIONS)
            foreach(__ext IN LISTS _dsd_opts_EXTENSIONS)
                virtualenv_install(${__ext})
            endforeach()
        endif()
    else()
        set(__gen_command "${Sphinx-build_COMMAND}")
    endif()

    #CF_dump_variables(EXTRA_CLEAN)
    add_custom_target(documentation_sphinx_generate_${_target_name}
        COMMENT "Generate Sphinx-doc documentation for ${_target_name}"
    )

    add_dependencies(documentation_sphinx_generate documentation_sphinx_generate_${_target_name})

    foreach(_format IN LISTS _dsd_opts_FORMATS)
        add_custom_target(documentation_sphinx_generate_${_target_name}_${_format}
            COMMAND 
                ${__gen_command}
                    -c ${_dsd_opts_CONFIG}
                    -d ${_dsd_opts_DESTINATION}/doctrees
                    -b ${_format}
                    ${__master_doc_dir}
                    ${_dsd_opts_DESTINATION}/${_format}
            COMMENT "Generate Sphinx-doc documentation for ${_target_name} in ${_format}"
            VERBATIM
        )
        add_dependencies(documentation_sphinx_generate_${_target_name} documentation_sphinx_generate_${_target_name}_${_format})
    endforeach()

endfunction()

# Epilogue ------------------------------------------------------------------- #
CF_module_epilogue()
# ---------------------------------------------------------------------------- #