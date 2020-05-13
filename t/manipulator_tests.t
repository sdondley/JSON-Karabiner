#/usr/bin/env perl
use Test::Most;
use JSON::Karabiner;
do 'utility_funcs.pl';













my $tests = 10; # keep on line 17 for ,i (increment and ,d (decrement)

plan tests => $tests;

# test that it dies if file not passed
my $obj;
lives_ok { $obj = JSON::Karabiner->new('some_title', 'file.json'); } 'creates object';
my $rule;
lives_ok { $rule = $obj->create_rule('some rule'); } 'can create rule';

my $manip;
lives_ok { $manip = $rule->add_manipulator } 'creates a manipulator without error';

my $from;
lives_ok { $from = $manip->add_action('from') } 'creates a action without error';

dies_ok { my $failed_def = $manip->add_action('blah') } 'doesn\'t create action with bad name';

my $to;
lives_ok { $to = $manip->add_action('to') } 'creates a action for to';
lives_ok { $to->add_key_code( 'semicolon') } 'can add key_code to to action';
lives_ok { $from->add_key_code( 'period') } 'can add key_code to from action';
lives_ok { $to->add_key_code( 'period') } 'can add key_code to to action';
dies_ok { $from->add_consumer_key_code( 'blah' ) } 'can add consumer_key_code';
$obj->_dump_json;
