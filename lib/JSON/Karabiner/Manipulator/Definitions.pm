package JSON::Karabiner::Manipulator::Definitions ;

use strict;
use warnings;
use JSON;
use Carp;

my @modifiers =  qw (caps_lock left_command left_control left_option left_shift right_command right_control right_option right_shift fn command control option shift left_alt left_gui right_alt right_gui) ;

my %definitions = (
  type => { type => 'value', allowed_values => [ 'basic', 'mouse_motion_to_scroll' ], default => 'basic', required => 1 },
  from => { required => 1,
            type => 'hash',
            allowed_keys => { key_code          => {type => 'value'},
                              consumer_key_code => {type => 'value'},
                              pointing_button   => {type => 'value'},
                              any               => {type => 'value'},
                              modifiers         => {type => 'hash', allowed_keys => { mandatory => { type => 'array', allowed_values => \@modifiers },
                                                                                      optional =>  { type => 'array', allowed_values => \@modifiers } } },
                              simultaneous      => {type => 'array', required => 0,
                                                    allowed_values => { type => 'hash',
                                                      allowed_keys => { 'key_code' => { type => 'value' },
                                                                        'consumer_key_code' => { type => 'value' },
                                                                        'any' => { type => 'value' },
                                                                        'pointing_button' => { type => 'value' } } } },
                              simultaneous_options => { type => 'hash', required => 0, allowed_keys => { detect_key_down_uinterruptedly => { type => 'value' },
                                                                                                         key_down_order => { type => 'value'},
                                                                                                         key_up_when => { type => 'value' },
                                                                                                         to_after_key_up => { type => 'value'  } } } } },
  to   => { type => 'array',
            allowed_values => { type => 'hash',
                                allowed_keys => {
                                  key_code          => { type => 'value' },
                                  consumer_key_code => { type => 'value' },
                                  pointing_button   => { type => 'value' },
                                  shell_command     => { type => 'value' },
                                  select_input_source => { type => 'hash', allowed_keys => { language => { type => 'value' }, input_source_id => { type => 'value' }, input_mode_id => { type => 'value' } } },
                                  set_variable => { type => 'hash', allowed_keys => { name => { required => 1 }, value => { required => 1 } } },
                                  mouse_key => { allowed_keys => {
                                              x => {type => 'value'},
                                              y => {type => 'value'},
                                              vertical_wheel => { type => 'value'},
                                              horizontal_wheel => { type => 'value' },
                                              speed_multiplier => { type => 'value' } } },
                                  modifiers => { type => 'array', allowed_values => \@modifiers },
                                  lazy => { type => 'boolean' },
                                  repeat => { type => 'boolean' },
                                },
                              }
          } );




