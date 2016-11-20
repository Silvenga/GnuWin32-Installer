#  $Id: wlocdrv1.pl 0.06 2000/03/23 00:00:06 tom Exp $
#
#  wlocdrv1.pl:  Generates the `wloc' script text necessary to create
#                  all location files which contain air line distances
#                  and course angles between several geographic locations
#                  around the world, by processing the ZONE file `zone.tab'.
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
	    $shell = substr($ARGV[$i], 3, 999999);
	}
	elsif (substr($ARGV[$i], 2, 1) eq 'b') {
	    $gcalresource = substr($ARGV[$i], 3, 999999);
	}
	elsif (substr($ARGV[$i], 2, 1) eq 'c') {
	    $gcalprogram = substr($ARGV[$i], 3, 999999);
	}
	elsif (substr($ARGV[$i], 2, 1) eq 'd') {
	    $precise = substr($ARGV[$i], 3, 999999);
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
if ($shell == 1) {
    $rem = '#';
    $header = '#! /bin/sh';
}
else {
    $rem = '::';
    $header = '@echo off';
}
printf "%s\n%s\n", $header, $rem;
printf "%s Air line distances between geographical locations for Gcal-2.20 or newer\n",
	$rem;

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
		if ($a == 0) {
		    $loc = $loc . "\\";
		}
	    }
	    $loc = $loc . substr($location, $i, 1);
	}
	$cc = $Fld[1];
	printf "%s\n%s Location %s, %s\n%s\n",
	    $rem, $rem, $location, $cc, $rem;
	$outname = lc($cc) . '-';
	$len = length($loc);
	for ($i = 1; $i <= $len; $i++) {
	    $chr = lc(substr($loc, $i, 1));
	    if ($chr eq "\\") {
		$outname = $outname . '_';
		if ($shell == 1) {
		    $i++;
		}
	    }
	    else {
		$outname = $outname . $chr;
	    }
	}
	if ($shell == 1) {
	    printf "echo \"%s: creating the air line distance file \\`%s', please wait...\"\n",
		$gcalprogram, $outname;
	    printf "%s %s -QUx -Hno -f%s -r\\\$a=%s-%s:\\\$b=%s > %s\n",
		$gcalprogram, $precise, $gcalresource, $cc, $loc, $Fld[2], $outname;
	}
	else {
	    $outname = substr($outname, 1, 8);
	    printf "echo %s: creating the air line distance file `%s', please wait...\n",
		$gcalprogram, $outname;
	    printf "%s %s -QUx -Hno -f%s -r\$a=%s-%s:\$b=%s> %s\n",
		$gcalprogram, $precise, $gcalresource, $cc, $loc, $Fld[2], $outname;
	}
    }
}

exit $EXIT_SUCCESS;
