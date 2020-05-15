package JSON::Karabiner ;

use strict;
use warnings;
use JSON;
use Carp;
use File::HomeDir;
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
  my $home = File::HomeDir->my_home;
  my $self = {
    _file => $file,
    _mod_file_dir => $opts->{mod_file_dir} || "$home/.config/karabiner/assets/complex_modifications/",
    _karabiner => { title => $title, rules => [] },
    _fake_write_flag => 0,
    _rule_obj => '',
  };
  if (!-d $self->{_mod_file_dir}) {
    if ($opts->{mod_file_dir}) {
      croak "The directory you attempted to set with the 'mod_file_dir' option does not exist.\n\n";
    } else {
      croak "The default directory for storing complex modifications does not exist. Do you have Karabiner-Elements installed? Is it installed with a non-standard configuration? Try setting the location of the directory manually with the 'mod_file_dir' option. Consult this module's documentation for more information with using the 'perldoc JSON::Karabiner' command in the terminal.\n\n" unless $ENV{HARNESS_ACTIVE};
    }
  }
  bless $self, $class;
  return $self;
}

# used by test scripts
sub _fake_write_file {
  my $s = shift;
  $s->{_fake_write_flag} = 1;
  $s->write_file;
  $s->{_fake_write_flag} = 0;
}

sub write_file {
  my $s = shift;
  my $using_dsl = ((caller(0))[0] eq 'JSON::Karabiner::Manipulator');
  my $file = $s->{_file};
  my $dir = $s->{_mod_file_dir};
  my $destination = $dir . $file;

  if ($using_dsl) {
    my $rule = $s->{_karabiner}{rules};
    if (!@main::saved_manips) {
      @main::saved_manips = ();
    }
    foreach my $r (@$rule) {
      foreach my $manip ($r->{manipulators}) {
        push @main::saved_manips, @{$manip};
      }
    }

    @{$s->{_karabiner}->{rules}} = @main::saved_manips;
  }

  my $json = $s->_get_json();

  #TODO ensure it works with utf8
  if (!$s->{_fake_write_flag}) {
    open (FH, '>', $destination) or die 'Could not open file for writing.';
    print FH $json;
    close FH;
  }

  print "Your rules were successfully written to:\n\n $destination.\n\nOpen Karabiner-Elements to import the new rules you have generated.\n\nIf your rules do not appear, please report the issue to our issue queue:\n\nhttps://github.com/sdondley/JSON-Karabiner/issues \n\n"
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
  $s->{_rule_object} = $rule;
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
  my $json = JSON->new();
  $json = $json->convert_blessed();

  # suppress validity tests
  $s->{_rule_object}->_disable_validity_tests();

  use Data::Dumper qw(Dumper);
  print Dumper $json->pretty->encode($s->{_karabiner});

  # renable validity tests
  $s->{_rule_object}->_enable_validity_tests();
}


# ABSTRACT: easy JSON code generation for Karabiner-Elements

1;

__END__

=head1 OVERVIEW

Write and generate Karabiner json effortlessly using a simple Perl script.

Karabiner is a MacOS application for modifying key and button strokes.

=head1 INSTALLATION

This software is written in Perl and bundled as a package called C<JSON::Karabiner>.
If you are not familiar with installing Perl packages, don't worry. Just follow
this simple two-step process:

=head3 Step 1: Ensure the C<cpanm> command is installed:

Run the following command from a terminal window:

  C<which cpanm>

If the terminal reponds with the path to C<cpanm>, proceed to Step 2.

If the C<cpanm> command is not installed, copy and paste one of the following
three commands into your terminal window to install it:

  # Option 1: Install to system Perl
  curl -L https://cpanmin.us | perl - --sudo App::cpanminus

  # Option 2: Install to local Perl (you must have a local version of Perl already installed)
  curl -L https://cpanmin.us | perl - App::cpanminus

  # Option 3: Install as standalone executable
  cd ~/bin && curl -L https://cpanmin.us/ -o cpanm && chmod +x cpanm

