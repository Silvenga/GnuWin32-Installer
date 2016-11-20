#  $Id: old2v220.pl 0.05 2000/01/12 00:00:05 tom Exp $
#
#  old2v220.pl:  Very simple, slow and silly Perl script for converting
#                  resource files of former Gcal versions into the style
#                  which is used by Gcal-2.20 or newer.
#                  This means, all former `%s[DATE]' and `%e[DATE]'
#                  special texts are converted into their according
#                  `%i[STARTING_DATE][#[ENDING_DATE]]' equivalents.
#
#  *** WARNING ***
#  This script is unable to manage `%s[DATE]' and `%e[DATE]' special texts
#  correctly, if all or parts of the DATE component is/are assembled
#  by using Gcal's text variable mechanism!
#  *** WARNING ***
#
#
#  Copyright (c) 1996, 2000  Thomas Esken      <esken@uni-muenster.de>
#                            Im Hagenfeld 84
#                            D-48147 M"unster
#                            GERMANY
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

while (<>) {
    chop;	# strip record separator
    if ($. == 1) {
	#
	# Check the informational text at the beginning of a resource file.
	#   A typical text in resource files of former Gcal versions looks
	#   like "; SCRIPTNAME.SUFFIX output" for resource files already
	#   converted and installed by means of `data/Makefile' after processing
	#   of the `install' target.  Only in cases we work on such a resource
	#   file or resource files which are created manually by a user, let's
	#   convert the file, otherwise let's print it untouched (AS IS)!
	#
	$mode = 0;
	#
	# Avoid to convert resource files which are already in the Gcal-2.20 style.
	#
	if ($_ !~ / for Gcal-2.20 or newer/) {
	    $mode = 1;
	    #
	    # No Gcal-2.20 resource file, let's update the informational text.
	    #
	    if (substr($_, 1, 2) eq '; ') {
		$mode = 2;
		print $_ . ' for Gcal-2.20 or newer';
	    }
	}
    }
    #
    # Main block.
    #
    if ($mode == 1) {
	$is_s = 0;
	if ($_ =~ /[^\\]+%+[sS]/) {
	    $is_s = 1;
	}
	$is_e = 0;
	if ($_ =~ /[^\\]+%+[eE]/) {
	    $is_e = 1;
	}
	if ($is_s == 1 || $is_e == 1) {
	    #
	    # Build the line.
	    #
	    $is_both = 0;
	    if (($is_s == 1) && ($is_e == 1)) {
		$is_both = 1;
	    }
	    $line = '';
	    $s_old = '';
	    $s_filled = 0;
	    $e_old = '';
	    $e_filled = 0;
	    $len = length($_);
	    for ($i = 1; $i <= $len; $i++) {
		$ch = substr($_, $i, 1);
		if ($ch eq "\\") {
		    $line = $line . $ch;
		    if ($i < $len) {
			$i++;
			$line = $line . substr($_, $i, 1);
		    }
		}
		else {
		    if ($ch eq '%') {
			if ($is_both == 1) {
			    if (substr($_, $i + 1, 1) =~ /[sS]/) {
				$i++;
				for ($j = 1; $j + $i <= $len; $j++) {
				    $ch2 = substr($_, $j + $i, 1);
				    if ($ch2 =~ /[ \t]/) {
					last;
				    }
				    else {
					if ($s_filled == 0) {
					    $s_old = $s_old . $ch2;
					}
				    }
				}
				$s_filled = 1;
				$i += $j;
			    }
			    else {
				if (substr($_, $i + 1, 1) =~ /[eE]/) {
				    $i++;
				    for ($j = 1; $j + $i <= $len; $j++) {
					$ch2 = substr($_, $j + $i, 1);
					if ($ch2 =~ /[ \t]/) {
					    last;
					}
					else {
					    if ($e_filled == 0) {
						$e_old = $e_old . $ch2;
					    }
					}
				    }
				    $e_filled = 1;
				    $i += $j;
				}
				else {
				    $line = $line . $ch;
				}
			    }
			}
			else {
			    $line = $line . $ch;
			    if ($i < $len) {
				$i++;
				$ch = substr($_, $i, 1);
				if ($ch =~ /[sS]/) {
				    $ch = 'i';
				}
				else {
				    if ($ch =~ /[eE]/) {
					$ch = 'i#';
				    }
				}
				$line = $line . $ch;
			    }
			}
		    }
		    else {
			$line = $line . $ch;
		    }
		}
	    }
	    if ($is_both == 1) {
		$line = $line . '%i' . $s_old . '#' . $e_old;
	    }
	    print $line;
	}
	else {
	    print $_;
	}
    }
    else {
	if ($mode == 2) {
	    $mode = 1;
	}
	else {
	    print $_;
	}
    }
}
