#  $Id: ct2gcal.pl 0.21 2000/06/14 00:02:01 tom Exp $
#
#  ct2gcal.pl:  Very simple, slow and silly Perl script for converting
#                 "[X]Calentool-2.3" appointments into the `gcal' format.
#
#
#  Copyright (c) 1994, 95, 1996, 2000  Thomas Esken      <esken@gmx.net>
#                                      Im Hagenfeld 84
#                                      D-48147 M"unster
#                                      GERMANY
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
$, = ' ';		# set output field separator
$\ = "\n";		# set output record separator

#
# Define the field separator used (blank actually).
#
$FS = ' ';
#
# Define the length of the text displayed on a line.
#   This is a minimum value suggesting where the first position of a
#   break can take place.  If this happens within a word, the break
#   is done at its end.
#   Set `$linebreak' to 0 if you don't want to break the text explicitly
#   (this is the same mode which was done by former versions of this script).
#
$linebreak = 0;
#
# Print some leading comment text
#
print '; ct2gcal.pl output for Gcal-2.20 or newer';
print ';';
print '; Absolutely NO warrenty!';
print ';';
print ';';
#
# Maximum length of a gcal year yyyy (actually 4 places), month `mm',
#   day `dd' and `n' field.
#
$ylen = 4;
$mlen = 2;
$dlen = 2;
$nlen = 1;
#
# Maximum lenght of a repeated text
#   means a maximum number of repetitions of 999.
#
$rlen = 3;
#
# The newline character of a text part of a gcal resource file line.
#
$gcalnl = '~';
#
# The quote character of a text part of a gcal resource file line.
#
$gcalqt = "\\";
#
# The remark character of a text part of a gcal resource file line.
#
$gcalremark = ';';
#
# The `text' of a typical calentool appointment starts in column 19.
#
$ctcolumn = 19;
#
# The remark character sequence of a calentool appointment line.
#
$ctremark = '# ';
#
# The character sequence which indicates an eternal date field
#   of a calentool appointment line
#
$cteternal = '**';

