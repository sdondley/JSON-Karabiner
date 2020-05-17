use Carp;

my $script_dir = 'xt/karabiner_generator-scripts/';

sub run_script {
  my $script = shift;

  my $failed = system($script_dir . $script);
  croak "Failed to run generator script: $?" if $failed;

}
