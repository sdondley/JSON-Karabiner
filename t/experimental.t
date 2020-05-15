#/usr/bin/env perl
use Test::Most;
use JSON::Karabiner::Manipulator;
use JSON::Karabiner;
do 't/utility_funcs.pl';












my $tests = 9; # keep on line 17 for ,i (increment and ,d (decrement)

plan tests => $tests;

my $manip;
lives_ok { $manip = new_manipulator('little title', 'file.json'); } 'can create a manipulator object directly';
my $from;
lives_ok { $from = $manip->add_action('from') } 'can add a from action';
lives_ok { $from->add_key_code('t') } 'can add a from action';

lives_ok { $manip->_fake_write_file('A title') } 'can fake write a file with manipulator';
lives_ok { $manip->_dump_json; } 'can _dump_json with manipulator';


my ($new_obj, $action, $manip_new) = gen_def('from');

dies_ok { $manip_new->_dump_json } 'cannot dump json from manipulator created with old method';

my ($new_obj2, $action2, $manip_new2) = gen_def('from');
throws_ok { $manip_new2->_dump_json } qr/the _dump_json method cannot/i, 'throws correct error';
dies_ok { $manip_new2->_fake_write_file } 'cannot fake_write with manipulator using old mehod';
throws_ok { $manip_new2->_fake_write_file } qr/the _fake_write method cannot/i, 'throws correct error';
