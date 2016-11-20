#! /usr/bin/perl
#
# Generated automatically from gcalltxp.in by configure.
#
eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
        if $running_under_some_shell;
#=============================================================================
#
# gcalltx.pl -- (C) Claus-Peter R"uckemann, 1996, 1998, 1999
#
# version 1.6 (superseeds previous gcalltx.sed 1.5 & gcalltx.in/sh 1.5)
#
#
# This file may be distributed with Gcal under the terms
# of the GNU public license.
#
#
# This script may be used to convert 'gcal -n -u %0001 year' output to
# LaTeX tabular output.
#
# Linux/UN*X solution.
#
# Tested on Linux (where else) 2.0.3*
# with perl 5.*, bash 2.01.0*, teTeX 0.4*, LaTeX209 and LaTeX2e.
# But others should do also.
#
#
# This simple script converts 'gcal -n -u %0001 year' output to LaTeX
# tabular/longtable output for gcal. Any but default configuration might
# confuse this script.  It has been created from a previous UN*X shell script
# and sed script. This program has been tested with the German, English and
# French catalogs of gcal under Linux, IBM/AIX, SUN/Solaris.
# (MSDOgS/Win* untested so far. Remember you need some prerequisites on
# these systems like a running perl 5.*, nl or below replacement and you
# need to modify the $gcaltmp=`...`; calls for those systems I believe.)
# It should accept all country codes gcal uses.
#
# It is *** not *** guaranteed that this script works for any other call than
# the one given above and the ones given in the -help section but it could
# easily be modified and extended for using your favorite PostScript fonts,
# color, shading, tabulars modifications ... under LaTeX2e.
#
# For LaTeX2e longtable.sty is used when using the -longtable option.
# For consistance with the older versions splitting can still be done by
# introducing BREAKPOINT marks at defined offsets into the gcal output and
# creating separate tabulars for LaTeX209.
# If you are not satisfied with the different width of the tabulars in the
# LaTeX209 version you could use *-form, p-columns or/and experiment with
# \extracolsep without using the -longtable option and LaTeX2e.
# The "breakpoint part" from the previous scripts has been reduced to a
# minimum while not having changed the concept (nl is used instead of sed =).
# Comment these parts and no splitting will be done.
# If you comment the part called "breakpoint part" in the scripts
# you could set \textheight to 28cm and \voffset to -3.0cm and change the
# normalsize font environment in here to small (center has explicitly
# been set to reduce memory usage -- page wise).
#
# If you modify this script you have to rename the modified version.
#
# Remarks:
# -- No hassling anymore with 'empty last lines in different sed versions'.
# -- This source uses 7-bit representations for 8-bit characters.
#    You can easily recognize them because they are translated into their
#    LaTeX counterpart.
# -- If you extend take care in not mixing the codepages and language
#    dependend patterns too much. (This is still valid.)
# -- This program is a lot faster than the previous sed version so you
#    should have no need anymore to commenting out language dependend stuff
#    for languages you do not need in order to increase speed :-).
#
# If you make any improvements I would like to hear from you.
# But I do not (cannot) promise any support.
# ruckema@uni-muenster.de
#
#
# ODYSSEY:
#
# 19960807 CPR version 1.0  (sed/shell script)
# 19961104 CPR version 1.1  (sed/shell script)
# 19971218 CPR version 1.2  (sed/shell script)
# 19980228 CPR version 1.2b (sed/shell script)
# 19980626 CPR version 1.5  (sed/shell script)
# 19990105 CPR version 1.6  (Perl)
#              Rewrite of gcalltx.sed (1.5) & gcalltx.in/sh (1.5) prototypes
#              (More or less a hack in order to migrate the shell script and
#              sed sources to Perl.)
#              This is going along with ;-):
#              Shell script and pattern (sed) script are *one* source now.
#              Less system calls.
#              8-bit chars are represented as nice 7-bit HEX escapes now :-).
#              Usage of tmp files is completely reduced.
#              Future extensions should be easier and more portable (I hope).
#              A lot better performance.
# 19990106 CPR -longtable
#              Added LaTeX2e longtable support.
# 19990106 CPR -miscindex
#              Added index creation.
# 19990107 CPR -makedvi
#              Added optional latex/makeindex calls..
# 19990108 CPR -longsample
#              Added list of country codes. Called it long*sample* because I
#              cannot guarantee if the list coded in here contains all of the
#              countries supported by gcal at any time.
# 19990108 CPR Added short forms for the above options (-lt -mi -md -ls)
#              in order to reduce command line size.
# 19990108 CPR Some of the LaTeX2e output has been successfully tested with
#              latex2html 98.1 without further preparation.
#              (gcalltx -longtable -miscindex DE+GB+MX+NO 1998+2001)
# 19990108 CPR -stdout
#              Added switch to direct output to STDOUT instead of a LaTeX
#              file. This might be used for further postprocessing :-).
# 19990227 tom Completed list of country codes.  Ending message suppressed
#              in case -stdout option is used.  Managed handling of a
#              transformed Gcal executable name which is other than `gcal'.
#              The new output column positions in the eternal holiday list
#              of the actual Gcal are respected now.
# 19990322 tom Managed handling of a transformed script installation name
#              other than `gcalltx.pl'.
# 19990602 tom Postprocessing of Czech `...Jan Hus...' holiday added for
#              removing an unnecessary tabular delimiter which was inserted
#              accidentially.
# 19990917 tom Removed a typo in the help screen, added $VERSION, proper
#              management of `gcal' program call, working `--help' option.
# 19991108 tom Removed the term ``standard holidays'' in all texts and added
#              more countries/territories to the `-longsample' option.
# 19991121 CPR Checked usage with the new country codes.
#              Fixed new (AN_BO) into (AN\_BO) for the LaTeX results
#              as this would cause errors LaTeX'ing.
#              Checked the examples given with the standard help (--help/-?).
#              Working with the new country codes now.
#              Puuh, these lists are comfortably huge now. =B-)
# 19991122 CPR Added rule to add those new country codes to the index.
#              Added new (Ast) (Chi) (Per) ... to the index.
#
# I might clean up the $gcaltmp and numberless print's one day.
#
#=============================================================================