If you are unsure what the best option is for installing C<cpanm>, L<consult its
documentation for more
help.|https://metacpan.org/pod/App::cpanminus#INSTALLATION>.

=head3 Step 2: Install the C<JSON::Karabiner> package

Now issue the following comamdn to install the software:

  cpanm JSON::Karabiner

After issuing the C<cpanm> command above, you should see a success message. If so,
you can start using cpanm JSON::Karabiner and start using it in local Perl scripts
you write. If you get errors about lack of permissions, try running:

  sudo cpanm JSON::Karabiner

If you still get weird errors, it may be a bug. Please report your issue to the
L<issue queue|https://github.com/sdondley/JSON-Karabiner/issues>.

=head4 Other install methods

This module can also be installed using the older C<cpan> command that is
already on your Mac. See L<how to install CPAN
modules|https://www.cpan.org/modules/INSTALL.html> for more information.

=head1 SYNOPSIS

Below is an example of an executable perl script for generating a json file for
use by Karabiner-Elements. You can copy and paste this code to your local machine and
execute it. Feel free to modify it to your liking. Note that you must first
install the C<JSON::Karabiner> package (see the L</"INSTALLATION"> section below).

This script is easy to understand even if you have no experience with Perl or
any programming langauge, for that matter. Read through the code below and see
if you can determine what it will do. Don't hesitate to L<file an
issue|https://github.com/sdondley/JSON-Karabiner/issues> if you need
asssistance.

  #!/usr/bin/env perl                # shebang line so this program is opened with perl interpreter
  use JSON::Karabiner::Manipulator;  # The JSON::Karabiner Perl package must be installed on your machine

  # Create a new manipulator object with a description and the file you want to save it to
  new_manipulator('a-s-d to show character viewer', 'my_awesome_karabiner_mod.json');

  # Add a from action to the manipulator:
  add_action 'from';

  # Add behaviors to the action:
  add_simultaneous 'a', 's', 'd';
  add_optional_modifiers 'any';

  # Add a "to" action to the manipulator:
  add_action 'to';

  # Tell the "to" action what to do
  add_key_code('spacebar');
  add_modifiers('control', 'command');

  # Done! Now it's time to write the file and give the rule a title:
  write_file('Emoji Character Viewer');

Save this above code to a file on your computer and be sure to make the script executable with:

  chmod 744 your_file_name.pl

Then execute this script with:

  ./your_file_name.pl

from the same directory where this script is saved.

After this script is run, a json file called my_awesome_karabiner_mod.json
should now be sitting in the assets/complex_modifications directory. Open
the Karabiner-Elements app on your Mac to install the new rule.

Ready to give is try? Follow the L</"INSTALLATION"> instructions to get started.

=head1 DESCRIPTION

Karabiner stores rules for its modifications in a file using a data format
known as JSON which is painstaking to edit and create. JSON::Karabiner eases the
pain by letting Perl write the JSON for you. If you aren't familar with Perl, or
programming at all, don't worry. There are examples provided that you can follow
so no programming knowledge is necessary. The 10 or 20 minutes you spend
learning how to install and use this module will pay off in spades.

A Karabiner JSON complex modification file stores the rules for modifying the keyboard
in a data structure called the "manipulators." Therefore, most of methods you
write will add data to the manipulator data structure. C<JSON::Karabiner> can then
write the JSON to a file and then you can load the rules you've written using
the Kabrabiner-Elements program.

Below are descriptions of the methods used on manipulators.

=over 4

=item C<add_action> method

for adding the from/to actions to the manipulator

=item C<add_condition> method

for adding manipulator conditions

=item C<add_parameter> method

for adding maniplator parameters

=item C<add_description> method

for adding a description to the manipulator

=back

After running one of the four methods, the next step is to run additional methods
that will be applied to the last action or condition you added.

