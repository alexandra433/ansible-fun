#!/usr/bin/perl

# Date: Dec 2024
# This script provides responses to the prompts in the read-input.sh script
# Created to practice using the perl expect module
# Parameters:
# - $favepie
# - $filename
#
# referenced stuff
# https://www.perlmonks.org/?node_id=786670
# https://metacpan.org/release/RGIERSIG/Expect-1.15/view/Expect.pod
# https://gist.github.com/tommybutler/6934497
use strict;
use warnings;
use Expect;

# my keyword restricts the scope of a variable
# without my, a global variable is created instead
my $command = '/home/admin/read-input.sh'; # using debian 12 ami from aws
my $timeout = 10;

# https://perlmaven.com/argv-in-perl
my ($favepie, $filename) = @ARGV;

if (not defined $favepie) {
  $favepie = "pecan";
}

if (not defined $filename) {
  $filename = "default.txt";
}

my $exp = Expect->new();
$exp->spawn($command)
  or die "Cannot spawn $command: $!\n";

$exp->expect($timeout,
  [ qr/pie\?/ => \&answerpie ],
  [ qr/nonexistent/ => \&nonexistent ],
  [ qr/Enter file.*:/ => \&enterfile ],
  [ timeout => \&timed_out ],
);

$exp -> soft_close();

# Subroutines

sub answerpie {
  my $exp = shift;
  $exp->clear_accum();
  $exp->send( "$favepie\n" );
  exp_continue;
}

sub enterfile {
  my $exp = shift;
  $exp->clear_accum();
  $exp->send( "$filename\n" );
  exp_continue;
}

# seeing what happens if try to match nonexistent line
sub nonexistent {
  my $exp = shift;
  $exp->clear_accum();
  $exp->send( "Huh\n" );
  exp_continue;
}

sub timed_out
{
  my $fail = qq(TIMEOUT!  Not what we EXPECT-ed);
  die $fail;
}