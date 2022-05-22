# Requirements to CMake --------------------------------------------------------
cmake_minimum_required(VERSION 3.12)

include(DocSphinx)

configure_file(conf.py.in
               conf.py
    @ONLY
)

directory_sphinx_doc(${CMAKE_CURRENT_SOURCE_DIR}
    CONFIG  ${CMAKE_CURRENT_BINARY_DIR}
    EXTENSIONS sphinxcontrib-moderncmakedomain
)