rem Build GLPK with Dev-C++

rem NOTE: Make sure that HOME variable specifies correct path.
set HOME=C:\Dev-Cpp

set PATH=%HOME%\bin;%HOME%\libexec\gcc\mingw32\3.4.2;%PATH%
copy config_Dev config.h
%HOME%\bin\make.exe -f Makefile_Dev
%HOME%\bin\make.exe -f Makefile_Dev check

pause
