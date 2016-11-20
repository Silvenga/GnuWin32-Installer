#  $Id: srss.pl 0.06 2000/01/12 00:00:06 tom Exp $
#
#  srss.pl:  Processes the Gcal `srss.rc' resource file for displaying
#              the times at which sunrise/sunset has happened in the
#              past respectively will happen in the future, based on
#              the actual local time for several geographic locations
#              around the world.
#
#  Any but default configuration could confuse this script.
#  It comes along with a UN*X script `srss' and a DOS batch `srss.bat'
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
# Define the field separator used (SLASH actually).
#
$FS = '/';
#
# Define the default return value of this process, which is EXIT_FAILURE.
#
$EXIT_SUCCESS = 0;
$EXIT_FAILURE = 1;
$EXIT_FATAL = 2;
#
$exit_status = $EXIT_FAILURE;
#
# Define the constant values used for default operation.
#
$the_mode = 'rise';
$the_sort = 'abs';
#
# Get possibly given command line arguments.
#
for ($i = 1; $i < ($#ARGV+1); $i++) {
    if (substr($ARGV[$i], 1, 1) eq '-') {
	if (substr($ARGV[$i], 2, 1) eq 'a') {
	    $the_mode = substr($ARGV[$i], 3, 999999);
	}
	elsif (substr($ARGV[$i], 2, 1) eq 'b') {
	    $the_sort = substr($ARGV[$i], 3, 999999);
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
#
# Main block.
#
line: while (<>) {
    chop;	# strip record separator
    @Fld = split(/[$FS\n]/, $_, 9999);
    if (length($_) > 0) {
	#
	# Select the proper input field depending on the value of `the_mode'.
	#
	if ($the_mode eq 'rise') {
	    $field = $Fld[3];
	}
	else {
	    $field = $Fld[4];
	}
	#
	# Compute the actual local time `minute of day' of the location.
	#
	$min1 = substr($Fld[1], 1, 2) * 60;
	$min1 += substr($Fld[1], 4, 2);
	#
	# Compute the local time sunrise/sunset `minute of day' of the location.
	#
	$min2 = substr($field, 1, 2) * 60;
	$min2 += substr($field, 4, 2);
	#
	# Compute the time difference of both precomputed times.
	#
	$min = $min2 - $min1;
	$hour = $min / 60;
	if ($min < 0) {
	    #
	    # Sunrise/sunset has happened in the past.
	    #
	    $hour = -$hour;
	    $min = -$min;
	    $sign = '-';
	}
	else {
	    #
	    # Sunrise/sunset will happen in the future.
	    #
	    $sign = '+';
	}
	$min %= 60;
	#
	# And print the result in formatted manner.
	#
	if ($the_sort eq 'abs') {
	    printf "%s%02d:%02d@%s, LT=%s%s%02d:%02d HH:MM = sun%s at %s in %s\n",
		$sign, $hour, $min, $Fld[2], $Fld[1], $sign, $hour, $min, $the_mode, $field, $Fld[5];
	}
	else {
	    printf "%02d:%02d%s@%s, LT=%s%s%02d:%02d HH:MM = sun%s at %s in %s\n",
		$hour, $min, $sign, $Fld[2], $Fld[1], $sign, $hour, $min, $the_mode, $field, $Fld[5];
	}
	#
	# Set the return value of this process to EXIT_SUCCESS.
	#
	$exit_status = $EXIT_SUCCESS;
    }
}

exit $exit_status;
