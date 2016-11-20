#!/usr/bin/perl -T

#A simple CGI wrapper for fax2png. This is not the command line
#program. For that, just run fax2png itself or see "man fax2png"
#for documentation.
# 
#Copyright 2004, Boutell.Com, Inc. and Tobacco Documents Online.
#Released under the GNU General Public License, version 2 or later.

#Necessary prologue
use CGI;
use strict;
$ENV{PATH}='/bin:/usr/bin';

#Settings you must change
#Set to the parent directory beneath which the tiffs are kept
my $dataDir = "/home/boutell/tmp";

#Set to the full path of the tif2png executable
my $tif2png = "/home/boutell/tif2png/tif2png";

#No changes required below here

#Must use a version of Perl new enough to autoflush
require 5.006_001;

my $query = new CGI;
my $rawFile = $query->param('fn');
my $page = $query->param('page');
my $width = $query->param('width');
my $rotation = $query->param('rotation');
my $antialias = $query->param('antialias');
my $lr = $query->param('lr');
my $tb = $query->param('tb');

my $cmd = "$tif2png ";

#Only safe characters in filenames

my $file;

if ($rawFile =~ /^([\.\w\/\-\+\ ]+)$/) {
	$file = $1; 
} else {
	die "Dangerous filename: $rawFile";
}

if ($file =~ /\.\./) {
	# Don't allow navigation back up the directory tree
	die "Dangerous filename: $file";
}

$cmd .= "$dataDir/$file ";

if ($page =~ /^(\d+)$/) {
	$page = $1;
	$cmd .= "-p $page ";
}

if ($width =~ /^(\d+)$/) {
	$width = $1;
	$cmd .= "-w $width ";
}

if ($rotation =~ /^(\d+)$/) {
	$rotation = $1;
	$cmd .= "-r $rotation ";
}

if ($lr ne "") {
	$cmd .= "-lr ";
}

if ($tb ne "") {
	$cmd .= "-tb ";
}

if ($antialias ne "") {
	$cmd .= "-a ";
}

#Output the content type
print "Content-type: image/png\r\n\r\n";

#OK, ready to generate the image to stdout
system($cmd);

exit 0;

