set(FetchContentTargets "")

set(FetchContentCommands __fetchcontent_declaredetails
                         __fetchcontent_directpopulate
                         __fetchcontent_getsaveddetails
                         __fetchcontent_setupfindpackageredirection
                         fetchcontent_declare
                         fetchcontent_getproperties
                         fetchcontent_makeavailable
                         fetchcontent_populate
                         fetchcontent_setpopulated
)

set(FetchContentMacros FetchContent_MakeAvailable)

set(FetchContentVariables FETCHCONTENT_BASE_DIR
                          FETCHCONTENT_FULLY_DISCONNECTED
                          FETCHCONTENT_QUIET
                          FETCHCONTENT_SOURCE_DIR_RAILROAD_JAR_PACKAGE
                          FETCHCONTENT_UPDATES_DISCONNECTED
                          FETCHCONTENT_UPDATES_DISCONNECTED_RAILROAD_JAR_PACKAGE
                          __cmake_arg_SYSTEM
                          __cmake_arg_UNPARSED_ARGUMENTS
                          __cmake_fcCurrentVarsStack
                          __cmake_haveFpArgs
)