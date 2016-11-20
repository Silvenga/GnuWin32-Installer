:: -------------------------------------------------------------------
:: 
:: update-links.bat -- Delete orphaned links and create new ones.
::
:: 
:: authors: Mathias Michaelis <michaelis@tcnet.ch>
::          Jay Satiro <raysatiro@users.sourceforge.net>
:: date   : November 15, 2009
:: version: 0.6.3
::
:: Copyright (c) 2009 by Mathias Michaelis <michaelis@tcnet.ch>
:: Copyright (c) 2009 by Jay Satiro <raysatiro@users.sourceforge.net>
::
:: -------------------------------------------------------------------
::
:: Permission is granted to copy, distribute and/or modify this document
:: under the terms of the GNU Free Documentation License, Version 1.2
:: or any later version published by the Free Software Foundation;
:: with no Invariant Sections, no Front-Cover Texts, and no Back-Cover
:: Texts.  A copy of the license is included in the file LICENSE.TXT
::
::
:: Acknowledgments
:: ---------------
::
:: See file README.TXT in this directory. Thanks to all who advised me,
:: gave me some hints, sent me some patches or encouraged me to go on!
::
@echo off
setlocal ENABLEEXTENSIONS
set PATH=%CD%\bin;%PATH%

::
:: Warn about taking a long time
::
echo Updating documentation links!
echo Status: Please wait. This may take a long time ...
echo         When the process is completed, 'Status: Complete.' will be displayed.

::
:: Searching for orphaned links (only for the first time)
::
if not exist bin\ls.exe goto delete_orphan_links_slow
if not exist bin\sed.exe goto delete_orphan_links_slow
if exist "update-links.txt" goto delete_orphan_links_fast

echo Status: Searching for orphan links ...
bin\ls -lgGRU | bin\sed -T -n "/:$/{s//\//;h};/l[^ ]* \+[^ ]\+ \+[^ ]\+ [^ ]\+ \+[^ ]\+ \+\([^ ]\+\) -> \(.*\)/{s//\1 -> \2/;G;s/\([^\n]*\)\n\(.*\)/\2\1/;s/\//\\/g;p}" >update-links.tmp
bin\sed -T -n "s/\(\.\\\)\?\(.*\) -> [A-Za-z]:\\Program Files\\[^\]\+\\\(.*\)/\2 -> \3/p;s/\(\.\\\)\?\(.*\) -> .*\\[g]nuwin32\\\(.*\)/\2 -> \3/p" update-links.tmp >update-links.txt

::
:: Delete orphan links (fast)
::
:delete_orphan_links_fast
echo Status: Deleting orphaned links ...
bin\sed -T -n "s/\(.*\) -> .*/if exist \d034\1\d034 del \/f \d034\1\d034/p" update-links.txt >tidy_links.bat
call tidy_links.bat
del tidy_links.bat
goto recreate_links

::
:: Delete orphan links (slow, because lnk-files must be searched)
::
:delete_orphan_links_slow
echo Status: Deleting orphaned links ...
echo orphan >bin\orphan.lnk
del /F /S /Q *.lnk >nul

::
:: Create new shortcuts
::
:recreate_links
echo Status: Creating new shortcuts ...
if not exist "update-links.txt" goto recreate_links_adhoc
bin\sed -T -n "s/\(.*\)\.\(dll\|exe\)\.lnk -> \(.*\)/if exist \d034\3\d034 if not exist \d034\1\.\2\d034 copy \d034\3\d034 \d034\1\.\2\d034 \d062nul/p" update-links.txt >tidy_links.bat
call tidy_links.bat
del tidy_links.bat
if not exist "bin\mkshortcut.exe" goto mkshortcut_not_existing

sed -n "s/\(.*\\\([^\]\+\)\)\.lnk -> \(.*\)/if exist \d034\3\d034 if not exist \d034\1\d034 bin\\mkshortcut -d \d034\2\d034 -n \d034\1.lnk\d034 \d034\3\d034/p" update-links.txt >tidy_links.bat
call tidy_links.bat
del tidy_links.bat
goto create_start_menu

:recreate_links_adhoc
if exist "bin\popt1.dll" if not exist "bin\popt.dll" copy "bin\popt1.dll" "bin\popt.dll" >nul
if exist "bin\gawk.exe" if not exist "bin\awk.exe" copy "bin\gawk.exe" "bin\awk.exe" >nul
if exist "bin\ed.exe" if not exist "bin\red.exe" copy "bin\ed.exe" "bin\red.exe" >nul
if exist "bin\libintl3.dll" if not exist "bin\libintl.dll" copy "bin\libintl3.dll" "bin\libintl.dll" >nul
if not exist "bin\mkshortcut.exe" goto mkshortcut_not_existing

