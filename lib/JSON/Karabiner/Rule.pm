package JSON::Karabiner::Rule ;

use strict;
use warnings;
require JSON::Karabiner::Manipulator ;
use Carp;

sub new {
  my $class = shift;
  my $desc = shift;
  croak 'JSON::Karabiner constructor requires a desc.' if !$desc;
  my $self = {
    description => $desc,
    manipulators => []
  };
  bless $self, $class;
  return $self;
}

sub _disable_validity_tests {
  my $s = shift;
  my $enable = shift;

  my $op = $enable ? 0 : 1;
  foreach my $manip (@{$s->{manipulators}}) {
    $manip->{_disable_validity_tests} = $op;
  }
}

sub _enable_validity_tests {
  my $s = shift;
  $s->_disable_validity_tests(1);
}

sub add_manipulator {
  my $s = shift;

  my $manip  = JSON::Karabiner::Manipulator->new_manipulator();
  push @{$s->{manipulators}}, $manip;
  return $manip;
}

sub TO_JSON { return { %{ shift() } }; }


# ABSTRACT: Rule object for holding manipulators

1;

__END__


=head1 DESCRIPTION

Please see the L<JSON::Karabiner> for thorough documentation.
Methods are listed below for technical reference purposes only.

=head3 new()

For use with legacy OO interface, unused by DSL interface

=head3 add_manipulator()

For use with legacy OO interface, unused by DSL interface

