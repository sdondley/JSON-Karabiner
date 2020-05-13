package JSON::Karabiner ;

use strict;
use warnings;
use JSON;
use Carp;
use JSON::Karabiner::Rule;

sub new {
  my $class = shift;
  my $title = shift;
  my $file = shift;
  my $opts = shift;

  if ($opts) {
    if (ref $opts ne 'HASH') {
      croak 'Options must be passed as a hash reference.';
    }
  }
  croak 'JSON::Karabiner constructor requires a title for the modification.' if !$title;
  croak 'JSON::Karabiner constructor requires a file name.' if !$file;
  croak 'File names are required to have a .json extenstion' if $file !~ /\.json$/;
  my $self = {
    _file => $file,
    _mod_file_dir => $opts->{mod_file_dir} || "$ENV{HOME}/.config/karabiner/assets/complex_modifications/",
    _karabiner => { title => $title, rules => [] },
  };
  bless $self, $class;
  return $self;
}

sub write_file {
  my $s = shift;
  my $file = $s->{_file};
  my $dir = $s->{_mod_file_dir};
  my $destination = $dir . $file;
  my $json = $s->get_json();
  use Data::Dumper qw(Dumper);
  print Dumper $json;

  #TODO ensure it works with utf8
  open (FH, '>', $destination) or die 'Could not open file for writing.';
  print FH $json;
  close FH;
}

sub get_json {
  my $s = shift;
  my $json = JSON->new();
  $json = $json->convert_blessed();
  return $json->pretty->encode($s->{_karabiner});
}

sub create_rule {
  my $s = shift;
  my $desc = shift;
  croak "No description passed to rule." if !$desc;
  my $rule = JSON::Karabiner::Rule->new($desc);
  $s->_add_rule($rule);
  return $rule;
}

sub _add_rule {
  my $s = shift;
  my $rule = shift;
  push @{$s->{_karabiner}{rules}}, $rule;
}

sub check_if_file_exits {

}

sub _dump_json {
  my $s = shift;
  use Data::Dumper qw(Dumper);
  my $json = JSON->new();
  $json = $json->convert_blessed();
  print Dumper $json->pretty->encode($s->{_karabiner});
}


# ABSTRACT: easy JSON code generaation for Karbiner-Elements

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
