#!/usr/bin/perl

# this converts a Tomcat log entry from DASH into a MIDI note,
# pan value (-1.0 to 1.0), and strike value (0.0 to 1.0)

use Socket qw( inet_aton );

local $| = 1;

my $strike;

while (<>) {
    @parts = split(/ /);
    # convert URL to MIDI note
    $target = $parts[6];
    if ($target =~ /^\/search/) {
	print "45";
    } elsif ($target =~ /bitstream/) {
	print "47";
    } elsif ($target =~ /workflow|submission|submit/) {
	print "48";
    } elsif ($target =~ /handle/) {
	print "49";
    } elsif ($target =~ /jpg|png|gif|ico/) {
	print "51";
    } elsif ($target =~ /\.js$/) {
	print "53";
    } elsif ($target =~ /theme/) {
	print "54";
    } elsif ($target ne '') {
	print "55";
    }
    if ($target ne '') {
	# convert IP address to pan value
	print " ";
	print sin(DottedQuadToLong($parts[0]));
	# convert size to strike value
	print " ";
	if ($parts[9] eq '-') {
	    $strike = "0.5";
	} else {
	    $strike = $parts[9] / 50000;
	    if ($strike > 1.0) {
		$strike = "1.0";
	    }
	    if ($strike < 0.1) {
		$strike = "0.1";
	    }
	}
	print $strike;
	print "\n";
    }
}

# from http://www.perlmonks.org/?node_id=546367
sub DottedQuadToLong {
    return unpack('N', inet_aton(shift)); 
}