if exist "man\cat3\dither.3.txt" bin\mkshortcut -d bwdithermap.3.txt -n "man\cat3\bwdithermap.3.txt.lnk" "man\cat3\dither.3.txt"
if exist "man\cat3\gettext.3.txt" bin\mkshortcut -d dcgettext.3.txt -n "man\cat3\dcgettext.3.txt.lnk" "man\cat3\gettext.3.txt"
if exist "man\cat3\ngettext.3.txt" bin\mkshortcut -d dcngettext.3.txt -n "man\cat3\dcngettext.3.txt.lnk" "man\cat3\ngettext.3.txt"
if exist "man\cat3\gettext.3.txt" bin\mkshortcut -d dgettext.3.txt -n "man\cat3\dgettext.3.txt.lnk" "man\cat3\gettext.3.txt"
if exist "man\cat3\dither.3.txt" bin\mkshortcut -d ditherbw.3.txt -n "man\cat3\ditherbw.3.txt.lnk" "man\cat3\dither.3.txt"
if exist "man\cat3\dither.3.txt" bin\mkshortcut -d dithergb.3.txt -n "man\cat3\dithergb.3.txt.lnk" "man\cat3\dither.3.txt"
if exist "man\cat3\dither.3.txt" bin\mkshortcut -d dithermap.3.txt -n "man\cat3\dithermap.3.txt.lnk" "man\cat3\dither.3.txt"
if exist "man\cat3\ngettext.3.txt" bin\mkshortcut -d dngettext.3.txt -n "man\cat3\dngettext.3.txt.lnk" "man\cat3\ngettext.3.txt"
if exist "man\cat3\isinf.3.txt" bin\mkshortcut -d finite.3.txt -n "man\cat3\finite.3.txt.lnk" "man\cat3\isinf.3.txt"
if exist "man\cat3\wprintf.3.txt" bin\mkshortcut -d fwprintf.3.txt -n "man\cat3\fwprintf.3.txt.lnk" "man\cat3\wprintf.3.txt"
if exist "man\cat3\hilbert.3.txt" bin\mkshortcut -d hilbert_c2i.3.txt -n "man\cat3\hilbert_c2i.3.txt.lnk" "man\cat3\hilbert.3.txt"
if exist "man\cat3\hilbert.3.txt" bin\mkshortcut -d hilbert_i2c.3.txt -n "man\cat3\hilbert_i2c.3.txt.lnk" "man\cat3\hilbert.3.txt"
if exist "man\cat3\isinf.3.txt" bin\mkshortcut -d isnan.3.txt -n "man\cat3\isnan.3.txt.lnk" "man\cat3\isinf.3.txt"
if exist "man\cat3\j0.3.txt" bin\mkshortcut -d j1.3.txt -n "man\cat3\j1.3.txt.lnk" "man\cat3\j0.3.txt"
if exist "man\cat3\j0.3.txt" bin\mkshortcut -d jn.3.txt -n "man\cat3\jn.3.txt.lnk" "man\cat3\j0.3.txt"
if exist "man\cat3\dither.3.txt" bin\mkshortcut -d make_square.3.txt -n "man\cat3\make_square.3.txt.lnk" "man\cat3\dither.3.txt"
if exist "man\cat3\rle_get_set.3.txt" bin\mkshortcut -d rle_debug.3.txt -n "man\cat3\rle_debug.3.txt.lnk" "man\cat3\rle_get_set.3.txt"
if exist "man\cat3\rle_putcom.3.txt" bin\mkshortcut -d rle_delcom.3.txt -n "man\cat3\rle_delcom.3.txt.lnk" "man\cat3\rle_putcom.3.txt"
if exist "man\cat3\rle_getraw.3.txt" bin\mkshortcut -d rle_freeraw.3.txt -n "man\cat3\rle_freeraw.3.txt.lnk" "man\cat3\rle_getraw.3.txt"
if exist "man\cat3\rle_get_set.3.txt" bin\mkshortcut -d rle_get_error.3.txt -n "man\cat3\rle_get_error.3.txt.lnk" "man\cat3\rle_get_set.3.txt"
if exist "man\cat3\rle_get_set.3.txt" bin\mkshortcut -d rle_get_setup.3.txt -n "man\cat3\rle_get_setup.3.txt.lnk" "man\cat3\rle_get_set.3.txt"
if exist "man\cat3\rle_get_set.3.txt" bin\mkshortcut -d rle_get_setup_ok.3.txt -n "man\cat3\rle_get_setup_ok.3.txt.lnk" "man\cat3\rle_get_set.3.txt"
if exist "man\cat3\rle_putcom.3.txt" bin\mkshortcut -d rle_getcom.3.txt -n "man\cat3\rle_getcom.3.txt.lnk" "man\cat3\rle_putcom.3.txt"
if exist "man\cat3\rle_open_f.3.txt" bin\mkshortcut -d rle_open_f_noexit.3.txt -n "man\cat3\rle_open_f_noexit.3.txt.lnk" "man\cat3\rle_open_f.3.txt"
if exist "man\cat3\rle_put_init.3.txt" bin\mkshortcut -d rle_put_setup.3.txt -n "man\cat3\rle_put_setup.3.txt.lnk" "man\cat3\rle_put_init.3.txt"
if exist "man\cat3\rle_raw_free.3.txt" bin\mkshortcut -d rle_raw_alloc.3.txt -n "man\cat3\rle_raw_alloc.3.txt.lnk" "man\cat3\rle_raw_free.3.txt"
if exist "man\cat3\rle_row_free.3.txt" bin\mkshortcut -d rle_row_alloc.3.txt -n "man\cat3\rle_row_alloc.3.txt.lnk" "man\cat3\rle_row_free.3.txt"
if exist "man\cat3\wprintf.3.txt" bin\mkshortcut -d swprintf.3.txt -n "man\cat3\swprintf.3.txt.lnk" "man\cat3\wprintf.3.txt"
if exist "man\cat3\compface.3.txt" bin\mkshortcut -d uncompface.3.txt -n "man\cat3\uncompface.3.txt.lnk" "man\cat3\compface.3.txt"
if exist "man\cat3\wprintf.3.txt" bin\mkshortcut -d vfwprintf.3.txt -n "man\cat3\vfwprintf.3.txt.lnk" "man\cat3\wprintf.3.txt"
if exist "man\cat3\wprintf.3.txt" bin\mkshortcut -d vswprintf.3.txt -n "man\cat3\vswprintf.3.txt.lnk" "man\cat3\wprintf.3.txt"
if exist "man\cat3\wprintf.3.txt" bin\mkshortcut -d vwprintf.3.txt -n "man\cat3\vwprintf.3.txt.lnk" "man\cat3\wprintf.3.txt"
if exist "man\cat1\bzdiff.1.txt" bin\mkshortcut -d bzcmp.1.txt -n "man\cat1\bzcmp.1.txt.lnk" "man\cat1\bzdiff.1.txt"
if exist "man\cat1\bzgrep.1.txt" bin\mkshortcut -d bzegrep.1.txt -n "man\cat1\bzegrep.1.txt.lnk" "man\cat1\bzgrep.1.txt"
if exist "man\cat1\bzgrep.1.txt" bin\mkshortcut -d bzfgrep.1.txt -n "man\cat1\bzfgrep.1.txt.lnk" "man\cat1\bzgrep.1.txt"
if exist "man\cat1\bzmore.1.txt" bin\mkshortcut -d bzless.1.txt -n "man\cat1\bzless.1.txt.lnk" "man\cat1\bzmore.1.txt"
if exist "man\cat1\gzip.1.txt" bin\mkshortcut -d gunzip.1.txt -n "man\cat1\gunzip.1.txt.lnk" "man\cat1\gzip.1.txt"
if exist "man\cat1\lesspipe.1.txt" bin\mkshortcut -d lessfile.1.txt -n "man\cat1\lessfile.1.txt.lnk" "man\cat1\lesspipe.1.txt"
if exist "man\cat1\compface.1.txt" bin\mkshortcut -d uncompface.1.txt -n "man\cat1\uncompface.1.txt.lnk" "man\cat1\compface.1.txt"
if exist "man\cat1\gzip.1.txt" bin\mkshortcut -d zcat.1.txt -n "man\cat1\zcat.1.txt.lnk" "man\cat1\gzip.1.txt"
if exist "man\cat1\zdiff.1.txt" bin\mkshortcut -d zcmp.1.txt -n "man\cat1\zcmp.1.txt.lnk" "man\cat1\zdiff.1.txt"
goto create_start_menu