##############################################################################

# Numbering lines with. (Default is GNU nl -n rz for 000001 etc.)
$appl_nl = "nl -n rz";
# In case you do not have GNU nl (number lines) take my tiny version
# suitable for working with this script. It is appended to this script.
#$appl_nl = "nlnrz.pl";
# or:
#$appl_nl = "perl pathto...nlnrz.pl";

# Take the date string.
$datenow=`date`;

# LaTeX call.
$appl_latex = "latex";

# Makeindex call.
$appl_makeindex = "makeindex";

# Basename of the LaTeX output file. (Makes $outlatex.tex and $outlatex.dvi)
$outlatex = "gcalltx";

##############################################################################

#-----------------------------------------------------------------------------

$PACKAGE   = "gcal";
$VERSION   = "3.01";
$transform = "s,$$,,; s,^,,; s/i386-pc-mingw32//";

$myname =  $0;
$myname =~ s+.*/++g;
$myname =~ $transform;$
PerlGcal="$PACKAGE"
;

if ($PerlGcal ne '../../src/gcal') {
        $PerlGcal =  $PACKAGE;
        $PerlGcal =~ $transform;
}

chop ($datenow);

#-----------------------------------------------------------------------------

#
# Handle the cmdline switches.
#

while ($ARGV[0] =~ /^-/) {
    $_ = shift;
  last if /^--/ || /^-help/ || /^-h/ || /^-\?/;
    if (/^-n/) {
        $nflag++;
        next;
    }
    #
    # some additional switches
    #
    if (/^-longsample/ || /^-ls/) {
        $typeswitch='-longsample';
        next;
    }
    if (/^-miscindex/ || /^-mi/) {
        $indexswitch='-miscindex';
        next;
    }
    if (/^-longtable/ || /^-lt/) {
        $tableswitch='-longtable';
        next;
    }
    if (/^-makedvi/ || /^-md/) {
        $actionswitch='-makedvi';
        next;
    }
    if (/^-stdout/) {
        $devswitch='-stdout';
        next;
    }
    die "I don't recognize this switch: $_\\n";
}
$printit++ unless $nflag;

#-----------------------------------------------------------------------------

