package JSON::Karabiner::Manipulator::Actions::To_if_alone ;

use strict;
use warnings;
use JSON;
use Carp;
use parent 'JSON::Karabiner::Manipulator::Actions::To';

sub new {
  my $class = shift;
  my ($type, $value) = @_;
  my $obj = $class->SUPER::new($type, $value);
  $obj->{data} = $value || [],
  return $obj;
}

# ABSTRACT: to_if_alone action class

1;

__END__

=head1 SYNOPSIS

  use JSON::Karabiner;

  my $to_if_alone_action = $manip_obj->add_action('to_if_alone');

  # Use methods to add data to the C<to_if_alone> action:

  $to_if_action->add_key_code('h', 'i', 'x');
  $to_action->add_l_modifiers('control', 'left_shift');

=head1 DESCRIPTION

See L<JSON::Karabiner::Manipulator::Actions::To> for documentation of this
class' methods.

See L<the official Karabiner documentation|https://karabiner-elements.pqrs.org/docs/json/complex-modifications-manipulator-definition/to-if-alone/> for more details on how this action works.
