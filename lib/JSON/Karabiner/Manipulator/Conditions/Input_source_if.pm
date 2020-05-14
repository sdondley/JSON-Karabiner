package JSON::Karabiner::Manipulator::Conditions::Input_source_if ;

use strict;
use warnings;
use JSON;
use Carp;
use parent 'JSON::Karabiner::Manipulator::Conditions::Device_if';

sub new {
  my $class = shift;
  my ($type, $value) = @_;
  my $obj = $class->SUPER::new($type, $value);
  $obj->{data}{input_sources} = $value || [],
  return $obj;
}

sub add_input_source {
  my $s = shift;
  my @values = @_;
  croak 'A value for the input_source name is required' unless @values;
  my $hash = { @values };
  #TODO: Validates keys
  push @{$s->{data}{input_sources}}, $hash;

}

# ABSTRACT: definition for Frontmost_application_if condition

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