It will be very helpful if you have a basic familiarity with the Karabiner
manipulator definition to gain an understanding of which methods to run. See the
L<Karabiner complex_modification manipulator
documentation|https://karabiner-elements.pqrs.org/docs/json/complex-modifications-manipulator-definition/>
for more information.

=head2 DSL Interface

As of version 0.011, JSON::Karabiner moved to a DSL (domain specific language)
interface to make writing scripts exceedingly easy. Please see the L</SYNOPSIS> for an
example of how to use the DSL. Full documention of the DSL will be available
shortly. The older, object-oriented interface is still available below so it can be referred
until the new documentation is releases. Note that the older object-oriented
interface is still fully funcitonal (or should be, in theory).

=head2 How to Use the DSL Interface

There are two parts to the inteface: the method and the list of arguments you are
passing to the method. Methods that add data to the Karabiner json file begin with
C<add_> followed by a string of characters that corresponds to properties outlined
in the Karabiner documentation. For example, to add a C<key_code> property, you write:

  add_key_code('t');

It bears repeating that methods that apply to actions (or condtions) are automatically
assigned to the B<last action (or condition) that was created>.
In other words, if your have:

  add_action 'to';
  add_action 'from';
  add_key_code 'x';

The key code will be added to the C<from> action. If you wish apply it to the C<to>
action, simply move the C<add_key_code> line immediately after the C<to> action. This
same rule applies for condtions as well as actions. Any method that adds data
to a condtion will get added to the last condition created.

=head3 List of Methods for Actions

The following methods apply to actions (e.g. C<from>, C<to>, C<to_if_alone> etc.)

=head4 From methods

The following methods are for the C<from> action:

=over 4

=item add_any

=item add_consumer_key_code

=item add_key_code

=item add_mandatory_modifiers

=item add_optional_modifiers

=item add_pointing_button

=item add_simultaneous

=item add_simultaneous_options


=back

=head4 To methods

The following methods are for the C<to> action (includes C<to_if_alone>, C<to_if_held_down>
C<to_after_key_up>, C<to_delayed_if_invoked>, C<to_delayed_if_canceled>):

=over 4

=item add_consumer_key_code

=item add_key_code

=item add_modifiers

=item add_mouse_key

=item add_pointing_button

=item add_select_input_source

=item add_set_variable

=item add_shell_command

=back

=head4 Condition methods

=over 4

=item add_bundle_identifiers

=item add_description

=item add_file_path

=item add_identifier

=item add_input_source

=item add_keyboard_types

=item add_value

=item add_variable

=back

For further details on each these methods, including the arguments they take,
please see that appropriate perl doc page:

=over 4

=item L<from action|JSON::Karabiner::Manipulator::Actions::From>

=item L<to action|JSON::Karabiner::Manipulator::Actions::To>

=item L<conditions|JSON::Karabiner::Manipulator::Conditions>

=back

=head3 Multiple manipulators

The DSL interface makes it easy to include multiple manipulator in a single rule.
Follow this patter:

  new_manipulator('Turn x key into y key', 'name_of_file.json');

  ... Run methods for above manipulator here ...

  write_file('Name of Rule');

  new_manipulator('Turn a key into by key', 'name_of_file.json');

  ... Run methods for the second manipulator here ...

  write_file('');

  ... Add N more manipulators here ...

Just be sure the manipulators all have the same file name so they will be
included in the same file.

Notice that only the first C<write_file> method requires the name of the rule
to be passed. Subsequent calls to C<write_file> will inherit the title from
the first manipulator written.

=head3 Writing the JSON

As shown in the example above, a C<write_file> call must be made for each
manipulator in your script to have it included in the JSON file. The title is
required to be supplied to the first manipulator. Subsequent C<write_file>
calls will use the first title.

=head1 METHODS

Below are the methods for the Karabiner, Rule, and Manipulator classes. The
classes are used to create objects that you then run methods on.

