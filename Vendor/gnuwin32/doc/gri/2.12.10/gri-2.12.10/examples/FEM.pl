#!/usr/bin/perl -w
$missing = -99.99;		# missing value

$debug = 0;			# set to 1 to debug

$node_file = $ARGV[0];
$element_file = $ARGV[1];
open (NODE, $node_file) or die "Cannot open '$node_file' file";
open (ELEM, $element_file) or die "Cannot open '$element_file' file";

# Read in node information, creating arrays $node_x[] and $node_y[].
# While reading, check that the first column (the index) makes sense.
$max_node = 1;
while(<NODE>) {
    ($index, $node_x[$max_node], $node_y[$max_node]) = split;
    if ($debug) {
	chop;
	print "NODE $index data: '$_'\n";
    }
    die "Node index mismatch at index=$index" if ($index != $max_node);
    $max_node++;
}

# Read in triangle elements, into arrays, $a[], $b[], and $c[].
# While reading, check that the first column (the index) makes sense.
$max_elem = 1;
while(<ELEM>) {
    ($index, $a[$max_elem], $b[$max_elem], $c[$max_elem]) = split;
    if ($debug) {
	chop;
	print "ELEM $index data: '$_' a[$max_elem]=$a[$max_elem] etc\n";
    }
    die "Element index mismatch at index=$index" if ($index != $max_elem);
    $max_elem++;
}

# Print out triangles suitable for plotting in gri.
for ($i = 1; $i < $max_elem; $i++) {
    if ($debug) {
	print "i=", $i," c[i]=", $c[$i], " node_x[]=", $node_x[$c[$i]], "\n";
    }
    print $node_x[$a[$i]], " ", $node_y[$a[$i]], "\n";
    print $node_x[$b[$i]], " ", $node_y[$b[$i]], "\n";
    print $node_x[$c[$i]], " ", $node_y[$c[$i]], "\n";
    # Repeat first, to close the triangle.
    print $node_x[$a[$i]], " ", $node_y[$a[$i]], "\n";
    print $missing, " ", $missing, "\n";

}

