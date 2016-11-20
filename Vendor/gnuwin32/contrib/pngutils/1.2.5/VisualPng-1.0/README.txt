Microsoft Developer Studio Build File, Format Version 6.00 for VisualPng
------------------------------------------------------------------------


Assumes that libpng DLLs and LIBs are in ..\..\msvc\win32\libpng
Assumes that zlib DLLs and LIBs are in ..\..\msvc\win32\zlib

To build:

1) On the main menu Select "Build|Set Active configuration".
   Choose the configuration that corresponds to the library you want to test.
   This library must have been built using the libpng MS project located in
   the "mscv" subdirectory.

2) Select "Build|Clean"

3) Select "Build|Rebuild All"

4) After compiling and linking VisualPng will be started to view an image
   from the PngSuite directory. Press Ctrl-N (and Ctrl-V) for other images.


To install:

When distributing VisualPng (or a further development) the following options
are available:

1) Build the program with the configuration "Win32 LIB" and you only need to
   include the executable from the ./lib directory in your distribution.

2) Build the program with the configuration "Win32 DLL" and you need to put
   in your distribution the executable from the ./dll directory and the dll's
   libpng1.dll, zlib.dll and msvcrt.dll.


Willem van Schaik
Calgary, June 6th 2000



PS. VisualPng was written based on preliminary work of:

    - Simon-Pierre Cadieux
    - Glenn Randers-Pehrson
    - Greg Roelofs

