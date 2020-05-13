package JSON::Karabiner::Manipulator::Conditions ;

use strict;
use warnings;
use JSON;
use Carp;


sub new {
  my $class = shift;
  my $type = shift;

  my $self = {
    def_name => $type,

  };
  bless $self, $class;
  return $self;
}

sub TO_JSON {
  my $obj = shift;
  use Data::Dumper qw(Dumper);
  my $name = $obj->{def_name};
  my $value = $obj->{data};
  my @data_hash = @{$obj->{data}};
  my %super_hash = ();
  foreach my $hash (@data_hash) {
    my %hash = %$hash;
    %super_hash = (%super_hash, %hash);
  }
  %super_hash = (%super_hash, type => $name);
  return { %super_hash };

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
