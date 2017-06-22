#!/usr/bin/perl
use strict;
use AVProbe;
use Test::Simple;

my $probe = new AVProbe({
    file => shift,
});

ok($probe->valid);

