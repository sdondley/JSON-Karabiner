#/usr/bin/env perl
use Test::Most;
use JSON::Karabiner;
do 't/utility_funcs.pl';













my $tests = 4; # keep on line 17 for ,i (increment and ,d (decrement)

plan tests => $tests;

my ($obj, $def) = gen_def('from');
dies_ok { $def->add_consumer_key_code } 'can add consumer key code';
lives_ok { $def->add_consumer_key_code('blah') } 'can add consumer key code';
dies_ok { $def->add_any('key_code') } 'dies if you try to add mutually exclusive properties';
dies_ok { $def->add_key_code('7') } 'dies if you try to add mutually exclusive properties';
dies_ok { $def->add_pointing_button('left') } 'dies if you try to add mutually exclusive properties';

lives_ok { $def->add_optional_modifiers('any') } 'can add modifiers';
lives_ok { $def->add_mandatory_modifiers('command', 'right_shift') } 'can add modifiers';
dies_ok { $def->add_mandatory_modifiers('command', 'right_shift') } 'cannot re-add modifiers';
lives_ok { $def->add_simultaneous('key_code', 'a', 'b', 'c') } 'can add simultaneous';
lives_ok { $def->add_simultaneous('consumer_key_code', 'a', 'b', 'c') } 'can add simultaneous';


$obj->_dump_json;


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
