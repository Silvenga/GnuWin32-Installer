#
# gcalltx.sed -- (C) Claus-Peter R"uckemann, 1996, 1998
#
# version 1.5
#
# This file may be distributed with gcal under the terms
# of the GNU public license.
#
# This simple sed script converts 'gcal -n -u %0001 year' output to LaTeX
# tabular output for gcal. Any but default configuration might confuse 
# this script.  It comes along with a UN*X script gcalltx and a DOS batch
# gcalltx.bat which supports the correct usage. This program has been
# tested with the German, English and French catalogs of gcal under
# Linux, IBM/AIX, SUN/Solaris and MSDOS.
# It should accept all country codes gcal uses.
#
# It is *** not *** guaranteed that this script works for any other call than
# the one given above and the ones given in the gcalltx and gcalltx.bat scripts
# but it could easily be modified and extended for using your favorite
# PostScript fonts, color, shading and multipage tabulars... under LaTeX2e.
#
# Splitting is done in both scripts before they use this program.
# If you are not satisfied with the different width of the tabulars you
# could use *-form, p-columns or/and experiment with \extracolsep.
# The "breakpoint part" has been written in a way that allows to use it nearly
# identical in the DOS *and* UN*X version (I know it could be done more elegant
# with UNIX). Comment this part in either of these versions and no splitting
# will be done. If you comment the part called "breakpoint part" in the scripts
# you could set \textheight to 28cm and \voffset to -3.0cm and change the
# normalsize font environment in here to small (center has explicitly
# been set to reduce memory usage -- page wise).
#
# If you modify this script you have to rename the modified version.
#
# Remarks:
# -- The last line of this script should only contain a space to be more
#    portable with some sed versions -- make sure not to loose it while editing.
# -- This file is 8-bit.
# -- If you extend take care in not mixing the codepages and language
#    dependend patterns too much.
# -- If you need to speed this script up you might carefully comment the
#    language dependend stuff for languages you do not need.
#
# If you make any improvements I would like to hear from you.
# But I do not promise any support.
# ruckema@uni-muenster.de
#
1i\
%%
1i\
%% gcal output converted with gcalltx & gcalltx.sed (C) CPR, 1999, v1.5
1i\
%%
1i\
\\documentstyle{article}
1i\
\\nofiles
1i\
\\textwidth=16cm\\textheight=22cm\\voffset=-0.5cm\\hoffset=-2.2cm\\parindent=0pt
1i\
\\begin{document}
1i\
\\begin{center}
1i\
\\begin{normalsize}
1i\
\\begin{tabular}{@{}p{7.4cm}cr@{~}r@{~}r@{}c@{}r@{}}
#                   ^---               ^---^---^---
#                    c-column also      no space for nice formatting of
#                    be ok.             current year *and* any year
#
# headline
#
# old style:
#s/^Eternal \(\\*.*\)$/\\hline\\multicolumn{7}{@{}c@{}}{{\\bf Eternal \1}}\\\\ \\hline/g
#s/     The year //g
# new style should be more flexible for different languages:
s/^\(\\*.*\):   \(\\*.*\)$/\\hline\\multicolumn{7}{@{}c@{}}{{\\bf \1:\\hfill\\vphantom{\\large{\\"A}\\Huge{y}} \2}}\\\\ \\hline/g
#
# example:
#                                           v--- output col44
#Eternal holiday list:                      The year 1996 is A leap year
#
#s/&/\\\&/g
# & protected by ∞-sign in order to save columnization:
s/&/∞/g
#
# for older gcal version
#s/  is \(\\*.*\),/\& is \1,\&/g
#
s/ =\(\\*.*\)$/ \& = \&\1\\\\/g
s/[Æ:]\(\\*.*\)[Ø:]/ {\\it \1} /g
s/[<]\(\\*.*\)[>]/ {\\bf \1} /g
s/ \([0-9][0-9][0-9][0-9]\)$/ \1\&\&\\\\/g
#
# used for identifying lines of tables (additional marker could be used)
#
s/^\(\\*.*\)$/\1%/g
#
# new string at left needs separation (en de etc.)
#
s/^\(.........................................\)\(.\) \(...\), \(...\) \(\\*.*\)\\\\%/\1\& $\2$ \& \3, \& \4 \5\\\\%/g
s/^\(.........................................\)\(.\) \(..\), \(....\)\(\\*.*\)\\\\%/\1\& $\2$ \& \3, \&\4\5\\\\%/g
#
# example: (shows problems with formatting for different date formats)
#                                         v--- output col42
# LANG=en
#New Year's Day (Std)                     + Mon, Jan : 1st:1996 = -296 days
#All Fool's Day (Std)                     - Mon, Apr   1st 1996 = -205 days
# LANG=de
#Neujahr (Std)                            + Mo,   1 Jan 1996 = -301 Tage
#1'ter April (Std)                        - Mo,   1 Apr 1996 = -210 Tage
# LANG=fr
#Jour de l'An (Sam)                       + Lu, : 1:Jan 1996  =  -304 jours
#FÍte des Rois (Chr)                      - Sa,   6 Jan 1996  =  -299 jours
#
# correct single days
s/day\\\\%/day\\hphantom{s}\\\\%/g
s/Tag\\\\%/Tag\\hphantom{e}\\\\%/g
s/jour\\\\%/jours\\hphantom{s}\\\\%/g
#
# month -- this part has been separated from the long patterns above because
# it can also be used to specify the complete names of the month for the
# use in the tabular.
s/ Jan / Jan \&/g
s/ Feb / Feb \&/g
s/ F\(.\)v / F\1v \&/g
#s/ Mar / Mar \&/g
s/ M\(.\)r / M\1r \&/g
s/ Apr / Apr \&/g
s/ Avr / Avr \&/g
s/ May / May \&/g
s/ Mai / Mai \&/g
s/ Jun / Jun \&/g
s/ Jui / Jui \&/g
s/ Jul / Jul \&/g
s/ Aug / Aug \&/g
s/ Ao\(.\) / Ao\1 \&/g
s/ Sep / Sep \&/g
s/ Oct / Oct \&/g
s/ Okt / Okt \&/g
s/ Nov / Nov \&/g
#s/ Dec / Dec \&/g
s/ Dez / Dez \&/g
s/ D\(.\)c / D\1c \&/g
#
# decide which one you want
#
s/*/\\ast/g
s/#/\\#/g
# or
#s/#/ /g
#s/\*/ /g
#
s/∞/\\\&/g
#
# Postprocessing of Czech `...Jan Hus...' holiday for removing an unnecessary
# tabular delimiter previously inserted in the text by reason this script
# detected `Jan' and thought it would be a month name.
#
s/[Jj][Aa][Nn] &[Hh]/Jan H/g
#
# only needed when using breakpoints for splitting
s/^\(\\*.*\)BREAKPOINT\(\\*.*\)$/\\end{tabular}~\\\\ \\begin{tabular}{@{}p{7.4cm}cr@{~}r@{~}r@{}c@{}r@{}} % BREAKPOINT at line \2/g
#
#
# This accent (\'a) in iso latin is a little beta in cp437. It is used as sz in
# Germany. We need to get sure this one to be a french accent here. Therefore
# we can use the (DE) label to correct and hope those won't get more :-)
s/^\(\\*.*\)·\(\\*.*\) (DE)/\1\\ss{}\2 (DE)/g
#
# convert umlauts and other 8 bit from iso latin
s/‰/\\"a/g
s/¸/\\"u/g
s/ˆ/\\"o/g
s/ƒ/\\"A/g
s/÷/\\"O/g
s/‹/\\"U/g
s/ﬂ/\\ss{}/g
#
s/‡/\\`a/g
s/·/\\'a/g
s/‚/\\^a/g
s/¿/\\`A/g
s/¡/\\'A/g
s/¬/\\^A/g
s/Ë/\\`e/g
s/È/\\'e/g
s/Í/\\^e/g
s/»/\\`E/g
s/…/\\'E/g
s/ /\\^E/g
s/Ï/\\`{\\i}/g
s/Ì/\\'{\\i}/g
s/Ó/\\^{\\i}/g
s/Ã/\\`I/g
s/Õ/\\'I/g
s/Œ/\\^I/g
s/Ú/\\`o/g
s/Û/\\'o/g
s/Ù/\\^o/g
s/“/\\`O/g
s/”/\\'O/g
s/‘/\\^O/g
s/˘/\\`u/g
s/˙/\\'u/g
s/˚/\\^u/g
s/Ÿ/\\`U/g
s/⁄/\\'U/g
s/€/\\^U/g
s/Î/\\"e/g
#
# convert umlauts and other 8 bit from cp437
s/Ñ/\\"a/g
s/é/\\"A/g
s/î/\\"o/g
s/ô/\\"O/g
s/Å/\\"u/g
s/ö/\\"U/g
s/·/\\ss{}/g
#
s/Ö/\\`a/g
s/†/\\'a/g
s/É/\\^a/g
#s//\\`A/g
#s//\\'A/g
#s//\\^A/g
s/ä/\\`e/g
s/Ç/\\'e/g
s/à/\\^e/g
#s//\\`E/g
s/ê/\\'E/g
#s//\\^E/g
s/ç/\\`{\\i}/g
s/°/\\'{\\i}/g
s/å/\\^{\\i}/g
#s//\\`I/g
#s//\\'I/g
#s//\\^I/g
s/ï/\\`o/g
s/¢/\\'o/g
s/ì/\\^o/g
#s//\\`O/g
#s//\\'O/g
#s//\\^O/g
s/ó/\\`u/g
s/£/\\'u/g
s/ñ/\\^u/g
#s//\\`U/g
#s//\\'U/g
#s//\\^U/g
s/ã/\\"{\\i}/g
s/â/\\"e/g
s/á/\\c{c}/g
s/Ä/\\c{C}/g
#
#
$a\
\\hline
#
#
$a\
\\multicolumn{7}{@{}l@{}}{\\small\\parbox{0.4cm}{\\centering$+$} Gesetzlicher Feiertag, der im gesamten Land g\\"ultig ist.}\\\\
$a\
\\multicolumn{7}{@{}l@{}}{\\small\\parbox{0.4cm}{~} Legal holiday which is valid in the whole country.}\\\\
$a\
\\multicolumn{7}{@{}l@{}}{\\small\\parbox{0.4cm}{\\centering$\\#$} Gesetzlicher Feiertag, der \\"uberwiegend im gesamten Land g\\"ultig ist.}\\\\
$a\
\\multicolumn{7}{@{}l@{}}{\\small\\parbox{0.4cm}{~} Legal holiday which is valid in major parts of the whole country.}\\\\
$a\
\\multicolumn{7}{@{}l@{}}{\\small\\parbox{0.4cm}{\\centering$\\ast$} Gesetzlicher Feiertag, der nicht \\"uberwiegend im gesamten Land g\\"ultig ist.}\\\\
$a\
\\multicolumn{7}{@{}l@{}}{\\small\\parbox{0.4cm}{~} Legal holiday which is valid in minor parts of the whole country.}\\\\
$a\
\\multicolumn{7}{@{}l@{}}{\\small\\parbox{0.4cm}{\\centering$-$} Sonstiger Feiertag, der nur zu Erinnerungszwecken dient.}\\\\
$a\
\\multicolumn{7}{@{}l@{}}{\\small\\parbox{0.4cm}{~} Other holiday which serves for memorial or remarking purposes only.}\\\\
#
#
$a\
\\end{tabular}
$a\
\\end{normalsize}
$a\
\\end{center}
#
#
$a\
\\end{document}
$a\
%%EOF:
