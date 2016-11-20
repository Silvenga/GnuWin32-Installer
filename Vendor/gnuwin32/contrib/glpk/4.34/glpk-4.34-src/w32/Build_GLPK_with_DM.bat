rem Build GLPK with Digital Mars C/C++ 8.50

rem NOTE: Make sure that HOME variable specifies correct path.
set HOME=C:\DM

set PATH=%HOME%\bin;%PATH%
copy config_DM config.h
%HOME%\bin\make.exe -f Makefile_DM
%HOME%\bin\make.exe -f Makefile_DM check

pause
