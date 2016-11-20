:: -----------------------------------------------------------------
::
:: set_gnuwin32.bat: set the environment for gnuwin32 tools
::
:: author : Mathias Michaelis <michaelis@tcnet.ch>
:: date   : November 25, 2006
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
@echo off
setlocal ENABLEEXTENSIONS
if exist %TEMP%.\set_env.bat del %TEMP%.\set_env.bat

::
:: Customizations
:: --------------
::
if "%GNUWIN32%"=="" set GNUWIN32=%ProgramFiles%\gnuwin32

::
:: The Program
:: -----------
::
:: Analyse the Arguments. Unknown option simply are ignored.
::
:loop_options
if .%1.==.. goto loop_options_end
if .%1.==./u. goto option_remove_environment
if .%1.==.-u. goto option_remove_environment
if .%1.==./s. goto option_set_shell
if .%1.==.-s. goto option_set_shell
if .%1.==./l. goto option_set_language
if .%1.==.-l. goto option_set_language
if .%1.==./?. goto option_show_help
if .%1.==.-?. goto option_show_help
if .%1.==./h. goto option_show_help
if .%1.==.-h. goto option_show_help
if .%1.==.--help. goto option_show_help
shift
goto loop_options

:option_remove_environment
set do_remove_environment=yes
shift
goto loop_options

:option_set_shell
shift
if .%1.==.. goto option_unset_shell
if .%1.==./?. goto option_unset_shell
set new_shell_environment=_%~1
if "%new_shell_environment%"=="_" goto option_set_shell_succeed
if %1=="%~1" goto option_set_shell_succeed
if .%new_shell_environment:~1,1%.==./. goto option_unset_shell
if .%new_shell_environment:~1,1%.==.-. goto option_unset_shell

:option_set_shell_succeed
shift
goto loop_options

:option_unset_shell
set new_shell_environment=_
goto loop_options

:option_set_language
shift
if .%1.==.. goto option_unset_language
if .%1.==./?. goto option_unset_language
set new_language=_%~1
if "%new_language%"=="_" goto option_set_language_succeed
if %1=="%~1" goto option_set_language_succeed
if .%new_language:~1,1%.==./. goto option_unset_language
if .%new_language:~1,1%.==.-. goto option_unset_language

:option_set_language_succeed
shift
goto loop_options

:option_unset_language
set new_language=_
goto loop_options

:option_show_help
echo usage:   set_gnuwin32 [/u] [/s name] [/l language_code]
echo purpose: Sets the environment variable to access gnuwin32 tools.
echo options: /u will unset all environment variable and cancel the entry in the
echo          PATH list, except SHELL_ENVIRONMENT, LANG and LANGUAGE.
echo          /s will define the additional environment variable SHELL_ENVIRONMENT
echo          with the value 'name' and will set the window title accordingly. To
echo          delete this variable, use "" as 'name' parameter.
echo          /l will define the additional environment variables LANG and
echo          LANGUAGE with the value 'language_code'. To delete this variables,
echo          use "" as 'language_code' parameter.
goto bye

::
:: Set Window Title
::
:loop_options_end
if not defined new_shell_environment goto loop_path_init
if "%new_shell_environment%"=="_" (
	title Command Prompt
) else (
	title %new_shell_environment:~1%
)
goto loop_path_init

::
:: Initialize the loop that goes through the entries of the
:: PATH environment variable. The loop takes care that the entry to
:: the gnuwin32 environment is not listed more than once.
::
:loop_path_init
set path_new=
set path_all=%PATH:\;=;%;

:loop_path
if "%path_all%"=="" goto loop_path_end
for /f "tokens=1,2 delims=;" %%i in ("%GNUWIN32%\bin;%path_all%") do if not "%%~si"=="%%~sj" set path_new=%path_new%;%%j
set path_all=%path_all:*;=%
goto loop_path
:loop_path_end

::
:: Assign the new values to temporary environment variable
::
set path_new=%GNUWIN32%\bin%path_new%
set a2ps_config_new=%GNUWIN32%\etc\a2ps.cfg
set infopath_new=%GNUWIN32:\=/%/info
set wgetrc_new=%GNUWIN32%\etc\wgetrc

::
:: Perhaps the user wants to remove the gnuwin32 environment
::
if .%do_remove_environment%==.yes goto remove_environment
goto path_assign

:remove_environment
set path_new=%path_new:*;=%
set a2ps_config_new=
set infopath_new=
set wgetrc_new=
goto path_assign

::
:: Export the new environment out of the setlocal-endlocal-block
::
:path_assign
echo set PATH=%path_new%>%TEMP%.\set_env.bat
echo set A2PS_CONFIG=%a2ps_config_new%>>%TEMP%.\set_env.bat
echo set INFOPATH=%infopath_new%>>%TEMP%.\set_env.bat
echo set WGETRC=%wgetrc_new%>>%TEMP%.\set_env.bat

if defined new_shell_environment (
	echo set SHELL_ENVIRONMENT=%new_shell_environment:~1%>>%TEMP%.\set_env.bat
)

if defined new_language (
	echo set LANG=%new_language:~1%>>%TEMP%.\set_env.bat
	echo set LANGUAGE=%new_language:~1%>>%TEMP%.\set_env.bat
)

::
:: Leave the program
::
:bye
endlocal

::
:: Assign the exported values to the environment variables
::
if exist %TEMP%.\set_env.bat call %TEMP%.\set_env.bat
if exist %TEMP%.\set_env.bat del %TEMP%.\set_env.bat