if (/^--help/ || /^--hel/ || /^--he/ || /^--h/ || /^-help/ || /^-h/ || /^-\?/) {
    print "usage:   $myname [options] [country_codes] year_list [--christian-holidays]\n";
    print "options: -longtable  (-lt)  Use LaTeX2e and longtable instead of BREAKPOINTS.\n";
    print "         -miscindex  (-mi)  Create a country and holiday index.\n";
    print "         -makedvi    (-md)  Create a DVI file by latex and makeindex.\n";
    print "         -longsample (-ls)  Use a prepared long country_codes list.\n";
    print "         -stdout            Direct output to STDOUT instead into a file.\n";
    print "examples:\n";
    print "  $myname year\n";
    print "    Provides only Christian holidays.\n";
    print "  $myname country_code year\n";
    print "    Provides country_code Holidays.\n";
    print "  $myname country_code year --christian-holidays\n";
    print "    Provides Christian and country_code holidays.\n";
    print "  $myname -longsample -longtable -makedvi -miscindex FR 1999+2002\n";
    print "    Example if you have latex/makeindex/gcal in PATH.\n";
    print "    If you do not have latex/makeindex (yet) leave the -makedvi away.\n";
    print "  $myname -longsample -longtable -stdout -miscindex FR 1999+2002>myfile.tex\n";
    print "    Direct output into any other file. Also for using pipes and filters.\n";
    print "country_codes is a country code or list of country codes as supported by \`$PerlGcal'.\n";
    print "Country codes are for example: BE ES FR\n";
    print "A list of country codes can be created by: BE+FR (s. $PACKAGE-$VERSION documentation).\n";
    print "\n";
    $nflag++;
    exit;
    next;
}

#
# Number of args.
#

$ARGCOUNT=$#ARGV+1;

