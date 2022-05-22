# includes ------------------------------------------------------------------- #
include(FeatureSummary)
include(FindPackageHandleStandardArgs)

# prologue ------------------------------------------------------------------- #
CF_find_prologue()

# declare package properties ------------------------------------------------- #
set_package_properties(${_cmff_NAME}
    PROPERTIES
        URL         "http://tiswww.case.edu/php/chet/bash/bashtop.html"
        DESCRIPTION "A GNU Project's shell—the Bourne Again SHell"
)

# validate find_package() arguments ------------------------------------------ #
## no components supported
if(${_cmff_NAME}_FIND_COMPONENTS AND NOT ${_cmff_NAME}_FIND_QUIETLY)
    message(WARNING "${CF_lp_Bash} components not supported")
endif()

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
    NAMES         bash
    HINTS         ${${_cmff_NAME}_hints}
        ENV       ${_cmff_NAME}_DIR
        ENV       ${_cmff_NAME}_DIR
    DOC           "The ${_cmff_NAME} executable"
)
unset(${_cmff_NAME}_hints)

# build command -------------------------------------------------------------- #
if(${_cmff_NAME}_EXECUTABLE)
    set(${_cmff_NAME}_COMMAND "${${_cmff_NAME}_EXECUTABLE}" CACHE STRING "The ${_cmff_NAME} command")
    mark_as_advanced(${_cmff_NAME}_EXECUTABLE ${_cmff_NAME}_COMMAND)
endif()

# find version --------------------------------------------------------------- #
if(${_cmff_NAME}_COMMAND)
    execute_process(
        COMMAND
            ${${_cmff_NAME}_COMMAND} --version
        RESULT_VARIABLE ${_cmff_NAME}_version_result
        OUTPUT_VARIABLE ${_cmff_NAME}_version_output
        ERROR_VARIABLE  ${_cmff_NAME}_version_error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
    )

    CF_execute_process_fails(${_cmff_NAME}_version WARNING)
    if(${_cmff_NAME}_version_result EQUAL 0)
        if(${_cmff_NAME}_version_output MATCHES "GNU bash, version ([.0-9]+)")
            set(${_cmff_NAME}_VERSION_STRING "${CMAKE_MATCH_1}")

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
    REQUIRED_VARS ${_cmff_NAME}_EXECUTABLE
                  ${_cmff_NAME}_COMMAND
    VERSION_VAR   ${_cmff_NAME}_VERSION_STRING
    FAIL_MESSAGE  "bash not found, installation: ${PROJECT_HOMEPAGE_URL}"
)

# epilogue ------------------------------------------------------------------- #
CF_find_epilogue()
