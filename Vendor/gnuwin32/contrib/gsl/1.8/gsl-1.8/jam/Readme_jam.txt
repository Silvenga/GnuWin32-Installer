GSL - GNU Scientific Library
============================

This is GSL, the GNU Scientific Library, a collection of numerical
routines for scientific computing.  See README for more information.

GSL is free software, you can redistribute it and/or modify it under
the terms of the GNU General Public License (see COPYING).

The GNU General Public License does not permit this software to be
redistributed in proprietary programs.

This library is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

GSL 1.8 for Windows
===================

This distribution of GSL was generated from a slightly modified
gsl 1.8 source (see ChangeLog for more information on changes).
The static and dynamic libraries were compiled using MinGW gcc
(v 3.4.2).  MinGW import libraries for libgsl.dll and
libgslcblas.dll are provided.  Tools supplied with other compilers
should be able to generate import libraries from the dll's.

The libraries were compiled for release.  To compile debug versions,
link in a different cblas, or otherwise modify the libraries, the 
source code is available from:
    http://sourceforge.net/project/showfiles.php?group_id=23617.

Installation & Use
==================

GSL is primarily a library resource for numerical programming.  Place
the libraries and headers in a convenient location, and point your
compiler and linker there.

If you wish to use the dll version of GSL, note the following:

  - Define the macro GSL_DLL when compiling.  This will flag the
    public API functions & variables with __declspec(dllimport).

  - The libgsl.dll and libgslcblas.dll libraries must be located
    in the standard dll search path.  This is usually either in
    the same location as your executable, or in \windows\system32.

Building GSL Using Jam
======================

The gsl DLL build using jam is currently broken.
See Jamfile for more details 