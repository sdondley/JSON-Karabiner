#/usr/bin/env perl
use Test::Most;
use JSON::Karabiner;
do 't/utility_funcs.pl';












my $tests = 40; # keep on line 17 for ,i (increment and ,d (decrement)

plan tests => $tests;

my ($obj, $def, $manip) = gen_def('to_delayed_if_invoked');
$manip->add_action('to_delayed_if_canceled');


$obj->_dump_json;
