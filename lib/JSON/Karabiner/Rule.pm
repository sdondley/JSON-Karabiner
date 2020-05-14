package JSON::Karabiner::Rule ;

use strict;
use warnings;
use JSON::Karabiner::Manipulator ;
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

sub add_manipulator {
  my $s = shift;

  my $manip  = JSON::Karabiner::Manipulator->new($s->{manipulators});
  push @{$s->{manipulators}}, $manip;
  return $manip;
}

sub TO_JSON { return { %{ shift() } }; }


# ABSTRACT: turns baubles into trinkets

1;

__END__


=head1 DESCRIPTION

Please see the L<JSON::Karabiner> for more thorough documentation of these module.
Methods are listed below for reference purposes only.

=head3 add_manipulator()