sub new {
  my $class = shift;
  my $type = shift;
  my $parent = shift;
  my @keys = keys %definitions;
  croak "Not an allowed manipulator definition. Must be one of " . join ' ', @keys if ! grep { $type eq $_ } @keys;
  my $definition_type = $definitions{$type}->{type};
  my $value;
  if ($definition_type eq 'hash') {
    $value = {};
  } elsif ($definition_type eq 'array') {
    $value = [];
  } else {
    $value = '';
  }

  my @allowed_keys =  keys %{$definitions{$type}->{allowed_keys}};
  my $allowed_value_type = $definitions{$type}->{allowed_values}{type};
  my $self = {
    $type => $value,
    def_name => $type,
    type => $definitions{$type}->{type},
    allowed_keys => $definitions{$type}->{type} eq 'hash' ? \@allowed_keys : '',
    allowed_values_type => $allowed_value_type,
    required => $definitions{$type}->{required},
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

  my $type = $s->{def_name};
  if ($type ne 'to' and $type ne 'from') {
    croak 'Cannot add key_code property to this definition';
  }

  if ($type eq 'to') {
    $s->_is_exclusive($input_type);

    foreach my $key_code (@key_codes) {
      my %hash;
      my $letter_code;
      my $ms;
      if ($key_code =~ /-([A-Z])|(\d+)$/) {
        $letter_code = $1;
        $ms = $2;
        $key_code =~ s/-(.*?)$//;
      }

      $hash{$input_type} = $key_code;
      $hash{lazy} = JSON::true if $letter_code && $letter_code eq 'L';
      $hash{halt} = JSON::true if $letter_code && $letter_code eq 'H';
      $hash{repeat} = JSON::true if $letter_code && $letter_code eq 'R';
      $hash{hold_down_milliseconds} = $ms if $ms;
      push @{$s->{to}}, \%hash;
      $s->{last_key_code} = \%hash;
    }
  }

  if ($type eq 'from') {
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
    if (exists $s->{$type}{$input_type}) {
      croak 'From definition already has that property';
    }
    $s->{from}{$input_type} = $key_codes[0];
  }

  $s->{code_set} = 1 if $type eq 'from';
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

sub add_any {
  my $s = shift;
  if ($s->{def_name} eq 'to') {
    croak 'Any is not a valid property for this definition';
  }
  croak 'You must pass a value' if !$_[0];
  $s->add_key_code(@_, 'any');
}

sub _is_exclusive {
  my $s = shift;
  my $property = shift;
  croak 'No property passed' unless $property;
#  my $is_exclusive = !grep { !$s->{$_} unless $_ eq $property } qw(shell_command select_input_source set_variable mouse_key consumer_key_code pointing_button key_code);
#  croak 'Property already set that conflicts with the propert you are trying to set' unless $is_exclusive;
  $s->{$property} = 1;
}

sub add_shell_command {
  my $s = shift;
  my $type = $s->{def_name};
  if ($type ne 'to') {
    croak "Cannot add a shell_command to this definition";
  }

  $s->_is_exclusive('shell_command');
  my $value = shift;
  my %hash;
  $hash{shell_command} = $value;
  push @{$s->{to}}, \%hash;
}

sub add_select_input_source {
  my $s = shift;
  my $type = $s->{def_name};
  if ($type ne 'to') {
    croak "Cannot add a select_input_source to this definition";
  }
  $s->_is_exclusive('select_input_source');
  my $option = shift;
  my $value = shift;
  if ($option !~ /^language|input_source_id|input_mode_id$/) {
    croak "Invalid option: $option";
  }

  #TODO: determing if key alredy exists
  # find existing hash ref
  my $existing;
  foreach my $to_value ( @{$s->{to}} ) {
    if ($to_value->{select_input_source}) {
      $existing = $to_value->{select_input_source};
      last;
    }
  }
  my $select_input_source = $existing || { };

  $select_input_source->{$option} = $value;
  push @{$s->{to}}, { select_input_source => $select_input_source } if !$existing;
}

sub add_set_variable {
  my $s = shift;
  my $type = $s->{def_name};
  if ($type ne 'to') {
    croak "Cannot add a set_variable to this definition";
  }
  $s->_is_exclusive('set_variable');
  my $name = shift;
  croak 'No name passed' unless $name;
  my $value = shift;
  croak 'No value passed' unless $value;

  my %hash;
  $hash{set_variable}{name} = $name;
  $hash{set_variable}{value} = $value;
  push @{$s->{to}}, \%hash;
}

sub add_mouse_key {
  my $s = shift;
  my $type = $s->{def_name};
  if ($type ne 'to') {
    croak "The mouse_key property is not available for this definition";
  }
  $s->_is_exclusive('mouse_key');
  my $name = shift;
  croak 'No name passed' unless $name;
  my $value = shift;
  croak 'No value passed' unless $value;

  #TODO: make sure $names have not been set already
  #TODO: make sure names are valid
  my %hash;
  $hash{mouse_key}{$name} = $value;
  push @{$s->{to}}, \%hash;
}

sub add_modifiers {
  my $s = shift;
  my $type = $s->{def_name};
  if ($type ne 'to') {
    croak "The 'modifiers' property is not available for this definition";
  }
  my $lkc = $s->{last_key_code};
  croak 'Nothing to attach the modifiers to' if !$lkc;
  my $existing = [];
  if (exists $lkc->{modifiers} ) {
    $existing = $lkc->{modifiers};
  }

  #TODO: check that modifiers are valid
  my @modifiers = @_;
  use Data::Dumper qw(Dumper);
  push @$existing, @modifiers;
  $lkc->{modifiers} = $existing;
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
  my $type = $s->{def_name};
  if ($type ne 'from') {
    croak "Cannot add $mod_type modifiers to this definition";
  }
  croak "This definition already has $mod_type modifiers" if $s->{"has_${mod_type}_modifiers"};

  $s->{$type}{modifers}{$mod_type} = \@_;
  $s->{"has_${mod_type}_modifiers"} = 1;
}

sub add_simultaneous {
  my $s = shift;
  my @keys = @_;
  my $key_type = shift @keys if $keys[0] =~ /key_code|pointing|any/i;
  my $type = $s->{def_name};
  if ($type ne 'from') {
    croak "Cannot add simultaneous property to this definition";
  }
  my @hashes;
  if (defined $s->{$type}{simultaneous}) {
    @hashes = @{$s->{$type}{simultaneous}};
  }
  foreach my $key ( @keys ) {
    push @hashes, { $key_type || 'key_code' => $key };
  }
  $s->{$type}{simultaneous} =  \@hashes ;
}

sub add_simultaneous_options {
  my $s = shift;
  my $type = $s->{def_name};
  if ($type ne 'from') {
    croak "Cannot add simultaneous property to this definition";
  }
  my $option = shift;
  my @values = @_;
  my @allowed_options = keys %{$definitions{from}->{allowed_keys}{simultaneous_options}{allowed_values}{allowed_keys}};
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


sub add_definition {
  my $s = shift;
  my ($type, $value) = @_;

}

sub TO_JSON {
  my $obj = shift;
#  use Data::Dumper qw(Dumper);
#  print Dumper $obj;
  my $name = $obj->{def_name};
  my $value = $obj->{$name};
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
