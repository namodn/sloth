#!/usr/bin/perl -w
#

use strict;
my $version_file = "VERSION";
my $include_files = "*.c sloth.1 *.in *.am *.pod README INSTALL";

open (V, "<$version_file") or 
	die "Failed to get version from: $version_file, $!\n";
my @file = <V>;
my $version = $file[0];
@file = ();
close V;
chomp $version;

print("current version: $version\n");
print("----------------------\n");
foreach my $file (`ls $include_files`) {
	next if ($file =~ /.gz$/);
	next if ($file =~ /.tar$/);
	chomp $file;
	my $lnum = 0;
	open (F, "<$file") or 
		die "Failed to read file: $file, $!\n";
	foreach my $line (<F>) {
		$lnum++;
		next if ($line =~ /^$/);
		#printf("$file: $line");
		if ($line =~ /\d\.\d\.\d/) {
			chomp $line;
			printf ("$file, $lnum:\t$line\n");
		}
	}
	close F;
}
