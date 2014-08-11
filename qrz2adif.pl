#!/usr/bin/perl -Tw

use warnings;
use strict;

my $adifData = "";
my @fields = (
	[ "lde", "CALL" ],
	[ "lba", "BAND" ],
        [ "ldt", "QSO_DATE" ],
        [ "ltm", "TIME_ON" ],
        [ "lfr", "FREQ" ],
        [ "lmo", "MODE" ],
        [ "lgr", "LOC" ],
        [ "lcc\" onclick=", "DXCC" ],
	[ "lcc\" style=", "OP" ],	
    );

my $default = "<MY_CALL:5>Q0QQQ\n<MY_QTH:6>II33ZZ\n";
my $eor = "<EOR>";

binmode STDOUT, ':encoding(utf8)';
binmode STDERR, ':encoding(utf8)';

while( my $line = <>)  {
	print extract($line);
}

sub extract{
	my $line = shift(@_);
	foreach my $field(@fields){
		if (($line =~ /<td class=\"@$field[0]\".*\">(.*)<\/td>/) && ($line !~ /<img src.*\/>/)) {
			if ($1 ne " "){
				return "<@$field[1]:".length($1).">".clean($1)."\n";
			}
		}
		if ($line =~ /<td class="lac">(.*)<\/td>/) {
                	return "$default$eor\n";
                }
	}
}

sub clean{
	my $value = shift(@_);
	if ($value =~ /&#216;/){
		$value =~ s/&#216;/0/g;
	}
	if ($value =~ /\d\d:\d\d/){
		$value =~ s/(\d\d):(\d\d)/$1$2/g;
	}
	if ($value =~ /\d\d\d\d-\d\d-\d\d/){
                $value =~ s/(\d\d\d\d)-(\d\d)-(\d\d)/$1$2$3/g;
        }
	return $value;
}

