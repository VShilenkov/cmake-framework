# include guard -------------------------------------------------------------- #
include_guard(GLOBAL)

# Prologue ------------------------------------------------------------------- #
CF_module_prologue(Debug)
# ---------------------------------------------------------------------------- #

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