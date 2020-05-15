#/usr/bin/env perl
use Test::Most;
use JSON::Karabiner::Manipulator;
do 't/utility_funcs.pl';












my $tests = 2; # keep on line 17 for ,i (increment and ,d (decrement)

plan tests => $tests;

lives_ok { new_manipulator('Manip 1 Title', 'file.json'); } 'can create a manipulator object directly';
add_action 'from';
add_key_code 'x';


add_action 'to';
add_key_code 'y';

_dump_json;

write_file('Some title');

lives_ok { new_manipulator('Manip 2 Title', 'file.json'); } 'can add a new manipulator';
add_action 'from';
add_key_code 'a';

add_action 'to';
add_key_code 'b';

_dump_json;

_fake_write_file();
