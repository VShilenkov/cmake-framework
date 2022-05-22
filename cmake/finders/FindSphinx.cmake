# includes ------------------------------------------------------------------- #
include(FeatureSummary)
include(FindPackageHandleStandardArgs)

# prologue ------------------------------------------------------------------- #
CF_find_prologue()

# declare package properties ------------------------------------------------- #
set_package_properties(${_cmff_NAME}
    PROPERTIES
        URL         "https://www.sphinx-doc.org/en/master/index.html"
        DESCRIPTION "A documentation generator written and used by the Python community"
)

# validate find_package() arguments ------------------------------------------ #
## components
### mandatory
set(${_cmff_NAME}_FIND_REQUIRED_build True)

if(NOT DEFINED ${_cmff_NAME}_FIND_COMPONENTS)
    set(${_cmff_NAME}_FIND_COMPONENTS build)
elseif(NOT build IN_LIST ${_cmff_NAME}_FIND_COMPONENTS)
    list(APPEND ${_cmff_NAME}_FIND_COMPONENTS build)
endif()

### unsupported
set(${_cmff_NAME}_supported_components build apidoc autobuild autogen quickstart)

foreach(__component IN LISTS ${_cmff_NAME}_FIND_COMPONENTS)
    if(NOT ${__component} IN_LIST ${_cmff_NAME}_supported_components)
        message(FATAL_ERROR "${CF_lp_Sphinx} Unknown component: ${__component}")
    endif()
endforeach()

unset(${_cmff_NAME}_supported_components)

# hints ---------------------------------------------------------------------- #
set(${_cmff_NAME}_hints "")
foreach(dir ${_cmff_NAME}_DIR ${_CMFF_NAME}_DIR)
    if(DEFINED ${dir})
        list(APPEND ${_cmff_NAME}_hints "${${dir}}")
    endif()
endforeach()
unset(dir)

if(NOT DEFINED Python3_COMMAND)
    find_package(Python3 COMPONENTS Interpreter REQUIRED)
    set(Python3_COMMAND "${Python3_EXECUTABLE}" CACHE STRING "Command to invoke Python3")
endif()

execute_process(
    COMMAND ${Python3_COMMAND} -m site --user-base
    RESULT_VARIABLE user_base_dir_result
    OUTPUT_VARIABLE user_base_dir_output
    ERROR_VARIABLE  user_base_dir_error
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_STRIP_TRAILING_WHITESPACE
)

CF_execute_process_fails(user_base_dir WARNING)

if(user_base_dir_result EQUAL 0)
    list(APPEND ${_cmff_NAME}_hints "${user_base_dir_output}")
endif()

CF_execute_process_wipe(user_base_dir)

# find executable ------------------------------------------------------------ #
foreach(__component IN LISTS ${_cmff_NAME}_FIND_COMPONENTS)

    find_program(${_cmff_NAME}-${__component}_EXECUTABLE
        NAMES         sphinx-${__component} 
        HINTS         ${${_cmff_NAME}_hints}
            ENV       ${_cmff_NAME}_DIR
            ENV       ${_cmff_NAME}_DIR
        PATH_SUFFIXES bin Scripts
        DOC           "The ${_cmff_NAME}-${__component} executable"
    )

    if(${_cmff_NAME}-${__component}_EXECUTABLE)
        set(${_cmff_NAME}-${__component}_COMMAND ${${_cmff_NAME}-${__component}_EXECUTABLE} CACHE STRING "The ${_cmff_NAME}-${__component} command")
        mark_as_advanced(${_cmff_NAME}-${__component}_EXECUTABLE ${_cmff_NAME}-${__component}_COMMAND)
        set(${_cmff_NAME}_${__component}_FOUND TRUE)
    endif()
endforeach()
unset(${_cmff_NAME}_hints)
unset(__component)

# find version --------------------------------------------------------------- #

#[=[
| version | format                          |
| ------- | ------------------------------- |
| 1.7+    | "sphinx-build 2.4.2"            |
| 1.2-1.6 | "Sphinx (sphinx-build) 1.4.2"   |
| 1.1-    | "Sphinx v1.0.2"                 |
#]=]

if(${_cmff_NAME}-build_COMMAND)
    execute_process(
        COMMAND
            ${${_cmff_NAME}-build_COMMAND} --version
        RESULT_VARIABLE ${_cmff_NAME}_version_result
        OUTPUT_VARIABLE ${_cmff_NAME}_version_output
        ERROR_VARIABLE  ${_cmff_NAME}_version_error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
    )

    CF_execute_process_fails(${_cmff_NAME}_version WARNING)
    if(${_cmff_NAME}_version_result EQUAL 0)
        if(${_cmff_NAME}_version_output MATCHES "sphinx-build ([0-9]+\\.[0-9]+(\\.|a?|b?)([0-9]*)(b?)([0-9]*))")
            set(${_cmff_NAME}_VERSION_STRING "${CMAKE_MATCH_1}")
        elseif(${_cmff_NAME}_version_output MATCHES "Sphinx v([0-9]+\\.[0-9]+(\\.|b?)([0-9]*)(b?)([0-9]*))")
            set(${_cmff_NAME}_VERSION_STRING "${CMAKE_MATCH_1}")
        elseif(${_cmff_NAME}_version_output MATCHES "Sphinx \\(sphinx-build\\) ([0-9]+\\.[0-9]+(\\.|a?|b?)([0-9]*)(b?)([0-9]*))")
            set(${_cmff_NAME}_VERSION_STRING "${CMAKE_MATCH_1}")
        endif()

        if(${_cmff_NAME}_VERSION_STRING)
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
    REQUIRED_VARS ${_cmff_NAME}-build_EXECUTABLE
                  ${_cmff_NAME}-build_COMMAND
    VERSION_VAR   ${_cmff_NAME}_VERSION_STRING
    FAIL_MESSAGE  "sphinx not found, installation: https://www.sphinx-doc.org/en/master/usage/installation.html"
    HANDLE_COMPONENTS
)

# epilogue ------------------------------------------------------------------- #
CF_find_epilogue()
