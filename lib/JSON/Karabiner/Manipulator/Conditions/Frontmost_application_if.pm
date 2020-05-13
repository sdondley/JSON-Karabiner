package JSON::Karabiner::Manipulator::Conditions::Frontmost_application_if ;

use strict;
use warnings;
use JSON;
use Carp;
use parent 'JSON::Karabiner::Manipulator::Conditions';

sub new {
  my $class = shift;
  my ($type, $value) = @_;
  my $obj = $class->SUPER::new($type, $value);
  $obj->{data} = $value || [],
  return $obj;
}

sub add_bundle_identifiers {
  my $s = shift;
  my @identifiers = @_;
  croak ('No identifier regular expressions passed.') unless @identifiers;
  push @{$s->{data}}, { bundle_identifiers => [ @identifiers ] };

}

sub add_file_paths {
  my $s = shift;
  my @files = @_;
  croak ('No file path regular expressions passed.') unless @files;
  push @{$s->{data}}, { file_paths => [ @files ] };

}

sub add_description {
  my $s = shift;
  my $desc = shift;
  croak ('No file path regular expressions passed.') unless $desc;
  push @{$s->{data}}, { description => $desc };

}
# ABSTRACT: action for Frontmost_application_if condition

1;

__END__

=head1 OVERVIEW

Provide overview of who the intended audience is for the module and why it's useful.

=head1 SYNOPSIS

  use JSON::Karabiner;

=head1 DESCRIPTION

=method method1()



=method method2()



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
