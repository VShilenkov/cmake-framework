# include guard -------------------------------------------------------------- #
include_guard(GLOBAL)

# Prologue ------------------------------------------------------------------- #
CF_module_prologue(ControlFlow)
# ---------------------------------------------------------------------------- #

macro(CF_not_exists __path_var __mode)
    if(NOT EXISTS "${${__path_var}}")
       set(__message "┌${CF_lp_ControlFlow} Invalid path `${__path_var}`"
                   "\n├ Not exists: ${${__path_var}}"
        )
        if(${ARGC} GREATER 2)
            string(APPEND __message "\n├ ${ARGV2}")
        endif()
        string(APPEND __message "\n└${CF_lp_ControlFlow} CF_not_exists")
        message(${__mode} "${__message}")
        unset(__message)
    endif()
endmacro()

macro(CF_execute_process_fails __prefix __mode)
    if(NOT (${__prefix}_result STREQUAL "0" OR ${__prefix}_result EQUAL 0))
        set(__message "┌${CF_lp_ControlFlow} execute_process() fails with code: "
                      "${${__prefix}_result}"
        )
        if(DEFINED ${__prefix}_error)
            string(APPEND __message "\n├ error: ${${__prefix}_error}")
        endif()
        if(DEFINED ${__prefix}_output)
            string(APPEND __message "\n├ output: ${${__prefix}_output}")
        endif()
        if(${ARGC} GREATER 2)
            string(APPEND __message "\n├ ${ARGV2}")
        endif()
        string(APPEND __message "\n└${CF_lp_ControlFlow} CF_execute_process_fails")
        message(${__mode} ${__message})
        unset(__message)
    endif()
endmacro()

# Epilogue ------------------------------------------------------------------- #
CF_module_epilogue()
# ---------------------------------------------------------------------------- #