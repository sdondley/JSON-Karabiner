#/usr/bin/env perl
use Test::Most;
use JSON::Karabiner;
do 't/utility_funcs.pl';












my $tests = 20; # keep on line 17 for ,i (increment and ,d (decrement)

plan tests => $tests;

my ($obj, $def) = gen_def('to');
dies_ok { $def->add_key_code } 'cannot add key code without value';
lives_ok { $def->add_key_code('h') } 'can add key code';
lives_ok { $def->add_key_code('i') } 'can add multiple key codes';
lives_ok { $def->add_key_code('i') } 'can add "lazy" to key codes';
lives_ok { $def->add_key_code('i-R') } 'can add "repeat" to key codes';
lives_ok { $def->add_key_code('i-H') } 'can add "halt" to key codes';
lives_ok { $def->add_key_code('i-L') } 'can add "lazy" to key codes';
lives_ok { $def->add_key_code('i-200') } 'can add "hold down time" to key codes';
lives_ok { $def->add_key_code('i', 'k', 'j', 'x') } 'can add multiple key codes';
lives_ok { $def->add_pointing_button('bazinga') } 'can add pointing_button';
lives_ok { $def->add_consumer_key_code('bazinga') } 'can add pointing_button';
dies_ok { $def->add_any('bazinga') } 'cannot add any';
$obj->_dump_json;
($obj, $def) = gen_def('to');
lives_ok { $def->add_shell_command('ls') } 'can add shell command';
lives_ok { $def->add_select_input_source('language', '^jp') } 'can add select_input_source';
lives_ok { $def->add_select_input_source('input_source_id', '^xxx') } 'can add select_input_source';
lives_ok { $def->add_set_variable('one', 'two') } 'can set variable';
lives_ok { $def->add_mouse_key('x', 5) } 'can add mouse_key';
dies_ok { $def->add_modifiers('left_shift', 'right_shift') } 'can not add modifiers';
lives_ok { $def->add_key_code('t') } 'can add key code';
lives_ok { $def->add_modifiers('left_shift', 'right_shift') } 'can add modifiers';
$obj->_dump_json;
