#  $Id: dst.pl 0.04 2000/03/24 00:00:04 tom Exp $
#
#  dst.pl:  Processes ZONEINFO files and converts any dates to the Gcal
#             fixed date format, at which Daylight-Saving Times take place.
#
#  Any but default configuration could confuse this script.
#  It comes along with a UN*X script `dst' which supports the correct usage.
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
# Initialization statements.
#
$[ = 1;			# set array base to 1
#
# Define the field separator used (BLANK actually).
#
$FS = ' ';		# set field separator
#
# Define the default return value of this process, which is EXIT_FAILURE.
#
$EXIT_SUCCESS = 0;
$EXIT_FAILURE = 1;
$EXIT_FATAL = 2;
#
$exit_status = $EXIT_FAILURE;
#
# Define some more constant values.
#
$counter = 0;
$dst2nor = 0;
$is_first = 0;
$do_print = 0;
$dst_text = 'Daylight-Saving Time';
#
$warn_before = 0;
$warn_after = 0;
#
# Get possibly given command line arguments.
#
for ($i = 1; $i < ($#ARGV+1); $i++) {
    if (substr($ARGV[$i], 1, 1) eq '-') {
	if (substr($ARGV[$i], 2, 1) eq 'b') {
	    $warn_before = substr($ARGV[$i], 3, 999999);
	}
	elsif (substr($ARGV[$i], 2, 1) eq 'a') {
	    $warn_after = substr($ARGV[$i], 3, 999999);
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
    @Fld = split(/[$FS]+/, $_, 9999);
    #
    # Initialization statements.
    #
    $act_loc_wd = $Fld[9];
    $act_loc_mo = $Fld[10];
    $act_loc_da = $Fld[11];
    $act_loc_ti = $Fld[12];
    $act_loc_ye = $Fld[13];
    $act_loc_tz = $Fld[14];
    $act_loc_ds = $Fld[15];
    #
    if (substr($act_loc_ds, length($act_loc_ds), 1) eq '1') {
	$is_dst = 1;
    }
    else {
	$is_dst = 0;
    }
    if ($counter % 3) {
	$counter = 0;
	if ($is_dst == 1) {
	    $do_print = 1;
	    $result = &incr_time($pre_loc_wd, $pre_loc_da, $pre_loc_mo, $pre_loc_ye, $pre_loc_ti);
	}
	elsif ($dst2nor == 1) {
	    $do_print = 1;
	}
    }
    else {
	$counter++;
	if ($is_dst == 1) {
	    $dst2nor = 1;
	    $result = &incr_time($act_loc_wd, $act_loc_da, $act_loc_mo, $act_loc_ye, $act_loc_ti);
	}
    }
    if ($do_print == 1) {
	$do_print = 0;
	$dst2nor = 0;
	$i = 1;
	#
	$the_year = '';
	for (;;) {
	    $ch = substr($result, $i++, 1);
	    if ($ch eq $FS) {
		last;
	    }
	    $the_year = $the_year . $ch;
	}
	#
	$the_month = '';
	for (;;) {
	    $ch = substr($result, $i++, 1);
	    if ($ch eq $FS) {
		last;
	    }
	    $the_month = $the_month . $ch;
	}
	#
	$the_day = '';
	for (;;) {
	    $ch = substr($result, $i++, 1);
	    if ($ch eq $FS) {
		last;
	    }
	    $the_day = $the_day . $ch;
	}
	#
	$the_wd = '';
	for (;;) {
	    $ch = substr($result, $i++, 1);
	    if ($ch eq $FS) {
		last;
	    }
	    $the_wd = $the_wd . $ch;
	}
	#
	$the_hour = '';
	for (;;) {
	    $ch = substr($result, $i++, 1);
	    if ($ch eq $FS) {
		last;
	    }
	    $the_hour = $the_hour . $ch;
	}
	#
	$the_min = '';
	for (;;) {
	    $ch = substr($result, $i++, 1);
	    if ($ch eq $FS) {
		last;
	    }
	    $the_min = $the_min . $ch;
	}
	#
	$the_sec = substr($result, $i, 999999);
	#
	if ($is_first == 0) {
	    $is_first = 1;
	    #
	    # Set the return value of this process to EXIT_SUCCESS.
	    #
	    $exit_status = $EXIT_SUCCESS;
	    #
	    printf ";\n; `%s.rc' ---Daylight-Saving Times--- for Gcal-2.20 or newer\n;\n\$t=%s",
		$Fld[1], $dst_text;
	}
	printf "\n;\nd=%02d%d\n", $the_month, $the_day;
	if (($warn_before == 0) && ($warn_after == 0)) {
	    printf "%04d\@d-%d#+%d \$t (%s->%s) %02d:%02d:%02d->%s",
		$the_year, $warn_before, $warn_after, $pre_loc_tz,
		$act_loc_tz, $the_hour, $the_min, $the_sec, $act_loc_ti;
	}
	else {
	    printf "%04d\@d-%d#+%d %s, \$t (%s->%s) %02d:%02d:%02d->%s",
		$the_year, $warn_before, $warn_after, $the_wd, $pre_loc_tz,
		$act_loc_tz, $the_hour, $the_min, $the_sec, $act_loc_ti;
	}
    }
    #
    $pre_loc_wd = $act_loc_wd;
    $pre_loc_mo = $act_loc_mo;
    $pre_loc_da = $act_loc_da;
    $pre_loc_ti = $act_loc_ti;
    $pre_loc_ye = $act_loc_ye;
    $pre_loc_tz = $act_loc_tz;
}
if ($exit_status == $EXIT_SUCCESS) {
    printf "\n";
}
exit $exit_status;

#
# Function implementations.
#
sub is_leap {
    local($year) = @_;
    if (($year % 4) || (!($year % 100) && ($year % 400))) {
	return 0;
    }
    1;
}
#
sub month_number {
    local($month_name) = @_;
    if ($month_name eq 'Jan') {
	return 1;
    }
    if ($month_name eq 'Feb') {
	return 2;
    }
    if ($month_name eq 'Mar') {
	return 3;
    }
    if ($month_name eq 'Apr') {
	return 4;
    }
    if ($month_name eq 'May') {
	return 5;
    }
    if ($month_name eq 'Jun') {
	return 6;
    }
    if ($month_name eq 'Jul') {
	return 7;
    }
    if ($month_name eq 'Aug') {
	return 8;
    }
    if ($month_name eq 'Sep') {
	return 9;
    }
    if ($month_name eq 'Oct') {
	return 10;
    }
    if ($month_name eq 'Nov') {
	return 11;
    }
    if ($month_name eq 'Dec') {
	return 12;
    }
    0;
}
#
sub incr_wd {
    local($wd) = @_;
    if ($wd eq 'Mon') {
	return 'Tue';
    }
    if ($wd eq 'Tue') {
	return 'Wed';
    }
    if ($wd eq 'Wed') {
	return 'Thu';
    }
    if ($wd eq 'Thu') {
	return 'Fri';
    }
    if ($wd eq 'Fri') {
	return 'Sat';
    }
    if ($wd eq 'Sat') {
	return 'Sun';
    }
    if ($wd eq 'Sun') {
	return 'Mon';
    }
    'ERR';
}
#
sub incr_time {
    local($wd, $day, $month, $year, $Time) = @_;
    $old_day = $day;
    $mo = &month_number($month);
    $hr = substr($Time, 1, 2);
    $mi = substr($Time, 4, 2);
    $se = substr($Time, 7, 2);
    $se++;
    if ($se > 59) {
	$se = 0;
	$mi++;
    }
    if ($mi > 59) {
	$mi = 0;
	$hr++;
    }
    if ($hr > 23) {
	$hr = 0;
	$day++;
	if (($day > 31) && ($mo == 1 || $mo == 3 || $mo == 5 || $mo == 7 || $mo == 8 || $mo == 10 || $mo == 12)) {
	    $day = 1;
	    $mo++;
	}
	elsif (($day > 30) && ($mo == 4 || $mo == 6 || $mo == 9 || $mo == 11)) {
	    $day = 1;
	    $mo++;
	}
	elsif (($day > 28) && ($mo == 2)) {
	    if ((&is_leap($year) == 0) && ($day >= 29)) {
		$day = 1;
		$mo++;
	    }
	    elsif ($day > 29) {
		$day = 1;
		$mo++;
	    }
	}
	if ($mo > 12) {
	    $mo = 1;
	    $year++;
	}
    }
    if ($old_day ne $day) {
	$wd = &incr_wd($wd);
    }
    $year . $FS . $mo . $FS . $day . $FS . $wd . $FS . $hr . $FS . $mi . $FS .  $se;
}
