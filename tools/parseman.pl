#!/usr/bin/perl -w

use strict;

if ($ARGV[0]) {
	open(OF, "<$ARGV[0]") or die "Unable to open $ARGV[0] : $!\n";
	open(NF, ">>$ARGV[0].tmp") or die "Unable to open $ARGV[0].tmp : $!\n";
	foreach my $line (<OF>) {
		if ($line =~ /Pod::Man/) {
			# skip
		}
		elsif ($line =~ /^.TH /) {
			my @tmp = split(/ /, $line);
			print NF "$tmp[0] $tmp[1] $tmp[2] $tmp[3]\n";
		}
		else {
			print NF $line;
		}
	}
	close OF;
	close NF;

	system('rm', "$ARGV[0]");
	system('mv', "$ARGV[0].tmp", "$ARGV[0]");
}
exit(1);
