use strict;
use warnings;

sub gen_def {
  my $type = shift;
  my $obj = JSON::Karabiner->new('some_title', 'file.json');
  my $def = $obj->create_rule('some desc')->add_manipulator->add_definition($type);
  return ($obj, $def);

}
