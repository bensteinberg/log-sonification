#!/usr/bin/perl

# this takes in a Tomcat log line by line and emits each line
# approximately according to timestamp, so as to correct the 
# buffering behavior of "tail -f"

use Time::Piece;

local $| = 1;

my $format = "%d/%b/%Y:%H:%M:%S";

my $last = 0;

while (<>) {
    my @parts = split(/ /);
    my $timestamp = $parts[3];
    $timestamp =~ s/^\[//;
    $epoch = Time::Piece->strptime($timestamp, $format)->epoch;
    if ($last == 0) {
	print;
	$last = $epoch;
    } else {
	sleep($epoch - $last);
	print;
	$last = $epoch;
    }
}
