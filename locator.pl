#!/usr/bin/perl -Tw

#work in progress

use warnings;
use strict;

use Ham::Locator;
use Geo::Coordinates::Transform;

my $m = new Ham::Locator;
$m->set_loc('IO93lo');
my @latlng = $m->loc2latlng;

#TODO add leading zeros http://www.adif.org/adif227.htm#Location
my $cnv = new Geo::Coordinates::Transform();
my $out_ref = [];
$out_ref = $cnv->cnv_to_dms(\@latlng);
my $lat_dec = ${$out_ref}[0]; 
if ($lat_dec =~ /-/){
	$lat_dec =~ s/-//g;
	$lat_dec = "S".$lat_dec;
}else{
	$lat_dec = "N".$lat_dec;
}
my $long_dec = ${$out_ref}[1];
if ($long_dec =~ /-/){
	$long_dec =~ s/-//g;
        $long_dec = "W".$long_dec;
}else{
        $long_dec = "E".$long_dec;
}

print $lat_dec." ".$long_dec;

#print "${ $out_ref }[0] and $out_ref[1]";
