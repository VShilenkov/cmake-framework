.. _cmake-framework-modules:

.. only:: license

    Copyright 2017-2022 Vitalii Shylienkov

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
    DEALINGS IN THE SOFTWARE.

Modules
-------

Utility Modules
^^^^^^^^^^^^^^^

These modules are loaded using the 
:cmake:command:`include() <cmake_latest:command:include>` command.

.. toctree::
   :maxdepth: 1

   /module/Init


Default included
^^^^^^^^^^^^^^^^

These modules are included by default during CMake Framework initialization.

.. toctree::
   :maxdepth: 1

   /module/ControlFlow
   /module/Debug
   /module/Printer
   /module/Utilities

Find Modules
^^^^^^^^^^^^

These modules search for third-party software.
They are normally called through the 
:cmake:command:`find_package() <cmake_latest:command:find_package>` command.

.. toctree::
   :maxdepth: 1

   /module/FindBash
   /module/FindCMD

