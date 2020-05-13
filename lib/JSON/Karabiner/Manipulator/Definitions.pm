package JSON::Karabiner::Manipulator::Definitions ;

use strict;
use warnings;
use JSON;
use Carp;


sub new {
  my $class = shift;
  my $type = shift;
  my $parent = shift;

  my $self = {
    def_name => $type,
    parent => $parent,
    code_set => 0,
    has_mandatory_modifiers => 0,
    has_optional_modifiers => 0,
    shell_command => 0,
    select_input_source => 0,
    set_variable => 0,
    mouse_key => 0,
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
#  use Data::Dumper qw(Dumper);
#  print Dumper $obj;
  my $name = $obj->{def_name};
  my $value = $obj->{data};
  return { $name => $value };

  # return { %{ shift() } };
}

# ABSTRACT: turns baubles into trinkets

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
