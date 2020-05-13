#/usr/bin/env perl
use Test::Most;
use JSON::Karabiner;
do 't/utility_funcs.pl';












my $tests = 15; # keep on line 17 for ,i (increment and ,d (decrement)

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
#dies_ok { $def->add_any('key_code') } 'dies if you try to add mutually exclusive properties';
#dies_ok { $def->add_key_code('7') } 'dies if you try to add mutually exclusive properties';
#dies_ok { $def->add_pointing_button('left') } 'dies if you try to add mutually exclusive properties';
#
#lives_ok { $def->add_optional_modifiers('any') } 'can add modifiers';
#lives_ok { $def->add_mandatory_modifiers('command', 'right_shift') } 'can add modifiers';
#dies_ok { $def->add_mandatory_modifiers('command', 'right_shift') } 'cannot re-add modifiers';
#lives_ok { $def->add_simultaneous('key_code', 'a', 'b', 'c') } 'can add simultaneous';
#lives_ok { $def->add_simultaneous('consumer_key_code', 'a', 'b', 'c') } 'can add simultaneous';




#my $obj;
#lives_ok { $obj = JSON::Karabiner->new('some_title', 'file.json'); } 'creates object';
#my $rule;
#lives_ok { $rule = $obj->create_rule('some rule'); } 'can create rule';
#
#my $manip;
#lives_ok { $manip = $rule->add_manipulator } 'creates a manipulator without error';
#
#my $from;
#lives_ok { $from = $manip->add_definition('from') } 'creates a definition without error';
#
#dies_ok { my $failed_def = $manip->add_definition('blah') } 'doesn\'t create definition with bad name';
#
#my $to;
#lives_ok { $to = $manip->add_definition('to') } 'creates a definition for to';
#lives_ok { $to->add_key_code( 'semicolon') } 'can add key_code to to definition';
#lives_ok { $from->add_key_code( 'period') } 'can add key_code to from definition';
#lives_ok { $to->add_key_code( 'period') } 'can add key_code to to definition';
#dies_ok { $from->add_consumer_key_code( 'blah' ) } 'can add consumer_key_code';

#my $new_obj->_dump_json;

#lives_ok { $obj->write_file };


#use Data::Dumper qw(Dumper);
#print Dumper $manip;


#my $manip;
#lives_ok { $manip = $rule->add_manipulator(from => {'key_code' => 'a'}, to => {'key_code' => 'b'}) };
#is_deeply ($rule->{manipulators}, [ { from => {'key_code' => 'a'}, to => {'key_code' => 'b'} } ], 'adds manipulators');



#my $condition;
#lives_ok { $condition = $manip->add_definition('conditions') };
#is_deeply ($rule->{manipulators}, [ { from => {'key_code' => 'a'}, to => {'key_code' => 'b'}, conditions => [ ] } ], 'adds conditions');
#
