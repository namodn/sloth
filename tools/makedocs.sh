#!/bin/sh

pod2text sloth.pod > README
pod2man sloth.pod > sloth.1
./tools/parseman.pl sloth.1

