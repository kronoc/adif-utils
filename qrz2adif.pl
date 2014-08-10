#!/usr/bin/perl -Tw

use warnings;
use strict;

my $adifData = "";
my @fields = (
	[ "lde", "CALL" ],
	[ "lba", "BAND" ],
        [ "lbt", "QSO_DATE" ],
        [ "ltm", "TIME_ON" ],
        [ "lfr", "FREQ" ],
        [ "lmo", "MODE" ],
        [ "lgr", "LOC" ],
        [ "lcc", "DXCC" ],	
    );
#handle EOR and DXCC
binmode STDOUT, ':encoding(utf8)';
binmode STDERR, ':encoding(utf8)';

while( my $line = <>)  {
	$adifData = $adifData . extract($line);
}
writeadif($adifData);

sub extract{
	my $line = shift(@_);
	foreach my $field(@fields){
		if (($line =~ /<td class=\"@$field[0]\" .*\">(.*)<\/td>/) && ($line !~ /<img src.*\/>/)) {
		return "<@$field[1]:".length($1).">$1\n";
		};
	}
}

sub writeadif{
	my $data = shift(@_);
	print "$data";
}

