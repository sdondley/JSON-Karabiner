package JSON::Karabiner::Manipulator::Definitions::To ;

use strict;
use warnings;
use JSON;
use Carp;
use parent 'JSON::Karabiner::Manipulator::Definitions';

sub new {
  my $class = shift;
  my ($type, $value) = @_;
  my $obj = $class->SUPER::new($type, $value);
  $obj->{data} = $value || [],
  $obj->{shell_command} => 0,
  $obj->{select_input_source} => 0,
  $obj->{select_input_source_data} => '',
  $obj->{set_variable} => 0,
  $obj->{mouse_key} => 0,
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
    $s->_push_data(\%hash);
    $s->{last_key_code} = \%hash;
  }
}

sub _push_data {
  my $s = shift;
  my $data = shift;
  if ($s->{def_name} eq 'to_delayed_action') {
    if ($s->{delayed_type} eq 'invoked') {
      push @{$s->{data}{to_if_invoked}}, $data;
    } else {
      push @{$s->{data}{to_if_canceled}}, $data;
    }
  } else {
    push @{$s->{data}}, $data;
  }
}

sub add_shell_command {
  my $s = shift;

  $s->_is_exclusive('shell_command');
  my $value = shift;
  my %hash;
  $hash{shell_command} = $value;
  $s->_push_data(\%hash);
}

sub add_select_input_source {
  my $s = shift;
  $s->_is_exclusive('select_input_source');
  my $option = shift;
  my $value = shift;
  if ($option !~ /^language|input_source_id|input_mode_id$/) {
    croak "Invalid option: $option";
  }

  #TODO: determing if key alredy exists
  # find existing hash ref
  my $existing = $s->{select_input_source_data};
  my $select_input_source = $existing || { };

  $select_input_source->{$option} = $value;
  $s->_push_data( { select_input_source => $select_input_source } ) if !$existing;
}

sub add_set_variable {
  my $s = shift;
  $s->_is_exclusive('set_variable');
  my $name = shift;
  croak 'No name passed' unless $name;
  my $value = shift;
  croak 'No value passed' unless $value;

  my %hash;
  $hash{set_variable}{name} = $name;
  $hash{set_variable}{value} = $value;
  $s->_push_data(\%hash);
}

sub add_mouse_key {
  my $s = shift;
  $s->_is_exclusive('mouse_key');
  my $name = shift;
  croak 'No name passed' unless $name;
  my $value = shift;
  croak 'No value passed' unless $value;

  #TODO: make sure $names have not been set already
  #TODO: make sure names are valid
  my %hash;
  $hash{mouse_key}{$name} = $value;
  $s->_push_data(\%hash);
}

sub add_modifiers {
  my $s = shift;
  my $lkc = $s->{last_key_code};
  croak 'Nothing to attach the modifiers to' if !$lkc;
  my $existing = [];
  if (exists $lkc->{modifiers} ) {
    $existing = $lkc->{modifiers};
  }

  #TODO: check that modifiers are valid
  my @modifiers = @_;
  push @$existing, @modifiers;
  $lkc->{modifiers} = $existing;
}


# ABSTRACT: To definition

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
