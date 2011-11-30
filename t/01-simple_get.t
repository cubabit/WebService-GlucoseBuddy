#!/usr/bin/env perl

use strict;
use warnings;

use Test::More 0.98 tests => 2;

BEGIN { use_ok 'WebService::GlucoseBuddy'; }

my $gb = WebService::GlucoseBuddy->new(
    username    => 'cubabit',
    password    => 'ackbar',
);
isa_ok($gb => 'WebService::GlucoseBuddy');

use Data::Dumper;
my $logs = $gb->logs;
while (my $log = $logs->next) {
    diag Dumper $log;
}

done_testing();
