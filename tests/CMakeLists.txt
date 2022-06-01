cmake_minimum_required(VERSION 3.12)

macro(CF_test_collect_status __suffix)
    if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.21)
        get_directory_property(${PROJECT_NAME}_imported_targets_${__suffix} IMPORTED_TARGETS)
        list(LENGTH
            ${PROJECT_NAME}_imported_targets_${__suffix}
            ${PROJECT_NAME}_imported_targets_length_${__suffix}
        )
    endif()

    get_cmake_property(${PROJECT_NAME}_commands_${__suffix} COMMANDS)
    list(LENGTH
        ${PROJECT_NAME}_commands_${__suffix}
        ${PROJECT_NAME}_commands_length_${__suffix}
    )

    get_directory_property(${PROJECT_NAME}_macros_${__suffix} MACROS)

    # remove macros created by `find_package_handle_standard_args()`
    list(FILTER ${PROJECT_NAME}_macros_${__suffix} EXCLUDE REGEX "^_FPHSA_.*")
    
    list(LENGTH
        ${PROJECT_NAME}_macros_${__suffix}
        ${PROJECT_NAME}_macros_length_${__suffix}
    )

    get_cmake_property(${PROJECT_NAME}_variables_${__suffix} VARIABLES)
    list(FILTER ${PROJECT_NAME}_variables_${__suffix} EXCLUDE REGEX "^${PROJECT_NAME}.*")
    list(FILTER ${PROJECT_NAME}_variables_${__suffix} EXCLUDE REGEX "^FIND_PACKAGE_.*")
    list(FILTER ${PROJECT_NAME}_variables_${__suffix} EXCLUDE REGEX "^CF_lp_.*")
    list(LENGTH
        ${PROJECT_NAME}_variables_${__suffix}
        ${PROJECT_NAME}_variables_length_${__suffix}
    )

endmacro()

macro(CF_test_expect_targets __before __after)
    set(multiValueArgs TARGETS)
    cmake_parse_arguments(_opt "" "" "${multiValueArgs}" ${ARGN})

    CF_list_difference(${__after} ${__before} unexpected_targets)

    if(_opt_TARGETS)
        foreach(__target IN LISTS _opt_TARGETS)
            if(NOT TARGET ${__target})
                message(FATAL_ERROR "${__test_lp} No target ${__target}")
            endif()
        endforeach()
        message(STATUS "${__test_lp} All expected targets defined")
        CF_list_difference(unexpected_targets _opt_TARGETS unexpected_targets)
    endif()

    list(LENGTH unexpected_targets _length_diff)
    if(_length_diff GREATER 0)
        message(STATUS "${__test_lp} Unexpected targets introduced: ")
        CF_print_list(unexpected_targets)
        message(WARNING "${__test_lp} Test failed")
    else()
        message(STATUS "${__test_lp} No unexpected targets defined")
    endif()
endmacro()

macro(CF_test_expect_commands __before __after)
    set(multiValueArgs COMMANDS)
    cmake_parse_arguments(_opt "" "" "${multiValueArgs}" ${ARGN})

    CF_list_difference(${__after} ${__before} unexpected_commands)

    if(_opt_COMMANDS)
        foreach(__command IN LISTS _opt_COMMANDS)
            if(NOT COMMAND ${__command})
                message(FATAL_ERROR "${__test_lp} No command ${__command}")
            endif()
        endforeach()
        message(STATUS "${__test_lp} All expected commands defined")
        CF_list_difference(unexpected_commands _opt_COMMANDS unexpected_commands)
    endif()

    list(LENGTH unexpected_commands _length_diff)
    if(_length_diff GREATER 0)
        message(STATUS "${__test_lp} Unexpected commands introduced: ")
        CF_print_list(unexpected_commands)
        message(WARNING "${__test_lp} Test failed")
    else()
        message(STATUS "${__test_lp} No unexpected commands defined")
    endif()
endmacro()

macro(CF_test_expect_macros __before __after)
    set(multiValueArgs MACROS)
    cmake_parse_arguments(_opt "" "" "${multiValueArgs}" ${ARGN})

    CF_list_difference(${__after} ${__before} unexpected_macros)

    if(_opt_MACROS)
        foreach(__macro IN LISTS _opt_MACROS)
            if(NOT COMMAND ${__macro})
                message(FATAL_ERROR "${__test_lp} No macro ${__macro}")
            endif()
        endforeach()
        message(STATUS "${__test_lp} All expected macros defined")
        CF_list_difference(unexpected_macros _opt_MACROS unexpected_macros)
    endif()

    list(LENGTH unexpected_macros _length_diff)
    if(_length_diff GREATER 0)
        message(STATUS "${__test_lp} Unexpected macros introduced: ")
        CF_print_list(unexpected_macros)
        message(WARNING "${__test_lp} Test failed")
    else()
        message(STATUS "${__test_lp} No unexpected macros defined")
    endif()
endmacro()

macro(CF_test_expect_variables __before __after)
    set(multiValueArgs VARIABLES CACHED)
    cmake_parse_arguments(_opt "" "" "${multiValueArgs}" ${ARGN})

    CF_list_difference(${__after} ${__before} unexpected_variables)

    if(_opt_VARIABLES)
        foreach(__variable IN LISTS _opt_VARIABLES)
            if(NOT DEFINED ${__variable})
                message(FATAL_ERROR "${__test_lp} No variable ${__variable}")
            endif()
        endforeach()
        message(STATUS "${__test_lp} All expected variables defined")
        CF_list_difference(unexpected_variables _opt_VARIABLES unexpected_variables)
    endif()

    if(_opt_CACHED)
        foreach(__variable IN LISTS _opt_CACHED)
            if(NOT DEFINED CACHE{${__variable}})
                message(FATAL_ERROR "${__test_lp} No cache variable ${__variable}")
            endif()
        endforeach()
        message(STATUS "${__test_lp} All expected cache variables defined")
        CF_list_difference(unexpected_variables _opt_CACHED unexpected_variables)
    endif()

    list(LENGTH unexpected_variables _length_diff)
    if(_length_diff GREATER 0)
        message(STATUS "${__test_lp} Unexpected variables introduced: ")
        CF_print_list(unexpected_variables)
        message(WARNING "${__test_lp} Test failed")
    else()
        message(STATUS "${__test_lp} No unexpected variables defined")
    endif()

    CF_list_difference(${__before} ${__after} missed_variables)
    list(LENGTH missed_variables _length_diff)
    if(_length_diff GREATER 0)
        message(STATUS "${__test_lp} Variables missing: ")
        CF_print_list(missed_variables)
        message(WARNING "${__test_lp} Test failed")
    else()
        message(STATUS "${__test_lp} No missing variables")
    endif()

endmacro()

add_subdirectory(finders)

## TODO:VSH initial state check

## Utilities check
## Tools check

## Development zone


#find_package(Pip3)
#find_package(Virtualenv)

#find_pip_package(sphinxcontrib-moderncmakedomain)

#include(UseVirtualenv)

#virtualenv_install(pyxml2dict)
#find_pip_package(pygccxml)

#find_package(Sphinx COMPONENTS apidoc quickstart)
#CF_dump_variables(EXTRA_CLEAN)
