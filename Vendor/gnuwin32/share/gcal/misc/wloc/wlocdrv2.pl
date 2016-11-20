#  $Id: wlocdrv2.pl 0.05 2000/01/12 00:00:05 tom Exp $
#
#  wlocdrv2.pl:  Generates the Gcal resource file `wlocdrv.rc' which
#                  contains air line distances and course angles between
#                  several geographic locations around the world,
#                  by processing the ZONE file `zone.tab'.
#
#  Any but default configuration could confuse this script.
#  It comes along with a UN*X script `wlocdrv' and a DOS batch `wlocdrv.bat'
#  which supports the correct usage.
#
#  It is *not* guaranteed that this script works for any other call than
#  the one given above but it could easily be modified and extended for
#  using other special modes of operation.
#
#  If you modify this script you have to rename the modified version.
#
#  If you make any improvements I would like to hear from you.
#  But I do not promise any support.
#
#  Copyright (c) 2000  Thomas Esken      <esken@uni-muenster.de>
#                      Im Hagenfeld 84
#                      D-48147 M"unster
#                      GERMANY
#
#  This software doesn't claim completeness, correctness or usability.
#  On principle I will not be liable for ANY damages or losses (implicit
#  or explicit), which result from using or handling my software.
#  If you use this software, you agree without any exception to this
#  agreement, which binds you LEGALLY !!
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the `GNU General Public License' as published by
#  the `Free Software Foundation'; either version 2, or (at your option)
#  any later version.
#
#  You should have received a copy of the `GNU General Public License'
#  along with this program; if not, write to the:
#
#    Free Software Foundation, Inc.
#    59 Temple Place - Suite 330
#    Boston, MA 02111-1307,  USA
#
#
$[ = 1;			# set array base to 1

#
# Define the default return values of this process.
#
$EXIT_SUCCESS = 0;
$EXIT_FATAL = 2;
#
# Get possibly given command line arguments.
#
for ($i = 1; $i < ($#ARGV+1); $i++) {
    if (substr($ARGV[$i], 1, 1) eq '-') {
	if (substr($ARGV[$i], 2, 1) eq 'a') {
	    $a = substr($ARGV[$i], 3, 999999);
	}
	elsif (substr($ARGV[$i], 2, 1) eq 'b') {
	    $b = substr($ARGV[$i], 3, 999999);
	}
	else {
	    exit $EXIT_FATAL;
	}
    }
    else {
	last;
    }
    shift;
    $i--;
}
printf "; %s, air line distances between geographical locations for Gcal-2.20 or newer\n;\n",
    $b;
printf "; Either set `\$f' to `%%>9*b0\$b/\$c km %%b1\$b/\$c  \$:15*c' or to\n";
printf ";   `%%>9*b*0\$b/\$c mi %%b1\$b/\$c  \$:15*c' for displaying using statute miles.\n;\n";
printf "\$f=%%>9*b0\$b/\$c km %%b1\$b/\$c  \$:15*c\n";
printf ";\$f=%%>9*b*0\$b/\$c mi %%b1\$b/\$c  \$:15*c\n";
printf ";\n; The line templates.\n;\n";
printf "\$x=0 \$a \$:15*b \$f \$l\n";
printf "0 \$a \$:15*b END~\n;\n; The locations.\n";

#
# Main block.
#
line: while (<>) {
    chop;	# strip record separator
    @Fld = split(' ', $_, 9999);

    if (substr($_, 1, 1) ne '#' && $_ ne '') {
	$location = $Fld[3];
	$len = length($location);
	for ($i = 1; $i <= $len; $i++) {
	    if (substr($location, $i, 1) eq '/') {
		$len -= $i;
		$location = substr($location, $i + 1, $len);
		$i = 1;
	    }
	}
	printf ";\n; Location %s, %s\n;\n\$l=%s-%s\n\$c=%s\n\$x\n",
	    $location, $Fld[1], $Fld[1], $location, $Fld[2];
    }
}

exit $EXIT_SUCCESS;
