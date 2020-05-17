package JSON::Karabiner::Manipulator::Actions::To_delayed_if_invoked ;

use strict;
use warnings;
use JSON;
use Carp;
use parent 'JSON::Karabiner::Manipulator::Actions::To';

sub new {
  my $class = shift;
  my ($type, $value) = @_;
  my $obj;
  if ($main::has_delayed_action) {
    $obj = $main::has_delayed_action;
  } else {
    $obj = $class->SUPER::new('to_delayed_action', $value);
    $obj->{data} = {};
  }
  $obj->{delayed_type} = 'invoked';
  if ($value) {
    $obj->{data} = $value,
  } else {
    $obj->{data}{to_if_invoked} = [];

#    $obj->{data}{to_delayed_action}{to_if_invoked} = [];
  }
  $main::has_delayed_action = $obj;
  return $obj;
}

# ABSTRACT: to_delayed_if_invoked action

1;

__END__