::
:: If mkshortcut doesn't exist, report it.
::
:mkshortcut_not_existing
echo Status: Warning! mkshortcut.exe doesn't exist. Too bad, because it is needed
echo         to recreate the above deleted shortcuts and most of all to create a
echo         reasonable start menu. If you don't need that, all is ok. Else please
echo         download and install the cygutils packages.
goto bye

::
:: Creating start menu entries.
::
:create_start_menu
echo Status: Creating/Maintaining Start menu entries ...
if not exist "Start Menu" mkdir "Start Menu"
if not exist "Start Menu\doc" mkdir "Start Menu\doc"
if not exist "Start Menu\man" mkdir "Start Menu\man"
if not exist "Start Menu\chm" mkdir "Start Menu\chm"
if not exist "Start Menu\hlp" mkdir "Start Menu\hlp"

::
:: Link to start a cmd shell with proper environment set
::
if not exist "bin\set_gnuwin32.bat" goto test_if_links_exist

bin\mkshortcut -a "/K """"""%CD%\bin\set_gnuwin32.bat""" -s gnuwin32 -l EN"""" -i "%CD%\gnuwin32.ico" -d "Environment for gnuwin32 tools" -w "%CD:*:=%" -n "Start Menu\gnuwin32.lnk" "%comspec:*:=%"
if not exist bin\sed.exe goto test_if_links_exist

bin\sed.exe -T "s/set GNUWIN32=.*/set GNUWIN32=%CD:\=\\%/g" bin\set_gnuwin32.bat >bin\set_gnuwin32.tmp
del bin\set_gnuwin32.bat
ren bin\set_gnuwin32.tmp set_gnuwin32.bat

::
:: Test if the shortcuts are created already by update-links.txt
::
:test_if_links_exist
if not exist update-links.tmp goto bye
del update-links.tmp

:: 
:: Links to PDFs
::
echo Status: Creating links to PDFs ...
for /r doc %%a in (*.pdf) do (
	bin\mkshortcut -d "%%~na" -n "Start Menu\doc\%%~na.lnk" "%%~pnxa"
	if exist update-links.txt echo Start Menu\doc\%%~na.lnk -^> %%~dpnxa >> update-links.tmp
)

::
:: Links to man pages (PDFs).
::
echo Status: Creating links to man pages (.pdf) ...
for /r man\pdf %%a in (*.pdf) do (
	bin\mkshortcut -d "%%~na" -n "Start Menu\man\%%~na.lnk" "%%~pnxa"
	if exist update-links.txt echo Start Menu\man\%%~na.lnk -^> %%~dpnxa >> update-links.tmp
)

::
:: Links to chm (Compiled HTML) files.
::
echo Status: Creating links to HTML Help (.chm) files ...
for /r doc %%a in (*.chm) do (
	bin\mkshortcut -d "%%~na" -n "Start Menu\chm\%%~na.lnk" "%%~pnxa"
	if exist update-links.txt echo Start Menu\chm\%%~na.lnk -^> %%~dpnxa >> update-links.tmp
)

::
:: Links to hlp (Windows Help) files.
::
echo Status: Creating links to Windows Help (.hlp) files ...
for /r doc %%a in (*.hlp) do (
	bin\mkshortcut -d "%%~na" -n "Start Menu\hlp\%%~na.lnk" "%%~pnxa"
	if exist update-links.txt echo Start Menu\hlp\%%~na.lnk -^> %%~dpnxa >> update-links.tmp
)

::
:: Actualise the protocoll.
::
if not exist bin\sed.exe goto bye
rem bin\sed -T -n "s/\(\.\\\)\?\(.*\) -> .*\\[g]nuwin32\\\(.*\)/\2 -> \3/p" update-links.tmp >>update-links.txt
bin\sed -T -n "s/\(\.\\\)\?\(.*\) -> %CD:\=\\%\\\(.*\)/\2 -> \3/p" update-links.tmp >>update-links.txt

::
:: Tidy up
::
:bye
if exist update-links.tmp del update-links.tmp
echo Status: Complete.
echo.
echo The 'Start Menu' folder has been created in your installation directory.
echo This folder contains all links to documentation.
echo.
echo If you move your installation folder, please run the update-links.bat
echo ^*in your installation directory^* to refresh your documentation links.
echo.
echo Ending documentation link updater.
endlocal
