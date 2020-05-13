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

sub TO_JSON {
  my $obj = shift;
  return $obj->{actions};
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
