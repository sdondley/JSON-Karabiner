package JSON::Karabiner::Manipulator::Conditions::Keyboard_type_if ;

use strict;
use warnings;
use JSON;
use Carp;
use parent 'JSON::Karabiner::Manipulator::Conditions';

sub new {
  my $class = shift;
  my ($type, $value) = @_;
  my $obj = $class->SUPER::new($type, $value);
  $obj->{data} = $value || {},
  return $obj;
}

sub add_keyboard_types {
  my $s = shift;
  my @values = @_;
  croak 'A list of keyboard types is required' unless @values;
  $s->{data}{keyboard_types} =  \@values ;
}

sub add_description {
  my $s = shift;
  my $desc = shift;
  croak ('No description passed.') unless $desc;
  $s->{data}{description} = $desc;

}

sub TO_JSON {
  my $obj = shift;
  my $name = $obj->{def_name};
  my $value = $obj->{data};
  my %super_hash = (%$value, type => $name);
  return { %super_hash };

}
#ABSTRACT: definition for keyboard_type_if condition

1;

__END__

=head1 OVERVIEW

Provide overview of who the intended audience is for the module and why it's useful.

=head1 SYNOPSIS

  use JSON::Karabiner;

=head1 DESCRIPTION

=head3 method1()



=head3 method2()



=func function1()



=func function2()



=attr attribute1



=attr attribute2



#=head1 CONFIGURATION AND ENVIRONMENT
#
#JSON::Karabiner requires no configuration files or environment variables.


=head1 DEPENDENCIES

=head1 AUTHOR NOTES

=head2 Development status

This module is currently in the beta stages and is actively supported and maintained. Suggestion for improvement are welcome.

- Note possible future roadmap items.

=head2 Motivation

Provide motivation for writing the module here.

#=head1 SEE ALSO
