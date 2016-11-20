rem Build GLPK with Borland C++ 5.0

rem NOTE: Make sure that HOME variable specifies correct path.
set HOME=C:\BC5

copy config_BC5 config.h
%HOME%\bin\make.exe -f Makefile_BC5
%HOME%\bin\make.exe -f Makefile_BC5 check

pause
