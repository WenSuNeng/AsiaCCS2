#!/usr/bin/perl
print exec('make telosb install,1 bsl,/dev/ttyUSB1');
print exec('make telosb install,2 bsl,/dev/ttyUSB2');
print "Hello,world!\n";


