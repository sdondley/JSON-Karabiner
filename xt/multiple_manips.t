use Test::Most;
use JSON::Karabiner;
use strict;
use warnings;
do 'xt/utility_funcs.pl';











my $tests = 1; # keep on line 17 for ,i (increment and ,d (decrement)
plan tests => $tests;

run_script('4_finger_swipes.pl');
is 1, 1, 'can run';
