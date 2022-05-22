# include guard -------------------------------------------------------------- #
include_guard(GLOBAL)

# Prologue ------------------------------------------------------------------- #
CF_module_prologue(Utilities)
# ---------------------------------------------------------------------------- #

macro(CF_execute_process_wipe _prefix)
    foreach(_suffix result output error)
        unset(${_prefix}_${_suffix})
    endforeach()
    unset(_suffix)
endmacro()

# Epilogue ------------------------------------------------------------------- #
CF_module_epilogue()
# ---------------------------------------------------------------------------- #