#!/usr/bin/perl -Tw

use warnings;
use strict;

my $eor = "<eor>";

binmode STDOUT, ':encoding(utf8)';
binmode STDERR, ':encoding(utf8)';

my $self = {
        -adif_log => "/tmp/lotw.adif",
	-wsjt_log => "/tmp/wsjtx.log",
	-callsign => "Q0AAA",
	-user => 'info@conor.foo',
        @ARGV
};

my $wsjt_log_file = $self->{"-wsjt_log"};
my $adif_log_file = $self->{"-adif_log"};

main();

sub main {
open(my $adif_log, '<', $adif_log_file) or die "Could not open '$adif_log_file' $!\n";
while (my $line = <$adif_log>) {
	chomp $line;
	if ($line =~ /  <CALL:\d+>(.*)<BAND:\d+>(.*)<FREQ:\d+>(.*)<MODE:\d+>(.*)<QSO_DATE:\d+>(.*)<TIME_ON:\d+>(.*)<QSL_RCVD:1>(.*)<eor>/) {
              	my $call = trim($1) || die "call missing from line $line";
		my $freq = trim($3) || die "freq missing from line $line";
		my $date = trim($5) || die "date missing from line $line";
		my $rst = extractRST($call,$freq,$date);
		my $rst_len = length($rst);
		print $line =~ s/$eor/<RST_SENT:$rst_len>$rst $eor/r, "\n";
	}
}
}
sub extractRST {
	my ($call,$freq,$date) = @_;
	open(my $wsjt_log, '<', $wsjt_log_file) or die "Could not open '$wsjt_log_file' $!\n";
	my $rst="599"; 
	while (my $line = <$wsjt_log>) {
		chomp $line; 
		my @fields = split "," , $line;
		my $wsjt_date = "$fields[0]" || die "date missing from line $line";
		my $wsjt_call = "$fields[4]" || die "callsign missing from line $line";
		my $wsjt_freq = trimFreq("$fields[6]") || die "freq missing from line $line";
		my $wsjt_rst = "$fields[8]" || "599";

		if (("$wsjt_call" eq "$call") 
			and (parseDateTime("$date") eq "$wsjt_date") 
			and (trimFreq("$freq") eq "$wsjt_freq")) {
			$rst = "$wsjt_rst";
		}
	}
	return $rst;
}	


sub trimFreq {
	my $freq = shift(@_);
	$freq =~ s/\..*//;	
	return $freq;
}

sub parseDateTime {
	my $value = shift(@_);
	if ($value =~ /\d\d\d\d\d\d\d\d/){
                $value =~ s/(\d\d\d\d)(\d\d)(\d\d)/$1-$2-$3/g;
        }
	if ($value =~ /\d\d:\d\d/){
                $value =~ s/(\d\d)(\d\d)(\d\d)/$1:$2:$3/g;
        }
	return $value;
}

sub trim() {
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}
