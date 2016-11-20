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
The static and dynamic libraries were compiled using gcc 3.4.2 (MinGW).
gcc import libraries for libgsl.dll and libgslcblas.dll are provided in
the lib subdirectory.  Tools supplied with other compilers should be
able to generate import libraries from the dll's if necessary.
Significantly, newer versions of gcc (Cygwin & MinGW) support direct
linking of dll's without the need for an import library.

The libraries were compiled for release.  All modules were optimized at
gcc -O3 (except -O0 for monte/vegas.c, since any optimization by gcc/mingw
3.4.2 resulted in precision errors on testing).  To compile debug versions,
link in a different cblas, or otherwise modify the libraries, the
source code is available from:
    http://sourceforge.net/project/showfiles.php?group_id=23617.

gcc debug and MSVC versions of the libraries are also available from the
author of this port <jds2@users.sourceforge.net>.

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

What is Installed
=================

The following files are installed from the lib, libdbg (*), and doc (**)
distribution sets.

\contrib\gsl-1.8
     AUTHORS                original gsl-1.7 contributors
     BUGS                   original gsl-1.7 bug list
     ChangeLog              gsl-1.7 ChangeLog modified for GnuWin32
     COPYING                original gsl-1.7 license
     INSTALL                original gsl-1.7 install instructions
     NEWS                   original gsl-1.7 news
     README                 original gsl-1.7 Readme
     Readme_GnuWin32.txt    GnuWin32-specific Readme
     SUPPORT                original gsl-1.7 support notice
     THANKS                 original gsl-1.7 acknowledgements
     TODO                   original gsl-1.7 to-do list

\bin
     libgsl.dll             gsl-1.7 dynamic link library (release version)
     libgsl_d.dll           gsl-1.7 dynamic link library (gcc debug) (*)
     libgslcblas.dll        cblas dynamic link library (release version)
     libgslcblas_d.dll      cblas dynamic link library (gcc debug) (*)
     gsl-histogram.exe      program for calculating histograms for data
     gsl-randist.exe        program for generating data conforming to a specified distribution

\lib
     libgsl.a                gsl static library (gcc)
     libgsl_d.a              gsl static library (gcc debug) (*)
     libgslcblas.a           cblas static library (gcc)
     libgslcblas_d.a         cblas static library (gcc debug) (*)
     libgsl_dll.a            gcc import library for libgsl.dll
     libgsl_d_dll.a          gcc import library for libgsl_d.dll (*)
     libgslcblas_dll.a       gcc import library for libgslcblas.dll
     libgslcblas_d_dll.a     gcc import library for libgslcblas_d.dll (*)
     libgsl.def              export definitions for libgsl.dll
     libgslcblas.def         export definitions for libgslcblas.dll

\doc (**)
\info
\man1
\man3
     gsl help in various formats

\include\gsl
     gsl include files

Building GSL
============

GSL may be built using MinGW and ftjam.
See .\jam\Readme_jam.txt for more information on this build option.

GSL may also be built using VC8.
See .\VC8\Readme_VC8.htm for more information on this build option.

