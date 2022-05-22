# Requirements to CMake --------------------------------------------------------
cmake_minimum_required(VERSION 3.12)

# Project declaration ----------------------------------------------------------
project(CMakeFramework
    VERSION      0.0.1
    DESCRIPTION  "Collection of modules, finders and scripts"
    #HOMEPAGE_URL https://github.com/VShilenkov/cmake
    LANGUAGES    NONE
)

# Includes ---------------------------------------------------------------------

include(FeatureSummary)

# framework init
include(cmake/modules/Init.cmake)

include(GlobalOptions)
#find_package(Pip3)
#find_package(Virtualenv)

if(WITH_DOCUMENTING)
    add_subdirectory(docs)
endif()
#find_pip_package(sphinxcontrib-moderncmakedomain)

#include(UseVirtualenv)

#virtualenv_install(pyxml2dict)
#find_pip_package(pygccxml)

#find_package(Sphinx COMPONENTS apidoc quickstart)
#CF_dump_variables(EXTRA_CLEAN)

# Feature summary --------------------------------------------------------------
feature_summary(WHAT ALL
    DESCRIPTION "-- [${PROJECT_NAME} summary] ---------------------------------"
)