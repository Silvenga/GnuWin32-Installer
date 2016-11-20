#!/usr/bin/perl
#
# xbm2xface -- convert a 48x48 xbm file to an xface header
#
#					   Stig@hackvan.com

sub reverse_byte {
    local($byte) = @_;
    local($n, $b);
    for ( $b= $n= 0; $b<8; ++$b) {
	$n |= (($byte & 1) << (7-$b));
	$byte >>= 1;
    }
    return($n);
}

#printf "0x%02x\n", &reverse_byte(0xF0);

<>;
m/^#define \w+_width (\d+)/ && ($width=$1);
<>;
m/^#define \w+_height (\d+)/ && ($height=$1);
<>;
m/^static.* = \{/ && (( $width == 48 && $height == 48 )
		      || die "xfaces are 48x48" );

open(CF,"|compface");

while (<>) {
    $st="";
    while (s/(0x..)(,|\};)\s*//) {
	$st .= sprintf("0x%02x, ", &reverse_byte(eval($1)));
    }
    $_=$st;
    s/(0x..), 0x(..)/\1\2/g;
    s/\s*(0x...., 0x...., 0x....)(,|\};)\s/\1,\n/g;
    print CF $_;
}
close (CF);