Together, these methods create one large data structure that gets written to
the json file. A good way to get a feel for how this works is to write just a
little bit of Perl code, write it to a file, and then look at the file. Then add
a little bit more Perl code, run the script again, and see what happens. You can
also add the undocumented C<_dump_json> method to your script to spit
out the current state of your json without writing it to a file.

The new DSL Interface, as demonstrated in the L</SYNOPSIS>, should be used instead
of the old object-oriented interface.

=head2 DEPRECATED Object-Oriented Interface

=head3 Karabiner Object Methods DEPRECATED

=head4 new($title, $file, [ { mod_file_dir => $path_to_dir } ] )

  my $kb_obj = JSON::Karabiner->new('title', 'file.json');

The new method creates the Karabiner object that holds the entire data structure.
This should be the first command you issue in your scipt.

The $title and $file arguments are required. An optional third argument, set
inside curly braces, can be passed to change the default Karabiner directory
which is set to:

  ~/.config/karabiner/assets/complex_modifications/

You must pass this third argument inside the curly brackes as shown in this example:

  my $kb_obj = JSON::Karabiner->new('title', 'file.json', { mod_file_dir => '/path/to/dir' } ));

If you are using a non-standard location for your Karabiner install, you must
change this directory to where Karabiner stores its modifications on your local
machine by setting C<mod_file_dir> option to the correct path on your drive.

Note: Thie method is DEPRECATED in favor of the new DSL approach (see the
exmaple in SYNOPSI).

=head4 write_file() DEPRECATED

This will generally be the last command in your script:

  $kb_obj->write_file();

Once the file is written, you should be able to add the rules from your script
using the Karabiner-Elements program. If it does not appear there, first check
to make sure the file is saving to the right directory. If it still doesn't work,
please open an issue on GitHub and post your perl script as it may be a bug.

Note: Thie method is DEPRECATED in favor of the new DSL approach (see the
example in the SYNOPSIS).

=head4 add_rule($rule_title) DEPRECATED

Every Karabiner json file has a rules data structure which contains all the
modifications. Add it to your object like so:

  my $rule = $kb_obj->add_rule('My Cool Rule Title');

Set the title of the rule by passing it a string set in quotes.

Note: Thie method is DEPRECATED in favor of the new DSL approach (see the
example in the SYNOPSIS).

=head4 Rule Methods DEPRECATED

=head4 add_manipulator() DEPRECATED

A manipulator must be added to the Rule object to do anything useful:

  my $manip = $rule->add_manipulator

Once done, you can add actions, conditions, and parameters to your manipulator. See
below for more information.

=head3 Manipulator Methods DEPRECATED

=head4 add_action($type) DEPRECATED

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
into. See the Karabiner documentation for more information on these actions.

Once these actions are created, you may apply methods to them to add additional
data. Consult the documentation for the different actions for a listing and
description of those methods:

=over 4

=item L<JSON::Karabiner::Manipulator::Actions::From>

=item L<JSON::Karabiner::Manipulator::Actions::To>

=back

=head3 add_condition($type) DEPRECATED

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

=head4 add_parameter($name, $value) DEPRECATED

Parameters are used by Karabiner to change various timing aspects of the actions. Four
different parameters may be set:

  $manip->add_parameter('to_if_alone_timeout_milliseconds', 500);
  $manip->add_parameter('to_if_held_down_threshold_milliseconds, 500);
  $manip->add_parameter('to_delayed_action_delay_milliseconds, 250);
  $manip->add_parameter('simultaneous_threshold_milliseconds, 50);

See the Karabiner documentation for more details.

=head4 add_description($description) DEPRECATED

Adds a description to the manipulator data structure:

  $manip->add_description('This turns a period into a hyper key.');

=head1 Development Status

This module is currently in alpha release and is actively supported and
maintained. Suggestion for improvement are welcome. It is known to generate
valid JSON that allow Karabiner to import rules from the file generated for at
least simple cases and probably more advanced cases as well.

Many improvements are in the works. Please watch us on GitHub.

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
