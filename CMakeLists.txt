# Requirements to CMake ------------------------------------------------------ #
cmake_minimum_required(VERSION 3.12)

# Project declaration -------------------------------------------------------- #
project(CMakeFramework
    VERSION      0.0.1
    DESCRIPTION  "Collection of modules, finders and scripts"
    HOMEPAGE_URL https://cmake-framework.readthedocs.io/
    LANGUAGES    NONE
)

# Includes ------------------------------------------------------------------- #

include(FeatureSummary)

# framework init
include(cmake/modules/Init.cmake)

# CMake native modules

# Utility modules
include(GlobalOptions)

# Documenting ---------------------------------------------------------------- #
if(WITH_DOCUMENTING)
    add_subdirectory(docs)
endif()

# Testing -------------------------------------------------------------------- #
if(WITH_UNIT_TEST)
    add_subdirectory(tests)
endif()

#TODO:VSH installation

# Feature summary ------------------------------------------------------------ #
feature_summary(WHAT ALL
    DESCRIPTION "-- [${PROJECT_NAME} summary] ---------------------------------"
)