#!/usr/bin/perl -Tw

use warnings;
use strict;

our @adif_defaults;

require "./adif-defaults.conf";
#require "../../../Dropbox/Personal/docs/radio/adif-defaults.conf";

my @fields = (
	[ "lde", "CALL" ],
	[ "lba", "BAND" ],
        [ "ldt", "QSO_DATE" ],
        [ "ltm", "TIME_ON" ],
        [ "lfr", "FREQ" ],
        [ "lmo", "MODE" ],
        [ "lgr", "GRIDSQUARE" ],
        [ "lcc\" onclick=", "COUNTRY" ],
	[ "lcc\" style=", "NAME" ],	
    );

my $eor = "<EOR>";
my $blank_grid = "JJ00aa";

binmode STDOUT, ':encoding(utf8)';
binmode STDERR, ':encoding(utf8)';

while (my $line = <>)  {
	print extract($line);
}

sub extract {
	my $line = shift(@_);
	foreach my $field(@fields){
		if (($line =~ /<td class=\"@$field[0]\".*\">(.*)<\/td>/) && ($line !~ /<img src.*\/>/)) {
			if ($1 ne " " && $1 ne $blank_grid){
				return "<@$field[1]:".length($1).">".clean($1)."\n";
			}
		}
		if ($line =~ /<td class="lac">(.*)<\/td>/) {
			my $station = "";
			foreach my $default(@adif_defaults){
				$station = $station . "<@$default[0]:".length(@$default[1]).">".@$default[1]."\n";
			}
                	return $station . $eor ."\n";
                }
	}
}

sub clean {
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

