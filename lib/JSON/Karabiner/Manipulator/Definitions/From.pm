package JSON::Karabiner::Manipulator::Definitions::From ;

use strict;
use warnings;
use JSON;
use Carp;
use parent 'JSON::Karabiner::Manipulator::Definitions';


sub new {
  my $class = shift;
  my ($type, $parent, $value) = @_;
  my $obj = $class->SUPER::new($type, $parent);
  $obj->{data} = $value || {},
  return $obj;
}


sub add_key_code {
  my $s = shift;
  my @key_codes = @_;
  my $last_arg = $key_codes[-1];
  my $input_type = 'key_code';
  if ($last_arg && $last_arg =~ /^any|consumer_key_code|pointing_button$/) {
    $input_type = $last_arg;
    pop @key_codes;
  }
  croak 'No key code passed' if !@key_codes;
  croak 'You can only set one key_code, consumer_key_code, pointing_button or any'  if ($s->{code_set});
  #TODO: validate $key_code

  if (scalar @key_codes > 1) {
    croak 'Only one input type can be entered for "from" defintions';
  }
  my ($letter_code, $ms);
  if ($key_codes[0] =~ /-([A-Z])|(\d+)$/) {
    $letter_code = $1;
    $ms = $2;
  }
  croak 'Specifiers such as lazy, repeat, halt, and hold_down_in_milliseconds do not apply in "from" defintions'
    if $letter_code || $ms;
  if (exists $s->{data}{$input_type}) {
    croak 'From definition already has that property';
  }
  $s->{from}{$input_type} = $key_codes[0];

  $s->{code_set} = 1;
}

sub add_any {
  my $s = shift;
  croak 'You must pass a value' if !$_[0];
  $s->add_key_code(@_, 'any');
}

sub add_optional_modifiers {
  my $s = shift;
  $s->_add_modifiers('optional', @_);
}

sub add_mandatory_modifiers {
  my $s = shift;
  $s->_add_modifiers('mandatory', @_);
}

sub _add_modifiers {
  my $s = shift;
  my $mod_type = shift;
  my $values = \@_;
  croak "This definition already has $mod_type modifiers" if $s->{"has_${mod_type}_modifiers"};

  $s->{data}{modifers}{$mod_type} = \@_;
  $s->{"has_${mod_type}_modifiers"} = 1;
}

sub add_simultaneous {
  my $s = shift;
  my @keys = @_;
  my $key_type = shift @keys if $keys[0] =~ /key_code|pointing|any/i;
  my @hashes;
  if (defined $s->{data}{simultaneous}) {
    @hashes = @{$s->{data}{simultaneous}};
  }
  foreach my $key ( @keys ) {
    push @hashes, { $key_type || 'key_code' => $key };
  }
  $s->{data}{simultaneous} =  \@hashes ;
}

sub add_simultaneous_options {
  my $s = shift;
  my $option = shift;
  my @values = @_;
  my @allowed_options = qw ( detect_key_down_uinterruptedly
                             key_down_order key_up_when to_after_key_up );
  my $exists = grep { $_ = $option } @allowed_options;
  croak "Simultaneous option is not a valid option" if $exists;
  my $value = $values[0];

  #TODO: detect if option already exists and die if it does
  #TODO: offer suggestions if error thrown
  croak "Simultaneous option $option has already been set" if ($s->{"so_${option}_is_set"} == 1);

  if ($option eq 'detect_key_down_uinterruptedly') {
    if ($value !~ /true|false/) {
      croak "$value is not a valid option for $option";
    }
  } elsif ($option eq 'key_down_order' || $option eq 'key_up_order') {
    if ($value !~ /insenstive|strict|strict_inverse/) {
      croak "$value is not a valid option for $option";
    }
  } elsif ($option eq 'key_up_when') {
    if ($value !~ /any|when/) {
      croak "$value is not a valid option for $option";
    }
  } elsif ($option eq 'to_after_key_up') {
    #TODO: Figure out how this is supposed to work
    croak 'This option is currently unspported by JSON::Karabiner';
  }

  $s->{"so_${option}_is_set"} = 1;

}

# ABSTRACT: From defintion

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
