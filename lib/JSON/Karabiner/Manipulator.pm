package JSON::Karabiner::Manipulator ;

use strict;
use warnings;
use Carp;

sub new {
  my $class = shift;
  my $self = { actions => {} };
  bless $self, $class;
  return $self;
}

sub add_action {
  my $s = shift;
  my $type = shift;
  croak 'To add a action, you must tell me which kind you\'d like to add' if !$type;

  my $uctype = ucfirst($type);
  my $package = "JSON::Karabiner::Manipulator::Actions::" . $uctype;
  eval "require $package";
  my $action = $package->new($type);
  my %hash = %{$s->{actions}};
  $type = $action->{def_name};
  $hash{$type} = $action->{data};
  $s->{actions} = \%hash;
  return $action;
}

sub add_condition {
  my $s = shift;
  my $type = shift;
  croak 'To add a condition, you must tell me which kind you\'d like to add' if !$type;

  my $uctype = ucfirst($type);
  my $package = "JSON::Karabiner::Manipulator::Conditions::" . $uctype;
  eval "require $package";
  my $condition = $package->new($type);
  if (defined $s->{actions}{conditions}) {
    push @{$s->{actions}{conditions}}, $condition;
  } else {
    $s->{actions}{conditions} = [ $condition ];
  }
  return $condition;
}

sub add_description {
  my $s = shift;
  my $desc = shift;

  croak 'To add a description, you must provide one' if !$desc;
  $s->{actions}{description} = $desc;
}

sub add_parameter {
  my $s = shift;
  my $param = shift;
  my $value = shift;
  croak 'To add a parameter, you must tell me which kind you\'d like to add' if !$param;
  croak 'To add a parameter, you must provide a value' if !$value;

  my @acceptable_values = qw( to_if_alone_timeout_milliseconds
                              alone_timeout
                              alone
                              to_if_held_down_threshold_milliseconds
                              held_down_threshold
                              down_threshold
                              held_down
                              down
                              to_delayed_action_delay_milliseconds
                              delayed_action_delay
                              action_delay
                              delay
                              simultaneous_threshold_milliseconds
                              simultaneous_threshold
                              simultaneous
                              );

  my $param_exists = grep { $param eq $_ } @acceptable_values;
  croak "'$param' in an unrecognzed parameter" unless $param_exists;

  # get param full name
  if ($param =~ /alone/) {
    $param = 'to_if_alone_timeout_milliseconds';
  } elsif ($param =~ /down/) {
    $param = 'to_if_held_down_threshold_milliseconds';
  } elsif ($param =~ /delay/) {
    $param = 'to_delayed_action_delay_milliseconds';
  } elsif ($param =~ /simultaneous/) {
    $param = 'simultaneous_threshold_milliseconds';
  }

  $s->{actions}{parameters}{"basic.$param"} = $value;
}

sub TO_JSON {
  my $obj = shift;
  #TODO: Change this under certain conditions
  $obj->{actions}{type} = 'basic';
  $obj->_do_validity_checks($obj->{actions});
  return $obj->{actions};
}

sub _do_validity_checks {
  use Data::Dumper qw(Dumper);
  my $s = shift;
  my $actions = shift;
  print Dumper $actions;
  my $from = $actions->{from};
  $s->_do_from_validity_checks($from);
}

sub _do_from_validity_checks {
  use Data::Dumper qw(Dumper);
  return;
  my $s = shift;
  my $from = shift;
  my @from_keys = keys %$from;
  my $has_key_code = grep { $_ =~ /^any|consumer_key_code|key_code$/ } @from_keys;
  print Dumper \@from_keys;
  if (!$has_key_code && grep { $_ =~ /modifiers/ } @from_keys) {
    print Dumper 'aksjdkajsdf';
    croak "You cannot have modifiers without anything to modify in a 'from' action.";
  }
}

# ABSTRACT: manipulator object for containing and outputting its data

1;

__END__

=head1 DESCRIPTION

Please see the L<JSON::Karabiner> for more thorough documentation of this module.
Methods are listed below for reference purposes only.

=head3 new()

=head3 add_action($type)

=head3 add_condition($type)

=head3 add_parameter($name, $value)

=head3 add_description($description)
