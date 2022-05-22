# include guard -------------------------------------------------------------- #
include_guard(GLOBAL)

if(CF_INITIALIZED)
    return()
endif()

set(CF_lp "[CF]" CACHE INTERNAL "CMakeFramework logging prefix")

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

macro(CF_module_epilogue)
    # clean-up
    unset(_cmfm_Q_NAME)
    unset(_cmfm_NAME)
endmacro()

macro(CF_find_prologue)
    set(_cmff_NAME "${CMAKE_FIND_PACKAGE_NAME}")
    string(TOUPPER "${_cmff_NAME}" _CMFF_NAME)
    set(CF_lp_${_cmff_NAME} "${CF_lp} ${_cmff_NAME}:" CACHE INTERNAL "Find${_cmff_NAME} logging prefix")
endmacro()

macro(CF_find_epilogue)
    # clean-up
    unset(_CMFF_NAME)
    unset(_cmff_NAME)
endmacro()

# Prologue ------------------------------------------------------------------- #
CF_module_prologue(Init)
# ---------------------------------------------------------------------------- #

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

# Populate `CMAKE_MODULE_PATH`
# imitate `list(PREPEND)`
if(CMAKE_MODULE_PATH)
    list(REVERSE CMAKE_MODULE_PATH)
endif()
list(APPEND CMAKE_MODULE_PATH "${CMakeFramework-ROOT}/modules")
list(APPEND CMAKE_MODULE_PATH "${CMakeFramework-ROOT}/finders")
list(REVERSE CMAKE_MODULE_PATH)

# panoply with tools
include(${CMakeFramework-ROOT}/tools/Printer.cmake)
include(${CMakeFramework-ROOT}/tools/ControlFlow.cmake)
include(${CMakeFramework-ROOT}/tools/Debug.cmake)
include(${CMakeFramework-ROOT}/tools/Utilities.cmake)

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