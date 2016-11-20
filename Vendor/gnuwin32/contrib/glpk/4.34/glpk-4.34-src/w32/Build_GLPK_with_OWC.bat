rem Build GLPK with Open Watcom C/C++ 1.6

rem NOTE: Make sure that HOME variable specifies correct path.
set HOME=C:\WATCOM

set WATCOM=%HOME%
set PATH=%WATCOM%\BINNT;%WATCOM%\BINW;%PATH%
set INCLUDE=%WATCOM%\H
copy config_OWC config.h
wmake.exe /f Makefile_OWC
wmake.exe /f Makefile_OWC check

pause
