:: -----------------------------------------------------------------
::
:: StartCmd.bat: Initialise cmd.exe environments
::
:: author : Mathias Michaelis <michaelis@tcnet.ch>
:: date   : May 4, 2006
:: version: 0.0
::
:: -----------------------------------------------------------------
::
:: Permission is granted to copy, distribute and/or modify this document
:: under the terms of the GNU Free Documentation License, Version 1.2
:: or any later version published by the Free Software Foundation;
:: with no Invariant Sections, no Front-Cover Texts, and no Back-Cover
:: Texts.
::
:: Usage:
::
:: You may define with regedt32.exe one or both of the registry keys
::
:: HKEY_LOCAL_MACHINE\Software\Microsoft\Command Processor\AutoRun
:: HKEY_CURRENT_USER\Software\Microsoft\Command Processor\AutoRun
::
:: e.g. with a value like
::
:: if exist "%APPDATA%\StartCmd.bat" call "%APPDATA%\StartCmd.bat"
::
:: Now this script is automatically started by cmd.exe for each user
:: who has put this StartCmd.bat script into his/her %APPDATA%
:: directory.
::
:: The following code will analyse the environment variable
:: %CMDCMDLINE%. If cmd.exe is started by a Windows (R) shortcut
:: that runs set_gnuwin32.bat or any other set_xyz.bat file, this
:: code will retrieve the -s switch of that file and define the
:: environment variable SHELL_ENVIRONMENT accordingly. You may
:: adopt this script, e.g. for setting different colors for
:: each environment you are managing by set_xyz.bat files.
::
@echo off

::
:: Look for a start command (after /K switch):
::
set start_cmd=_%CMDCMDLINE%
set start_cmd=%start_cmd:* /K =#%
if not %start_cmd:~0,1%==# goto tidy_up
set start_cmd=%start_cmd:~1%
set start_cmd=%start_cmd:"=%

::
:: Look if the start command is a set_xyz.bat command:
::
:looking_next_set
set start_cmd=_%start_cmd%
set start_cmd=%start_cmd:*\set_=#%
if not %start_cmd:~0,1%==# goto tidy_up
set start_args=%start_cmd:~1%
set start_cmd=set_%start_args%

::
:: The start command must end with .bat
::
:loop_start_cmd
if "%start_args%"=="" goto tidy_up
if "%start_args:~0,1%"=="\" goto looking_next_set
if "%start_args:~0,1%"=="/" goto looking_next_set
if "%start_args:~0,1%"==":" goto tidy_up
if "%start_args:~0,5%"==".bat " goto end_loop_start_cmd
set start_args=%start_args:~1%
goto loop_start_cmd

::
:: There must be an -s argument
::
:end_loop_start_cmd
set start_args=%start_args:~5%
set env_name=_%start_args%
set env_name=%env_name:*-s =#%
if %env_name:~0,1%==_ goto tidy_up
set env_name=%env_name:~1%

::
:: After -s must stand the unquoted environment name
::
:loop_env_name
if "%env_name%"=="" goto tidy_up
if "%env_name:~0,1%"==" " goto tidy_up
set SHELL_ENVIRONMENT=%SHELL_ENVIRONMENT%%env_name:~0,1%
set env_name=%env_name:~1%
goto loop_env_name

::
:: Clean up the environment. First define all variables before
:: undefining them to prevent cmd.exe to return 1.
::
:tidy_up
set start_cmd=1
set start_args=1
set env_name=1
set start_cmd=
set start_args=
set env_name=
if .%SHELL_ENVIRONMENT%.==.. goto common_commands

::
:: At this place you may insert special treatment for different
:: values of SHELL_ENVIRONMENT
:: 
goto common_commands

::
:: Common configuration for all environments
::
:common_commands
prompt $N:$G

:end