if ($ARGCOUNT == 0) {
}
else {


#
# What we do with the arguments:
#

  #
  #v--- -longsample
  #   
  if ($typeswitch eq '-longsample') {
    $longsamplecodes="AD+AE+AF+AG+AI+AL+AM+AN_BO+AN_CU+AN_MA+AN_SA+AO+AR+AS+AT+AU_CT+AU_NT+AU_QU+AU_SA+AU_SW+AU_TA+AU_VI+AU_WA+AW+AZ+BA+BB+BD+BE+BF+BG+BH+BI+BJ+BM+BN+BO+BR+BS+BT+BV+BW+BY+BZ+CA_AL+CA_BC+CA_MA+CA_NB+CA_NF+CA_NS+CA_NW+CA_ON+CA_PE+CA_QU+CA_SA+CA_YU+CC+CD+CF+CG+CH_AA+CH_AG+CH_AI+CH_BL+CH_BN+CH_BS+CH_FB+CH_GB+CH_GL+CH_GV+CH_JR+CH_LZ+CH_NC+CH_NW+CH_OW+CH_SG+CH_ST+CH_SW+CH_TC+CH_TG+CH_UI+CH_VD+CH_VL+CH_ZG+CH_ZR+CI+CK+CL+CM+CN+CO+CR+CU+CV+CX+CY+CZ+DE_BA+DE_BB+DE_BL+DE_BR+DE_BW+DE_HA+DE_HS+DE_MV+DE_NS+DE_NW+DE_RP+DE_SA+DE_SH+DE_SL+DE_SN+DE_TR+DJ+DK+DM+DO+DZ+EC+EE+EG+EH+ER+ES+ET+FI+FJ+FK+FM+FO+FR+GA+GB_EN+GB_NI+GB_SL+GD+GE+GF+GH+GI+GL+GM+GN+GP+GQ+GR+GS+GT+GU+GW+GY+HK+HM+HN+HR+HT+HU+ID+IE+IL+IN+IQ+IR+IS+IT+JM+JO+JP+KE+KG+KH+KI+KM+KN+KP+KR+KW+KY+KZ+LA+LB+LC+LI+LK+LR+LS+LT+LU+LV+LY+MA+MC+MD+MG+MH+MK+ML+MN+MO+MP+MQ+MR+MS+MT+MU+MV+MW+MX+MY+MZ+NA+NC+NE+NF+NG+NI+NL+NM+NO+NP+NR+NU+NZ+OM+PA+PE+PF+PG+PH+PK+PL+PM+PN+PR+PT+PW+PY+QA+RE+RO+RU+RW+SA+SB+SC+SD+SE+SG+SH+SI+SJ+SK+SL+SM+SN+SO+SR+ST+SV+SY+SZ+TC+TD+TG+TH+TJ+TK+TM+TN+TO+TR+TT+TV+TW+TZ+UA+UG+US_AK+US_AL+US_AR+US_AZ+US_CA+US_CO+US_CT+US_DC+US_DE+US_FL+US_GA+US_HI+US_IA+US_ID+US_IL+US_IN+US_KS+US_KY+US_LA+US_MA+US_MD+US_ME+US_MI+US_MN+US_MO+US_MS+US_MT+US_NC+US_ND+US_NE+US_NH+US_NJ+US_NM+US_NV+US_NY+US_OH+US_OK+US_OR+US_PA+US_RI+US_SC+US_SD+US_TN+US_TX+US_UT+US_VA+US_VT+US_WA+US_WI+US_WV+US_WY+UY+UZ+VC+VE+VG+VI+VN+VU+WF+WS+YE+YT+YU+ZA+ZM+ZW+";
    #print "debugsamplecodes: $longsamplecodes";
  }
 else {
    $longsample="";
  }
  #
  #^--- -longsample
  #

if ($ARGCOUNT == 1) {
    $gcaltmp=`$PerlGcal -n -u %0001 --christian-holidays @ARGV|$appl_nl`;
    #print "debug1 $gcaltmp";
}

if ($ARGCOUNT == 2) {
    $gcaltmp=`$PerlGcal -n -u %0001 --cc-holidays=$longsamplecodes@ARGV|$appl_nl`;
    #print "debug2 $gcaltmp";
}

if ($ARGCOUNT == 3) {
    $gcaltmp=`$PerlGcal -n -u %0001 --christian-holidays --cc-holidays=$longsamplecodes@ARGV|$appl_nl`;
    #print "debug3 $gcaltmp";
}

#-----------------------------------------------------------------------------

#
# added these lines for line numbers -> BREAKPOINT & DEL
#

  #
  #v--- -longtable
  #   
  if ($tableswitch eq '-longtable') {
  }
  #
  #^--- -longtable
  #

  else {
# v--- breakpoint part
# This is minimum now as numbers are fixed 6 digits now.
# Temporary files like for the older sed -f gcalltx.sed gcaltmp >gcalltx.tex
# are unnecessary now.
$gcaltmp =~ s/([0-9][0-9][0-9][0-9][50][0])/BREAKPOINT $1/g;
# ^--- breakpoint part
  }

#-----------------------------------------------------------------------------

#
# headline
#
# old style: (sed)
#s/^Eternal \(\\*.*\)$/\\hline\\multicolumn{7}{@{}c@{}}{{\\bf Eternal \1}}\\\\ \\hline/g
#s/     The year //g
# new style should be more flexible for different languages:
#s/^\(\\*.*\):   \(\\*.*\)$/\\hline\\multicolumn{7}{@{}c@{}}{{\\bf \1:\\hfill\\vphantom{\\large{\\"A}\\Huge{y}} \2}}\\\\ \\hline/g
$gcaltmp =~ s/(.*):   (.*)/\\hline\\multicolumn{7}{\@{}c\@{}}{{\\bf $1:\\hfill\\vphantom{\\large{\\\"A}\\Huge{y}} $2}}\\\\ \\hline/gm;

#
# example:
#                                           v--- output col44
#Eternal holiday list:                      The year 1996 is A leap year
#
#s/&/\\\&/g
# & protected by $^\circ$-sign in order to save columnization:
$gcaltmp =~ s/\&/\xB0/gm;
#
# for older gcal version
#s/  is \(\\*.*\),/\& is \1,\&/g
#
$gcaltmp =~ s/ =(.*)$/ \& = \&$1\\\\/gm;
$gcaltmp =~ s/[\xAE:](.*)[\xAF:]/ {\\it $1} /gm;
$gcaltmp =~ s/[<](.*)[>]/ {\\bf $1} /gm;
$gcaltmp =~ s/ ([0-9][0-9][0-9][0-9])$/ $1\&\&\\\\/gm;
#
# used for identifying lines of tables (additional marker could be used)
#
$gcaltmp =~ s/^(.*)$/$1%/gm;
#
# new string at left needs separation (en de etc.)
#
$gcaltmp =~ s/(.........................................)(.) (...), (...) (.*)\\\\%/$1\& \$$2\$ \& $3, \& $4 $5\\\\%/gm;
$gcaltmp =~ s/(.........................................)(.) (..), (....)(.*)\\\\%/$1\& \$$2\$ \& $3, \&$4$5\\\\%/gm;
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
#Fête des Rois (Chr)                      - Sa,   6 Jan 1996  =  -299 jours
#




#
# correct single days
#
$gcaltmp =~ s/day\\\\%/day\\hphantom{s}\\\\%/g;
$gcaltmp =~ s/Tag\\\\%/Tag\\hphantom{e}\\\\%/g;
$gcaltmp =~ s/jour\\\\%/jours\\hphantom{s}\\\\%/g;
#
# month -- this part has been separated from the long patterns above because
# it can also be used to specify the complete names of the month for the
# use in the tabular.
$gcaltmp =~ s/ Jan / Jan \&/g;
$gcaltmp =~ s/ Feb / Feb \&/g;
$gcaltmp =~ s/ F(.)v / F$1v \&/g;
#$gcaltmp =~ s/ Mar / Mar \&/g;
$gcaltmp =~ s/ M(.)r / M$1r \&/g;
$gcaltmp =~ s/ Apr / Apr \&/g;
$gcaltmp =~ s/ Avr / Avr \&/g;
$gcaltmp =~ s/ May / May \&/g;
$gcaltmp =~ s/ Mai / Mai \&/g;
$gcaltmp =~ s/ Jun / Jun \&/g;
$gcaltmp =~ s/ Jui / Jui \&/g;
$gcaltmp =~ s/ Jul / Jul \&/g;
$gcaltmp =~ s/ Aug / Aug \&/g;
$gcaltmp =~ s/ Ao(.) / Ao$1 \&/g;
$gcaltmp =~ s/ Sep / Sep \&/g;
$gcaltmp =~ s/ Oct / Oct \&/g;
$gcaltmp =~ s/ Okt / Okt \&/g;
$gcaltmp =~ s/ Nov / Nov \&/g;
#$gcaltmp =~ s/ Dec / Dec \&/g;
$gcaltmp =~ s/ Dez / Dez \&/g;
$gcaltmp =~ s/ D(.)c / D$1c \&/g;
#
# decide which one you want
#
$gcaltmp =~ s/\*/\\ast/g;
$gcaltmp =~ s/#/\\#/g;
# or
#$gcaltmp =~ s/#/ /g;
#$gcaltmp =~ s/\*/ /g;
#
$gcaltmp =~ s/\xB0/\\\&/g;
#

  #
  #v--- -longtable
  #   
  if ($tableswitch eq '-longtable') {
  }
  #
  #^--- -longtable

  else {
# only needed when using breakpoints for splitting
#$gcaltmp =~ s/^(.*)BREAKPOINT(.*)$/\\end{tabular}~\\\\ \\begin{tabular}{\@{}p{7.4cm}cr\@{~}r\@{~}r\@{}c\@{}r\@{}} % BREAKPOINT at line $2/g;
$gcaltmp =~ s/BREAKPOINT (\d\d\d\d\d\d)/\\end{tabular}~\\\\ \\begin{tabular}{\@{}p{7.4cm}cr\@{~}r\@{~}r\@{}c\@{}r\@{}} % BREAKPOINT at line $1\n$1$2/g;
  }


#
# This accent (\'a) in iso latin is a little beta in cp437. It is used as sz in
# Germany. We need to get sure this one to be a french accent here. Therefore
# we can use the (DE) label to correct and hope those won't get more :-)
$gcaltmp =~ s/^(.*)\xE1(\\*.*) (DE)/$1\\ss{}$2 (DE)/g;
#
# convert umlauts and other 8 bit from iso latin
$gcaltmp =~ s/\xE4/\\"a/g;
$gcaltmp =~ s/\xFC/\\"u/g;
$gcaltmp =~ s/\xF6/\\"o/g;
$gcaltmp =~ s/\xC4/\\"A/g;
$gcaltmp =~ s/\xD6/\\"O/g;
$gcaltmp =~ s/\xDC/\\"U/g;
$gcaltmp =~ s/\xDF/\\ss{}/g;
#
$gcaltmp =~ s/\xE0/\\`a/g;
$gcaltmp =~ s/\xE1/\\'a/g;
$gcaltmp =~ s/\xE2/\\^a/g;
$gcaltmp =~ s/\xC0/\\`A/g;
$gcaltmp =~ s/\xC1/\\'A/g;
$gcaltmp =~ s/\xC2/\\^A/g;
$gcaltmp =~ s/\xE8/\\`e/g;
$gcaltmp =~ s/\xE9/\\'e/g;
$gcaltmp =~ s/\xEA/\\^e/g;
$gcaltmp =~ s/\xC8/\\`E/g;
$gcaltmp =~ s/\xC9/\\'E/g;
$gcaltmp =~ s/\xCA/\\^E/g;
$gcaltmp =~ s/\xEC/\\`{\\i}/g;
$gcaltmp =~ s/\xED/\\'{\\i}/g;
$gcaltmp =~ s/\xEE/\\^{\\i}/g;
$gcaltmp =~ s/\xCC/\\`I/g;
$gcaltmp =~ s/\xCD/\\'I/g;
$gcaltmp =~ s/\xCE/\\^I/g;
$gcaltmp =~ s/\xF2/\\`o/g;
$gcaltmp =~ s/\xF3/\\'o/g;
$gcaltmp =~ s/\xF4/\\^o/g;
$gcaltmp =~ s/\xD2/\\`O/g;
$gcaltmp =~ s/\xD3/\\'O/g;
$gcaltmp =~ s/\xD4/\\^O/g;
$gcaltmp =~ s/\xF9/\\`u/g;
$gcaltmp =~ s/\xFA/\\'u/g;
$gcaltmp =~ s/\xFB/\\^u/g;
$gcaltmp =~ s/\xD9/\\`U/g;
$gcaltmp =~ s/\xDA/\\'U/g;
$gcaltmp =~ s/\xDB/\\^U/g;
$gcaltmp =~ s/\xEB/\\"e/g;
#
# convert umlauts and other 8 bit from cp437
$gcaltmp =~ s/\x84/\\"a/g;
$gcaltmp =~ s/\x8E/\\"A/g;
$gcaltmp =~ s/\x94/\\"o/g;
$gcaltmp =~ s/\x99/\\"O/g;
$gcaltmp =~ s/\x81/\\"u/g;
$gcaltmp =~ s/\x9A/\\"U/g;
$gcaltmp =~ s/\xE1/\\ss{}/g;
#
$gcaltmp =~ s/\x85/\\`a/g;
$gcaltmp =~ s/\xA0/\\'a/g;
$gcaltmp =~ s/\x83/\\^a/g;
#$gcaltmp =~ s//\\`A/g;
#$gcaltmp =~ s//\\'A/g;
#$gcaltmp =~ s//\\^A/g;
$gcaltmp =~ s/\x8A/\\`e/g;
$gcaltmp =~ s/\x82/\\'e/g;
$gcaltmp =~ s/\x88/\\^e/g;
#$gcaltmp =~ s//\\`E/g;
$gcaltmp =~ s/\x90/\\'E/g;
#$gcaltmp =~ s//\\^E/g;
$gcaltmp =~ s/\x8D/\\`{\\i}/g;
$gcaltmp =~ s/\xA1/\\'{\\i}/g;
$gcaltmp =~ s/\x8C/\\^{\\i}/g;
#$gcaltmp =~ s//\\`I/g;
#$gcaltmp =~ s//\\'I/g;
#$gcaltmp =~ s//\\^I/g;
$gcaltmp =~ s/\x95/\\`o/g;
$gcaltmp =~ s/\xA2/\\'o/g;
$gcaltmp =~ s/\x93/\\^o/g;
#$gcaltmp =~ s//\\`O/g;
#$gcaltmp =~ s//\\'O/g;
#$gcaltmp =~ s//\\^O/g;
$gcaltmp =~ s/\x97/\\`u/g;
$gcaltmp =~ s/\xA3/\\'u/g;
$gcaltmp =~ s/\x96/\\^u/g;
#$gcaltmp =~ s//\\`U/g;
#$gcaltmp =~ s//\\'U/g;
#$gcaltmp =~ s//\\^U/g;
$gcaltmp =~ s/\x8B/\\"{\\i}/g;
$gcaltmp =~ s/\x89/\\"e/g;
$gcaltmp =~ s/\x87/\\c{c}/g;
$gcaltmp =~ s/\x80/\\c{C}/g;
#
# Postprocessing of Czech `...Jan Hus...' holiday for removing an unnecessary
# tabular delimiter previously inserted in the text by reason this script
# detected `Jan' and thought it would be a month name.
#
$gcaltmp =~ s/[Jj][Aa][Nn] &[Hh]/Jan H/g;
#

#
# 19991121 CPR Make LaTeXable for new extended country codes:
#
$gcaltmp =~ s/([A-Z][A-Z])\_([A-Z][A-Z])/$1\\_$2/g;

#
# added these lines for line numbers -> BREAKPOINT & DEL and now for |nl
#

# v--- breakpoint part
$gcaltmp =~ s/[0-9][0-9][0-9][0-9][0-9][0-9]\t//g;
# ^--- breakpoint part

#-----------------------------------------------------------------------------

  #
  #v--- -miscindex
  #   
  if ($indexswitch eq '-miscindex') {

  #
  # do index entries *after* table has been created
  #
$gcaltmp =~ s/\(([A-Z][A-Z])\)/($1)\\index{$1}\\index{Country Code!$1}/g;
# 19991122 CPR Added DE_NW like country codes for index:
$gcaltmp =~ s/\(([A-Z][A-Z])\_([A-Z][A-Z])\)/($1)\\index{$1}\\index{Country Code!$1}/g;
$gcaltmp =~ s/\((Std)\)/($1)\\index{Std}/g;
$gcaltmp =~ s/\((Chr)\)/($1)\\index{Chr}/g;
# 19991122 CPR Added some new ones explicitly:
$gcaltmp =~ s/\((OxO)\)/($1)\\index{OxA}/g;
$gcaltmp =~ s/\((OxO)\)/($1)\\index{OxO}/g;
$gcaltmp =~ s/\((OxN)\)/($1)\\index{OxN}/g;
$gcaltmp =~ s/\((Ast)\)/($1)\\index{Ast}/g;
$gcaltmp =~ s/\((Chi)\)/($1)\\index{Chi}/g;
$gcaltmp =~ s/\((Per)\)/($1)\\index{Per}/g;
$gcaltmp =~ s/\((Heb)\)/($1)\\index{Heb}/g;
$gcaltmp =~ s/\((Isl)\)/($1)\\index{Isl}/g;
#
$gcaltmp =~ s/(.*) \(/$1\\index{$1} \(/g;
  }
  #
  #^--- -miscindex

  else {
  }

#-----------------------------------------------------------------------------

#
# Automatically add newline on print.
#

$\ = "\n";

  #
  #v--- -stdout
  #   
  if ($devswitch eq '-stdout') {
  }
  #
  #^--- -stdout

  else {
#
# Use a defined file for output.
#
open(GCALLTXOUT, ">gcalltx.tex");
select(GCALLTXOUT);
  }

#-----------------------------------------------------------------------------

#
# Output the LaTeX header.
#

print "%%";
print "%% gcal output converted with gcalltx (C) CPR, 1996, 1998, 1999 (v1.6)";
print "%% Output created: $datenow";
print "%%";

  #
  #v--- -longtable
  #   
  if ($tableswitch eq '-longtable') {
print "\\documentclass{article}";
print "\\usepackage{longtable}";
print "\\usepackage{makeidx}";
print "\\makeindex";
print "\\textwidth=16cm\\textheight=22cm\\voffset=-0.5cm\\hoffset=-2.2cm\\parindent=0pt";
print "\\begin{document}";
print "\\begin{center}";
print "\\begin{normalsize}";
print "\\begin{longtable}{\@{}p{7.4cm}cr\@{~}r\@{~}r\@{}c\@{}r\@{}}";
#                             ^----                ^----^----^----
#                             c-column also        no space for nice formatting
#                             be ok.               of current year *and* any year
  }
  #
  #^--- -longtable

  else {
print "\\documentstyle[makeidx]{article}";
#print "\\nofiles";
print "\\makeindex";
print "\\textwidth=16cm\\textheight=22cm\\voffset=-0.5cm\\hoffset=-2.2cm\\parindent=0pt";
print "\\begin{document}";
print "\\begin{center}";
print "\\begin{normalsize}";
print "\\begin{tabular}{\@{}p{7.4cm}cr\@{~}r\@{~}r\@{}c\@{}r\@{}}";
#                           ^----                ^----^----^----
#                           c-column also        no space for nice formatting
#                           be ok.               of current year *and* any year
  }

#-----------------------------------------------------------------------------

#
# Output the results.
#

print $gcaltmp;

#-----------------------------------------------------------------------------

#
# Output the LaTeX footer.
#

print "\\hline";
print "\\multicolumn{7}{\@{}l\@{}}{\\small\\parbox{0.4cm}{\\centering\$+\$} Gesetzlicher Feiertag, der im gesamten Land g\\\"ultig ist.}\\\\";
print "\\multicolumn{7}{\@{}l\@{}}{\\small\\parbox{0.4cm}{~} Legal holiday which is valid in the whole country.}\\\\";
print "\\multicolumn{7}{\@{}l\@{}}{\\small\\parbox{0.4cm}{\\centering\$\\#\$} Gesetzlicher Feiertag, der \\\"uberwiegend im gesamten Land g\\\"ultig ist.}\\\\";
print "\\multicolumn{7}{\@{}l\@{}}{\\small\\parbox{0.4cm}{~} Legal holiday which is valid in major parts of the whole country.}\\\\";
print "\\multicolumn{7}{\@{}l\@{}}{\\small\\parbox{0.4cm}{\\centering\$\\ast\$} Gesetzlicher Feiertag, der nicht \\\"uberwiegend im gesamten Land g\\\"ultig ist.}\\\\";
print "\\multicolumn{7}{\@{}l\@{}}{\\small\\parbox{0.4cm}{~} Legal holiday which is valid in minor parts of the whole country.}\\\\";
print "\\multicolumn{7}{\@{}l\@{}}{\\small\\parbox{0.4cm}{\\centering\$-\$} Sonstiger Feiertag, der nur zu Erinnerungszwecken dient.}\\\\";
print "\\multicolumn{7}{\@{}l\@{}}{\\small\\parbox{0.4cm}{~} Other holiday which serves for memorial or remarking purposes only.}\\\\";

  #
  #v--- -longtable
  #   
  if ($tableswitch eq '-longtable') {

print "\\end{longtable}";

  }
  #
  #^--- -longtable

  else {

print "\\end{tabular}";

  }

print "\\end{normalsize}";
print "\\end{center}";
print "\\printindex";
print "\\end{document}";
print "%%EOF:";

  #
  #v--- -stdout
  #   
  if ($devswitch eq '-stdout') {
  }
  #
  #^--- -stdout

  else {
close(GCALLTXOUT);
  }

} # end of if ($ARGCOUNT == 0)

#-----------------------------------------------------------------------------

#
# The end.
#
if ($ARGCOUNT == 0) {
}
else {
  if ($devswitch ne '-stdout') {
    print STDERR "$myname message: Eternal holiday list written to file $outlatex.tex";
  }
}

#-----------------------------------------------------------------------------

#
# Optionally create the DVI file.
#

  #
  #v--- -makedvi
  #   
  if ($actionswitch eq '-makedvi') {

  #
  # those should be standard links
  #
  system("$appl_latex $outlatex");
  system("$appl_makeindex $outlatex.idx");
  system("$appl_latex $outlatex");
  unlink("$outlatex.aux");
  unlink("$outlatex.log");
  unlink("$outlatex.ilg");
  unlink("$outlatex.ind");
  unlink("$outlatex.idx");
  print STDERR "$myname message: $outlatex.dvi created from $outlatex.tex";

  }
  #
  #^--- -makedvi

  else {

  }

__END__

##EOF:


As promised above here is the tiny GNU nl -n rz replacment.

#! /usr/bin/perl
#
# nlnrz.pl -- simple nl replacement -- (C) Claus-Peter R"uckemann, 1999
#
eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
    if $running_under_some_shell;
while (<>) {
    printf "%6.6d\t%s", $., $_;
}
##EOF:
