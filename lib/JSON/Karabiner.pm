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
  my $json = $s->_get_json();
  use Data::Dumper qw(Dumper);
  print Dumper $json;

  #TODO ensure it works with utf8
  open (FH, '>', $destination) or die 'Could not open file for writing.';
  print FH $json;
  close FH;
}

sub _get_json {
  my $s = shift;
  my $json = JSON->new();
  $json = $json->convert_blessed();
  return $json->pretty->encode($s->{_karabiner});
}

sub add_rule {
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

sub _check_if_file_exits {

}

sub _dump_json {
  my $s = shift;
  use Data::Dumper qw(Dumper);
  my $json = JSON->new();
  $json = $json->convert_blessed();
  print Dumper $json->pretty->encode($s->{_karabiner});
}


# ABSTRACT: easy JSON code generaation for Karabiner-Elements

1;

__END__

=head1 OVERVIEW

Write and generte Karabiner json effortlessly using a simple Perl script.

Karabiner is a MacOS application for modifying key and button strokes.

=head1 INSTALLATION

We recommend installing with the C<cpanm> command line command. If it's installed,
simply run:

  cpanm JSON::Karabiner

If C<cpanm> is not installed, read and L<follow these instructions|https://metacpan.org/pod/App::cpanminus#INSTALLATION> to install it on your Mac.

Also see L<How to install CPAN modules|https://www.cpan.org/modules/INSTALL.html> for other options.

=head1 SYNOPSIS

Below is an example of an executable perl script for generating a json file for
use by Karbiner-Elements. Hopefully it is simple enough to understand even if you
have no experience with programming in Perl. Don't hesitate to get in touch though this project's
L<GitHub repository|https://github.com/sdondley/JSON-Karabiner> if you need asssistance.

  #!/usr/bin/env perl   # shebang line so this program is opened with perl interpreter
  use JSON::Karabiner;  # make sure this Perl package is installed on your machine

  use strict;    # always set these in perl for your
  use warnings;  # own sanity

  # create an object
  my $kb_obj = JSON::Karbiner->new('Give It a Title', 'my_awesome_karbiner_mod.json');

  # add a rule
  my $rule = $kb_obj->add_rule('My Rule Name Rules!');

  # add a manipulator
  my $manip_1 = $rule->add_manipulator;

  # add your actions to the manipulator
  my $from = $manip_1->add_action('from');
  my $to = $manip_1->add_action('to');

  # add stuff to the actions
  $from->add_key_code('period');
  $from->add_mandatory_modifier('control');

  $to->add_keycode('semicolon');
  my $cond = $to->add_condition('variable_if');
  $cond->add_variable('some_variable', '1');

  # you can add more manipulators easily
  my $manip_2 = $rule->add_manipulator

  # Now add your actions, condtions, parameters, etc. to the new $manip_2 below

  # When you are done, it's time to write your file:

  $kb_obj->write_file;

  # After this script is run a json file called C<my_awesome_karbiner_mod.json>
  # should now be sitting in the assets/complex_modifications directory.


=head1 DESCRIPTION

Karabiner stores rules for its modifications in a file using a data format
known as JSON which is painstaking to edit and create. JSON::Karbiner eases the
pain by writing the JSON for you while you write simple Perl code using the
methods outlined below. If you aren't familar with Perl, or programming at all,
don't worry. There are examples provided that you can follow so no programming
knowledge should be necessary.

A Karbiner JSON complex modification file stores the rules for modifying the keyboard
in a data structure called the "manipulators." Therefore, most of what you will
be writing is code to add data to the manipulator data structure. Then, you write
the JSON to a file and then load the rules you've written through the Kabrabiner-Elements
program.

Below are descriptions of the methods you use to write your Karbiner json file.
There are three important methods to know:

=over 4

=item add_action method: for adding the from/to actions to the Karbiner manipulator data structure

=item add_condition method: for adding condtions to the manipulator structure

=item add_parameters method: for adding parameters to the manipulator data structure

=back

It will be very helpful if you have a basic familiarity with the Karbiner manipulator
definition. See the L<Karabiner complex_modification manipulator documentation|https://karabiner-elements.pqrs.org/docs/json/complex-modifications-manipulator-definition/> for more information.

The documentation below is not exhaustive. You'll also need to consult the documenation
found at:

=over 4

=item L<from action|JSON::Karabiner::Manipulator::Actions::From>

=item L<to action|JSON::Karabiner::Manipulator::Actions::To>

=item L<conditions|JSON::Karabiner::Manipulator::Conditions>

But the best way to learn, of course, is to experiment and see what happens.

=head1 METHODS

Below are the methods for the Karabiner, Rule, and Manipulator classes.

=head2 Karabiner Object Methods

=head3 new($title, $file, { mod_file_dir => $path_to_dir } )

  my $kb_obj = JSON::Karbiner->new('title', 'file.json');

The new method creates an object that holds the entire data structure. This
should be the first command you issue in your scipt.

The $title and $file arguments are required. An optional third argument
can be passed to change the default Karbiner directory which is set to:

  ~/.config/karabiner/assets/complex_modifications/

If you are using a non-standard location for your Karbiner install, you must
change this directory to where Karbiner stores its modifications on your local machine
by setting the C<mod_file_dir> option to the path on your hard drive.

=head3 write_file()

This will generally be the last command in your script:

  $kb_obj->write();

Once the file is written, you should be able to add the rules from your script
using the Karbiner-Elements program. If it does not appear there, first check
to make sure the file is saving to the right directory. If it still doesn't work,
please open an issue on GitHub and post your perl script as it may be a bug.

=head3 add_rule($rule_name)

Every Karabiner json file has a rules data structure which contains all the
modifications. Add it to your object like so:

  my $rule = $kb_obj->add_rule('My Cool Rule');

=head2 Rule Methods

=head3 add_manipulator()

A manipulator must be added to the Rule object to do anything useful:

  my $manip = $rule->add_manipulator

Once done, you can add actions, conditions, and parameters to your manipulator. See
below for more information.

=head2 Manipulator Methods

=head3 add_action($type)

There are seven different types of actions you can add:

  my $from        = $manip->add_action('from');
  my $to          = $manip->add_action('to');
  my $to_alone    = $manip->add_action('to_if_alone');
  my $to_down     = $manip->add_action('to_if_held_down');
  my $to_up       = $manip->add_action('to_after_key_up');
  my $to_invoked  = $manip->add_action('to_delayed_if_invoked');
  my $to_canceled = $manip->add_action('to_delayed_if_canceled');

The major ones are the first four listed above. You must create a C<from> action to
your manipulator. This the actions that contains the keystrokes you want to change.
The other C<to> actions describe what the C<from> keystroke actions will be changed
into. See the Karbiner documentation for more information on these actions.

Once these actions are created, you may apply methods to them to add additional
data. Consult the documentation for the different actions for a listing and
description of those methods:

=over 4

=item L<JSON::Karabiner::Manipulator::Actions::From>

=item L<JSON::Karabiner::Manipulator::Actions::To>

=back

=head3 add_condition($type)

Conditions make the modification conditional upon some other bit of data. You
can add the following types of conditions:

  $manip->add_condition('device_if');
  $mainp->add_condition('device_unless')
  $manip->add_condition('event_changed_if')
  $manip->add_condition('frontmost_application_if')
  $manip->add_condition('frontmost_application_unless')
  $manip->add_condition('input_source_if')
  $manip->add_condition('input_source_unless')
  $manip->add_condition('keyboard_type_if')
  $manip->add_condition('variable_if')
  $manip->add_condition('variable_unless')

Consult the Karabiner documenation for more information on conditions. Once the conditions
are created, you can add data to them using methods. See the documenation for each of the type of
conditions and the types of methods they use:

L<JSON::Karabiner::Manipulator::Conditions>

=head3 add_parameter($name, $value)

Parameters are used by Karabiner to change various timing aspects of the actions. Four
different parameters may be set:

  $manip->add_parameter('to_if_alone_timeout_milliseconds', 500);
  $manip->add_parameter('to_if_held_down_threshold_milliseconds, 500);
  $manip->add_parameter('to_delayed_action_delay_milliseconds, 250);
  $manip->add_parameter('simultaneous_threshold_milliseconds, 50);

See the Karabiner documentation for more details.

=head3 add_description($description)

Adds a description to the manipulator data structure:

  $manip->add_description('This turns a period into a hyper key.');

=head1 Development Status

This module is currently in the early alpha stages and is actively supported and
maintained. Suggestion for improvement are welcome. It is known to generate
valid JSON that allow Karabinder to import rules from the file generated for
simple cases.

Many improvements are in the works.

=head1 BUGS AND LIMITATIONS

Though this software is still in an alpha state, it should be able to generate
code for any property with the exception of the C<to_after_key_up> key/value use
for the simultaneous options behavior due to uncertainty in how this should be
implemented. If you need this feature, generate your json code using this script
as you normally would and then manually edit it to insert the necessary json
code.

=head1 SEE ALSO

=over 4

=item L<Karabiner Elements Home Page|https://karabiner-elements.pqrs.org>

=item L<Karabiner Elements Reference Manual|Documentation>

=back
