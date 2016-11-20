#  $Id: ddiffdrv.pl 0.04 2000/01/12 00:00:04 tom Exp $
#
#  ddiffdrv.pl:  Processes the ZONE file `zone.tab' and creates
#                  Gcal location response files.
#
#  Any but default configuration could confuse this script.
#  It comes along with a UN*X script `ddiffdrv' and a DOS batch `ddiffdrv.bat'
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
	elsif (substr($ARGV[$i], 2, 1) eq 'c') {
	    $c = substr($ARGV[$i], 3, 999999);
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
printf "; %s, location names and coordinates for Gcal-2.20 or newer\n;\n", $b;
printf "; The line template.\n;\n";
if ($a == 0) {
    printf "\$x=0 %s: Gcal location response file `\$<1l*l' created...%%!echo -r'\\\$c=\$c:\\\$l=\$l' > \$<1l*l\n", $c;
}
else {
    printf "\$x=0 %s: Gcal location response file `\$<8l#l' created...%%!echo -r\\\$c=\$c:\\\$l=\$l> \$<8l#l\n", $c;
}
printf ";\n; The locations.\n";

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
	$loc = '';
	$len = length($location);
	for ($i = 1; $i <= $len; $i++) {
	    if (substr($location, $i, 1) eq '_') {
		$loc = $loc . "\\";
	    }
	    $loc = $loc . substr($location, $i, 1);
	}
	printf ";\n; Location %s, %s\n;\n\$l=%s-%s\n\$c=%s\n\$x\n",
	    $location, $Fld[1], $Fld[1], $loc, $Fld[2];
    }
}

exit $EXIT_SUCCESS;
