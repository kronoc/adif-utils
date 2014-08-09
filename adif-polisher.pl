#!/usr/bin/perl -wT

use strict;
use warnings;
use utf8;

#use LWP::UserAgent;
#use XML::RSS::Parser;
use FileHandle;
#use Date::Parse;
#use URI;

binmode STDOUT, ':encoding(utf8)';
binmode STDERR, ':encoding(utf8)';

my $file = 'logbook.adi';
open my $info, $file or die "Could not open $file: $!";

while( my $line = <$info>)  { 
	if ($line =~ /<EOR>/){
	print "\n<EOR>\n";
		next;
	}  
	$line =~ /<(.*):\?>(.*)/;
    	my $field = "$1";
	my $value = "$2";
	my $len = 0;
	$len = length $value; 
	print $line;	
	print "<$field:$len>$value";    
    	#last if $. == 2;
}

close $info;
