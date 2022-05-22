# include guard -------------------------------------------------------------- #
include_guard(GLOBAL)

# Prologue ------------------------------------------------------------------- #
CF_module_prologue(UseVirtualenv)
# ---------------------------------------------------------------------------- #

find_package(Virtualenv REQUIRED)

set(__bash_driver Bash)
set(__bash_suffix sh)

set(__batch_driver CMD)
set(__batch_suffix bat)

if(WIN32 AND NOT (CYGWIN OR MINGW))
    set(__activator_list batch)
else()
    set(__activator_list bash)
endif()

foreach(__activator IN LISTS __activator_list)
    find_package(${__${__activator}_driver} QUIET)

    if(${__${__activator}_driver}_FOUND)
        set(${_cmfm_NAME}_activator "${__activator}")
        set(${_cmfm_NAME}_driver "${${__${__activator}_driver}_COMMAND}")
        set(${_cmfm_NAME}_suffix "${__${__activator}_suffix}")
        break()
    endif()
endforeach()
unset(__activator)
unset(__activator_list)

if(NOT ${_cmfm_NAME}_activator)
    message(FATAL_ERROR "${CF_lp_UseVirtualenv} wasn't able to find any suitable activator")
endif()

if(NOT DEFINED ${_cmfm_NAME}_ENV_DIR)
    set(${_cmfm_NAME}_ENV_DIR "${CMAKE_BINARY_DIR}/venv")
endif()

# lite check. should be stronger
if(NOT EXISTS ${${_cmfm_NAME}_ENV_DIR})
    execute_process(
        COMMAND
            ${Virtualenv_COMMAND}
                --system-site-packages
                --activators ${${_cmfm_NAME}_activator}
                ${${_cmfm_NAME}_ENV_DIR}
        RESULT_VARIABLE create_venv_result
        OUTPUT_VARIABLE create_venv_output
        ERROR_VARIABLE  create_venv_error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
    )

    CF_execute_process_fails(create_venv FATAL_ERROR)
    CF_execute_process_wipe(create_venv)
    message(STATUS "${CF_lp_UseVirtualenv} Virtual environment set at ${${_cmfm_NAME}_ENV_DIR}")
endif()

unset(${_cmfm_NAME}_activator_EXECUTABLE)
find_file(${_cmfm_NAME}_activator_EXECUTABLE
    NAMES   activate
            activate.bat
    HINTS   ${${_cmfm_NAME}_ENV_DIR}
    PATH_SUFFIXES
        bin
        Scripts
    DOC     "The ${_cmfm_NAME}_activator executable"
    NO_DEFAULT_PATH
    NO_PACKAGE_ROOT_PATH
    NO_CMAKE_PATH
    NO_CMAKE_ENVIRONMENT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_FIND_ROOT_PATH
)

if(NOT ${_cmfm_NAME}_activator_EXECUTABLE)
    message(FATAL_ERROR "${CF_lp_UseVirtualenv} Activation script missing")
endif()

file(TO_NATIVE_PATH "${${_cmfm_NAME}_driver}" ${_cmfm_NAME}_driver)

configure_file(
    ${CMAKE_CURRENT_LIST_DIR}/UseVirtualenv/venv_executor.${${_cmfm_NAME}_activator}.in
                                            venv_executor.${${_cmfm_NAME}_suffix}
    @ONLY
)

set(venv_executor_COMMAND "${CMAKE_BINARY_DIR}/venv_executor.${${_cmfm_NAME}_suffix}" CACHE STRING "")

unset(${_cmfm_NAME}_suffix)
unset(${_cmfm_NAME}_driver)

function(virtualenv_install package_name)
    if(${package_name}_VENV_FOUND)
        return()
    endif()
    execute_process(
        COMMAND
            ${venv_executor_COMMAND} pip3 install '${package_name}'
        RESULT_VARIABLE pip3_install_result
        OUTPUT_VARIABLE pip3_install_output
        ERROR_VARIABLE  pip3_install_error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
    )

    CF_execute_process_fails(pip3_install WARNING "virtualenv_install: cannot install ${package_name}")
    if(pip3_install_result EQUAL 0)
        set(${package_name}_VENV_FOUND TRUE CACHE BOOL "")
    endif()
    CF_execute_process_wipe(pip3_install)
endfunction()


# clean-up ------------------------------------------------------------------- #
unset(__bash_driver)
unset(__bash_suffix)
unset(__batch_driver)
unset(__batch_suffix)

# Epilogue ------------------------------------------------------------------- #
CF_module_epilogue()
# ---------------------------------------------------------------------------- #