#
# Main block.
#
while (<>) {
    chop;	# strip record separator
    @Fld = split(/[$FS\n]/, $_, 9999);

    #
    # Test if line is a comment.
    #
    if (substr($_, 1, 1) eq substr($ctremark, 1, 1)) {
	#
	# First comment char found, check whether line contains a "#include" statement.
	#
	$len = length($_);
	if ($len > 1) {
	    $ch = substr($_, 2, 1);
	}
	else {
	    $ch = '';
	}
	if ($ch eq substr($ctremark, 2, 1) || $ch eq '') {
	    print $gcalremark . $_;
	}
	else {
	    print $_;
	}
    }
    else {
	#
	# On conversion we must calculate with some displacement.
	#
	$displ = 0;
	#
	# No comment, so try to convert...
	#
	if ($_ ne '') {
	    #
	    # Test whether line contains an explictit gcal newline character ~
	    #   if it is found, quote it by the gcal quote character \
	    #   i.e. generate character sequence \~ .
	    #
	    $tmpstr = '';
	    $len = length($_);
	    for ($i = 1; $i <= $len; $i++) {
		$ch = substr($_, $i, 1);
		if ($ch eq $gcalnl) {
		    $tmpstr = $tmpstr . $gcalqt;
		}
		$tmpstr = $tmpstr . $ch;
	    }
	    $_ = $tmpstr;
	    #
	    # Add "inclusive_date" special text %iyyyy[mm[dd[n]]] (variable "idatetxt")
	    #   in case a "... yyyy)" text fragment is found in line.
	    #
	    $idatetxt = '';
	    #
	    if ($_ =~ /[0-9]+\)/) {
		#
		# Pattern found, so search all fields for information.
		#
		for ($i = 1; $i <= $#Fld; $i++) {
		    #
		    # Extract the year number.
		    #
		    if ($Fld[$i] =~ /[0-9]+\)/) {
			$len = length($Fld[$i]);
			for ($j = 1; $j <= $len; $j++) {
			    if (substr($Fld[$i], $j, 1) =~ /[0-9]/) {
				$len = $j;
			    }
			}
			$tmpstr = substr($Fld[$i], $len, length($Fld[$i]));
			#
			# Ok, lets go on...
			#
			$len = length($tmpstr);
			for ($j = 1; $j <= $len; $j++) {
			    $ch = substr($tmpstr, $j, 1);
			    if ($ch =~ /[0-9]/) {
				$idatetxt = $idatetxt . $ch;
			    }
			}
			#
			# Add leading zeroes to the year until length(year)==ylen.
			#
			$len = length($idatetxt);
			if ($len < $ylen) {
			    $tmpstr = '';
			    $len = $ylen - $len;
			    for ($j = 1; $j <= $len; $j++) {
				$tmpstr = '0' . $tmpstr;
			    }
			    $idatetxt = $tmpstr . $idatetxt;
			}
			#
			# Add month and day to "idatetxt".
			#
			if ($Fld[2] ne $cteternal) {
			    $idatetxt = $idatetxt . $Fld[2];
			    if ($Fld[3] ne $cteternal) {
				$idatetxt = $idatetxt . $Fld[3];
			    }
			}
			#
			# Cut "idatetxt" so it contains ylen+mlen+dlen characters maximum.
			#
			$len = length($idatetxt);
			if ($len > $ylen + $mlen + $dlen) {
			    $idatetxt = substr($idatetxt,
			      $len - ($ylen + $mlen + $dlen - 1),
			      $ylen + $mlen + $dlen);
			}
		    }
		}
	    }
	    #
	    # Test if line contains a textual "[number]" field which
	    #   indicates a date, that occurs at [number]'th weekday of month.
	    #
	    $ntxt = '';
	    $loopto = $#Fld;
	    #
	    if ($Fld[3] !~ /[0-9]/) {
		if ($_ =~ /\[+[012345lL]+\]/) {
		    for ($i = 1; $i <= $loopto; $i++) {
			if ($Fld[$i] =~ /\[+[012345lL]+\]/) {
			    #
			    # Pattern found, so terminate loop.
			    #
			    $loopto = $i;
			    #
			    # Extract the information.
			    #
			    $len = length($Fld[$i]);
			    for ($j = 1; $j <= $len; $j++) {
				if (substr($Fld[$i], $j, 1) =~ /[012345lL]/) {
				    $len = $j;
				}
			    }
			    $tmpstr = substr($Fld[$i], $len, length($Fld[$i]));
			    #
			    # Ok, lets go on...
			    #
			    $len = length($tmpstr);
			    for ($j = 1; $j <= $len; $j++) {
				$ch = substr($tmpstr, $j, 1);
				if ($ch =~ /[012345lL]/) {
				    $ntxt = $ntxt . $ch;
				}
			    }
			    #
			    # Cut "ntxt" so it contains "nlen" characters maximum.
			    #
			    if (length($ntxt) > $nlen) {
				$ntxt = substr($ntxt, 1, $nlen);
			    }
			    #
			    # Replace l|L(==last weekday in month) entry by a `9'.
			    #
			    if ($ntxt =~ /[lL]/) {
				$ntxt = '9';
			    }
			    #
			    # Append found number text to starting date special text.
			    #
			    if ($idatetxt ne '') {
				$idatetxt = $idatetxt . $ntxt;
			    }
			    #
			    # Eliminate the found "[number]" field.
			    #
			    $displ += (length($Fld[$i]) + 1);
			}
		    }
		}
	    }
	    #
	    # Test if line contains a textual "<number>" field and eliminate it.
	    #
	    $rtxt = '';
	    $loopto = $#Fld;
	    #
	    if ($_ =~ /<+[0-9]+>/) {
		for ($i = 1; $i <= $loopto; $i++) {
		    if ($Fld[$i] =~ /<+[0-9]+>/) {
			#
			# Pattern found, so terminate loop.
			#
			$loopto = $i;
			#
			# Extract the information.
			#
			$len = length($Fld[$i]);
			for ($j = 1; $j <= $len; $j++) {
			    if (substr($Fld[$i], $j, 1) =~ /[0-9]/) {
				$len = $j;
			    }
			}
			$tmpstr = substr($Fld[$i], $len, length($Fld[$i]));
			#
			# Ok, lets go on...
			#
			$len = length($tmpstr);
			for ($j = 1; $j <= $len; $j++) {
			    $ch = substr($tmpstr, $j, 1);
			    if ($ch =~ /[0-9]/) {
				$rtxt = $rtxt . $ch;
			    }
			}
			#
			# Cut "rtxt" so it contains "rlen" characters maximum.
			#
			if (length($rtxt) > $rlen) {
			    $rtxt = substr($rtxt, 1, $rlen);
			}
			#
			# Eliminate the information.
			#
			$displ += (length($Fld[$i]) + 1);
		    }
		}
	    }
	    #
	    # Append "idatetxt" to line.
	    #
	    if ($idatetxt eq '') {
		$line = $_;
	    }
	    else {
		$line = $_ . '%i' . $idatetxt;
	    }
	    if ($Fld[2] eq $cteternal) {
		$Fld[2] = '00';
	    }
	    if ($Fld[3] eq $cteternal) {
		$Fld[3] = '00';
	    }
	    #
	    #  Manage possible breaks in the text part of appointment.
	    #
	    if ($linebreak < 1) {
		$textpart = substr($line, $ctcolumn + $displ, 999999);
	    }
	    else {
		$tpart = substr($line, $ctcolumn + $displ, 999999);
		$len_tpart = length($tpart);
		if ($len_tpart > $linebreak) {
		    $k = 0;
		    $textpart = '';
		    for ($i = 1; $i <= $len_tpart; $i += ($linebreak + $k)) {
			$textpart = $textpart . substr($tpart, $i, $linebreak - 1);
			$j = 0;
			$k = 0;
			while (substr($tpart, $linebreak + $i + $j - 1, 1) !~ /[ \t]/) {
			    $textpart = $textpart . substr($tpart, $linebreak + $i + $j - 1, 1);
			    $j++;
			    if ($linebreak + $i + $j - 1 > $len_tpart) {
				last;
			    }
			}
			$k += $j;
			$textpart = $textpart . $gcalnl;
		    }
		}
		else {
		    $textpart = $tpart;
		}
		$i = length($textpart);
		if (substr($textpart, $i, 1) eq $gcalnl) {
		    $textpart = substr($textpart, 1, $i - 1);
		}
	    }
	    if ($rtxt ne '') {
		#
		# If "rtxt" is given, produce the line "rtxt" times using a date variable.
		#
		print 'a=' . $Fld[2] . $Fld[3] . $ntxt;
		$j = int($rtxt);
		#
		# Print line(s) only if repetition factor is 1 or more.
		#
		if ($j > 0) {
		    for ($i = 1; $i <= $j; $i++) {
			if ($Fld[1] ne $cteternal) {
			    print '19' . $Fld[1] . '@a' . ($i - 1) . ' ' . $textpart;
			}
			else {
			    print '0@a' . ($i - 1) . ' ' . $textpart;
			}
		    }
		}
	    }
	    else {
		#
		# Print the constructed line.
		#
		if ($Fld[1] ne $cteternal) {
		    print '19' . $Fld[1] . $Fld[2] . $Fld[3] . $ntxt . ' ' . $textpart;
		}
		else {
		    print '0000' . $Fld[2] . $Fld[3] . $ntxt . ' ' . $textpart;
		}
	    }
	}
    }
}
