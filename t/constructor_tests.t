#/usr/bin/env perl
use Test::Most;
use JSON::Karabiner;













my $tests = 8; # keep on line 17 for ,i (increment and ,d (decrement)

plan tests => $tests;

# test that it dies if file not passed
dies_ok { JSON::Karabiner->new() } 'dies if no file name passed';
throws_ok { JSON::Karabiner->new() } qr/requires a title/, 'gives correct error message';
dies_ok { JSON::Karabiner->new('file') } 'dies when no title is passed';
dies_ok { JSON::Karabiner->new('title', 'some_file') } 'dies when file does not end in json extension file name is passed';
is 'some_file.json', JSON::Karabiner->new('title', 'some_file.json')->{_file}, 'sets file';
is "$ENV{HOME}/.config/karabiner/assets/complex_modifications/", JSON::Karabiner->new('title', 'some_file.json')->{_mod_file_dir}, 'sets mod path';
is "custom_mod_dir", JSON::Karabiner->new('title', 'some_file.json', {mod_file_dir => 'custom_mod_dir'})->{_mod_file_dir}, 'can create a custom mod dir';
is_deeply (JSON::Karabiner->new('title', 'some_file.json')->{_karabiner}, { 'title' => 'title' }, 'adds title to object');
