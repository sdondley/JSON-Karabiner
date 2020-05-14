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

=head1 SYNOPSIS

  use JSON::Karabiner;

  # first, create the condition object
  my $variable_cond_obj = $manip_obj->add_condition('variable_if');

  # next, add data to it
  $variable_cond_obj->add_variable('some_var_name' => 'some_value')

=head1 DESCRIPTION

Condtions make the C<from> and C<to> actions conditional upon the values of other
data. This gives you more control over when and under what environments your actions
will occur. Below is an overview of how to set the conditions available to you
via Karabiner.

Note that the condition objects must be created before you can add data to them.
See the example in the Synopsis above.

=head3 'device_if' and 'device_unless'

  $device_condition_obj->add_identifier('vendor_id' => 5, 'product_id' => 2222);
  $device_condition_obj->add_identifier('vendor_id' => 6, 'product_id' => 2223);
  $device_condition_obj->add_description('some description');

See L<Karabiner official documentation|https://karabiner-elements.pqrs.org/docs/json/complex-modifications-manipulator-definition/conditions/device/>

=head3 'event_changed_if' and 'event_chaned_unless'

  $event_condition_obj->add_value( 'true' );
  $event_condition_obj->add_description('some description');

See L<Karabiner official documentation|https://karabiner-elements.pqrs.org/docs/json/complex-modifications-manipulator-definition/conditions/event-changed/>

=head3 'frontmost_application_if' and 'frontmost_application_unless'

  $fm_app_obj->add_bundle_identifiers( 'bundle_id_one', 'bundle_id_two');
  $fm_app_obj->add_file_paths( 'file_path1', 'file_path2');
  $fm_app_obj->add_description('some description');

See L<Karabiner official documentation|https://karabiner-elements.pqrs.org/docs/json/complex-modifications-manipulator-definition/conditions/frontmost-application/>

=head3 'input_source_if', and 'input_source_unless'

  $input_source_obj->add_input_source('language' => 'languare regex', 'input_source_id' => 'input source id regex');
  $input_source_obj->add_input_source('language' => 'languare regex', 'input_source_id' => 'input source id regex');
  $input_source_obj->add_description('some description');

See L<Karabiner official documentation|https://karabiner-elements.pqrs.org/docs/json/complex-modifications-manipulator-definition/conditions/input-source/>

=head3 'keyboard_type_if', and 'keyboard_type_unless'

  $keybd_condition_obj->add_keyboard_types('keybd_type1', 'keybd_type2')
  $keybd_condition_obj->add_description('some description')

See L<Karabiner official documentation|https://karabiner-elements.pqrs.org/docs/json/complex-modifications-manipulator-definition/conditions/keyboard-type/>

=head3 'variable_if', and 'variable_unless'

  $var_cond_obj->add_variable('variable_name' => 'value');

See L<Karabiner official documentation|https://karabiner-elements.pqrs.org/docs/json/complex-modifications-manipulator-definition/conditions/variable/>
