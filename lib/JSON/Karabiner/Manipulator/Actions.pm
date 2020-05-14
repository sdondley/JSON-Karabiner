package JSON::Karabiner::Manipulator::Actions ;

use strict;
use warnings;
use JSON;
use Carp;

sub new {
  my $class = shift;
  my $type = shift;

  my $self = {
    def_name => $type,
    consumer_key_code => 0,
    pointing_button => 0,
    key_code => 0,
    any => 0,
    last_key_code => '',

  };
  bless $self, $class;
  return $self;
}

sub add_consumer_key_code {
  my $s = shift;
  croak 'You must pass a value' if !$_[0];
  $s->add_key_code(@_, 'consumer_key_code');
}

sub add_pointing_button {
  my $s = shift;
  croak 'You must pass a value' if !$_[0];
  $s->add_key_code(@_, 'pointing_button');
}

sub _is_exclusive {
  my $s = shift;
  my $property = shift;
  croak 'No property passed' unless $property;
#  my $is_exclusive = !grep { !$s->{$_} unless $_ eq $property } qw(shell_command select_input_source set_variable mouse_key consumer_key_code pointing_button key_code);
#  croak 'Property already set that conflicts with the propert you are trying to set' unless $is_exclusive;
  $s->{$property} = 1;
}

sub TO_JSON {
  my $obj = shift;
  my $name = $obj->{def_name};
  my $value = $obj->{data};
  return { $name => $value };

  # return { %{ shift() } };
}

# ABSTRACT: parent class for action classes

1;

__END__

=head1 DESCRIPTION

Please see the documentation for the
L<JSON::Karabiner::Manipulator::Actions::To> and
L<JSON::Karabiner::Manipulator::Actions::From> parent class actions for more
descriptive documentation of all action object methods. Methods are listed below
for reference purposes only.

=head3 new($type)

=head3 add_consumer_key_code(@values)

=head3 add_pointing_button(@values)

=head3 TO_JSON()
