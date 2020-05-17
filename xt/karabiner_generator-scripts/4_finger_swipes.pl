#! /usr/bin/env perl

use JSON::Karabiner::Manipulator;

new_manipulator 'Double tap left-shift to swipe right', '4_finger_swipes.json';

add_action    'from';
add_key_code  'left_shift';

add_action    'to';
add_key_code  'left_arrow';
add_modifiers 'shift', 'control';

add_condition 'variable_if';
add_variable  'left_shift pressed', 1;

write_file('4 finger swipes');


new_manipulator 'Double tap left-shift to swipe right', '4_finger_swipes.json';

add_action        'from';
add_key_code      'left_shift';

add_action        'to';
add_set_variable  'left_shift pressed', '1';
add_key_code      'left_shift';

add_action        'to_delayed_if_invoked';
add_set_variable  'left_shift pressed', '0';

add_action        'to_delayed_if_canceled';
add_set_variable  'left_shift pressed', '0';

write_file();
