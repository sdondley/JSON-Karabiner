#/usr/bin/env perl
use Test::Most;
use JSON::Karabiner;
do 'utility_funcs.pl';













my $tests = 4; # keep on line 17 for ,i (increment and ,d (decrement)

plan tests => $tests;

# test that it dies if file not passed
my $obj;
lives_ok { $obj = JSON::Karabiner->new('some_title', 'file.json'); } 'creates object';
my $rule;
lives_ok { $rule = $obj->create_rule('some rule'); } 'can create rule';

my $manip;
lives_ok { $manip = $rule->add_manipulator } 'creates a manipulator without error';

my $from;
lives_ok { $from = $manip->add_definition('from') } 'creates a definition without error';

dies_ok { my $failed_def = $manip->add_definition('blah') } 'doesn\'t create definition with bad name';

my $to;
lives_ok { $to = $manip->add_definition('to') } 'creates a definition for to';
lives_ok { $to->add_key_code( 'semicolon') } 'can add key_code to to definition';
lives_ok { $from->add_key_code( 'period') } 'can add key_code to from definition';
lives_ok { $to->add_key_code( 'period') } 'can add key_code to to definition';
dies_ok { $from->add_consumer_key_code( 'blah' ) } 'can add consumer_key_code';
$obj->_dump_json;

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
