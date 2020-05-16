#/usr/bin/env perl
use Test::Most;
use JSON::Karabiner::Manipulator;
do 't/utility_funcs.pl';












my $tests = 1; # keep on line 17 for ,i (increment and ,d (decrement)

plan tests => $tests;

my $file = glob('~/.config/karabiner/assets/complex_modifications/test_file881.json');
use Data::Dumper qw(Dumper);
print Dumper $file;

unlink $file;

new_manipulator('little title', 'test_file881.json');
add_action('from');
add_key_code('x');
write_file('some test');

is (-f $file, 1, 'writes the file');

unlink $file;
