#[================[ LICENSE ]==================================================]

MIT License

Copyright (c) 2022 Vitalii Shylienkov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

#]================]

# Requirements to CMake ------------------------------------------------------ #
cmake_minimum_required(VERSION 3.12)

CF_not_defined(${PROJECT_NAME}-INSTALL_DIR FATAL_ERROR)

# installation of utility modules -------------------------------------------- #
install(FILES   GlobalOptions.cmake
                DocSphinx.cmake
                Init.cmake
                UseVirtualenv.cmake
                UseRailroad.cmake
    DESTINATION "${${PROJECT_NAME}-INSTALL_DIR}/modules"
    COMPONENT   framework::modules
)

install(FILES   UseVirtualenv/venv_executor.bash.in
                UseVirtualenv/venv_executor.batch.in
    DESTINATION "${${PROJECT_NAME}-INSTALL_DIR}/modules/UseVirtualenv"
    COMPONENT   framework::modules
)