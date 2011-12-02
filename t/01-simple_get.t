#!/usr/bin/env perl

use strict;
use warnings;

use Test::More 0.98 tests => 11;
use DateTime 0.70;

BEGIN { use_ok 'WebService::GlucoseBuddy'; }

my $gb = WebService::GlucoseBuddy->new(
    username    => 'cubabit',
    password    => 'ackbar',
);
isa_ok($gb => 'WebService::GlucoseBuddy');

my $logs_set = $gb->logs;

my $log = $logs_set->next;
isa_ok($log => 'WebService::GlucoseBuddy::Log');

my $reading = $log->reading;
isa_ok($reading => 'WebService::GlucoseBuddy::Log::Reading');

is($reading->type  => 'BG',     'Reading type');
is($reading->value => 9.9,      'Reading value');
is($reading->unit  => 'mmol/L', 'Reading unit');

is($log->name   => '',                      'Log name');
is($log->event  => 'Before Breakfast',      'Log event');
is($log->time   => '2010-07-07T08:08:20',   'Log time');
is($log->notes  => '',                      'Log notes');

done_testing();
