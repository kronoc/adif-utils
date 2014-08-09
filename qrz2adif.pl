#!/usr/bin/perl -Tw

use warnings;
use strict;

my $htmlFile = "/tmp/tmp.html";
my $adifFile;
my $adifData;
binmode STDOUT, ':encoding(utf8)';
binmode STDERR, ':encoding(utf8)';
open my $data, $htmlFile or die "Could not open $htmlFile: $!";
while( my $line = <$data>)  {
	$adifData = $adifData . extract($line);
	$adifData = enrich($adifData);
}
writeadif($adifData,$adifFile);

sub extract{
#grep -h -A 13 -r "class=\"lrow \" data-rownum" $1 | rep "\t" | rep "    " | rep "\<\/td\>" "" | rep "&#216;" "0" |rep "<td class=\"lde\" .*\">" "<CALL:\?>" | rep "<td class=\"lba\" .*\">" "<BAND:?>" | rep "<td class=\"ldt\" .*\">" "<QSO_DATE:?>" | rep "<td class=\"ltm\" .*\">" "<TIME_ON:?>"| rep "<td class=\"lfr\" .*\">" "<FREQ:?>"| rep "<td class=\"lmo\" .*\">" "<MODE:?>"| rep "<td class=\"lgr\" .*\">" "<LOC:?>" | rep "<td class=\"lcc\" on.*\">" "<DXCC:?>"| rep "<td class=\"lcc\" .*\">" "<NOTES:?>" | rep "<td.*tr>" "<EOR>" | grep -v "<img\|<tr\|<td\|--" | rep "(\d\d):(\d\d)" "\1\2" | rep "(\d\d\d\d)-(\d\d)-(\d\d)" "\1\2\3"
}

sub enrich{

}

sub writeadif{

}

