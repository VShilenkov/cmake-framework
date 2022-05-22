# include guard -------------------------------------------------------------- #
include_guard(GLOBAL)

# Prologue ------------------------------------------------------------------- #
CF_module_prologue(GlobalOptions)
# ---------------------------------------------------------------------------- #

include(FeatureSummary)

set(__WITH_DOCUMENTING_desc "Generate documentation for all projects")
option(WITH_DOCUMENTING "${__WITH_DOCUMENTING_desc}" OFF)
add_feature_info([ALL].Documenting WITH_DOCUMENTING "${__WITH_DOCUMENTING_desc}")
unset(__WITH_DOCUMENTING_desc)

set(__WITH_UNIT_TEST_desc "Build unit tests for all projects")
option(WITH_UNIT_TEST "${__WITH_UNIT_TEST_desc}" OFF)
add_feature_info([ALL].Unit-tests WITH_UNIT_TEST "${__WITH_UNIT_TEST_desc}")
unset(__WITH_UNIT_TEST_desc)

set(__WITH_COMPONENT_TEST_desc "Build component tests for all projects")
option(WITH_COMPONENT_TEST "${__WITH_COMPONENT_TEST_desc}" OFF)
add_feature_info([ALL].Component-tests WITH_COMPONENT_TEST "${__WITH_COMPONENT_TEST_desc}")
unset(__WITH_COMPONENT_TEST_desc)

set(__WITH_SW_ELEMENT_TEST_desc "Build software element tests for all projects")
option(WITH_SW_ELEMENT_TEST "${__WITH_SW_ELEMENT_TEST_desc}" OFF)
add_feature_info([ALL].Software-Element-tests WITH_SW_ELEMENT_TEST "${__WITH_SW_ELEMENT_TEST_desc}")
unset(__WITH_SW_ELEMENT_TEST_desc)

set(__WITH_COVERAGE_desc "Generate code coverage counters for all projects")
option(WITH_COVERAGE "${__WITH_COVERAGE_desc}" OFF)
add_feature_info([ALL].Coverage WITH_COVERAGE "${__WITH_COVERAGE_desc}")
unset(__WITH_COVERAGE_desc)

set(__WITH_EXAMPLE_desc "Build examples for all projects")
option(WITH_EXAMPLE "${__WITH_EXAMPLE_desc}" OFF)
add_feature_info([ALL].Example WITH_EXAMPLE "${__WITH_EXAMPLE_desc}")
unset(__WITH_EXAMPLE_desc)

set(__ENGINEERING_BUILD_desc "Build all projects as engineering variant")
option(ENGINEERING_BUILD "${__ENGINEERING_BUILD_desc}" OFF)
add_feature_info([ALL].Engineering-build ENGINEERING_BUILD "${__ENGINEERING_BUILD_desc}")
unset(__ENGINEERING_BUILD_desc)

set(__WITH_INCLUDE_WHAT_YOU_USE_desc "Build with include-what-you-use globally enabled")
option(WITH_INCLUDE_WHAT_YOU_USE "${__WITH_INCLUDE_WHAT_YOU_USE_desc}" OFF)
add_feature_info([GLOBAL].include-what-you-use WITH_INCLUDE_WHAT_YOU_USE "${__WITH_INCLUDE_WHAT_YOU_USE_desc}")
unset(__WITH_INCLUDE_WHAT_YOU_USE_desc)

set(__WITH_CLANG_TIDY_desc "Build with clang-tidy globally enabled")
option(WITH_CLANG_TIDY "${__WITH_CLANG_TIDY_desc}" OFF)
add_feature_info([GLOBAL].clang-tidy WITH_CLANG_TIDY "${__WITH_CLANG_TIDY_desc}")
unset(__WITH_CLANG_TIDY_desc)

# Epilogue ------------------------------------------------------------------- #
CF_module_epilogue()
# ---------------------------------------------------------------------------- #
