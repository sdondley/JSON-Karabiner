package JSON::Karabiner::Manipulator::Actions::To_after_key_up ;

use strict;
use warnings;
use JSON;
use Carp;
use parent 'JSON::Karabiner::Manipulator::Actions::To';

sub new {
  my $class = shift;
  my ($type, $value) = @_;
  my $obj = $class->SUPER::new($type, $value);
  $obj->{data} = $value || [],
  return $obj;
}

# ABSTRACT: to_after_key_up action

1;

__END__

=head1 DESCRIPTION

INTENTIONALLY LEFT BLANK


