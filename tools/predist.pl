#!/usr/bin/perl -w
#

use strict;

print("Performing pre-distribution checks...\n");
print("\ncheckversion...\n");
print `tools/checkversion.pl`;
print("\nmakedocs...\n");
print `tools/makedocs.sh`;

