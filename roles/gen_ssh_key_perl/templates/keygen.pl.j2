#!/usr/bin/perl

# Date: Dec 2024
# This script generates an new ssh key ~/.ssh/id_rsa (overwriting an previous ones),
# then installs it on a specified server, granting access to that server without a password
# Parameters:
# - $remotehost: IP address or FQDN of the server to copy the ssh key to
# - $remoteuser: The user we want to use to log into the server
# - $remoteuserpwd: The password of $remoteuser
#
# referenced stuff
# https://www.perlmonks.org/?node_id=786670
# https://metacpan.org/release/RGIERSIG/Expect-1.15/view/Expect.pod
# https://gist.github.com/tommybutler/6934497
use strict;
use warnings;
use Expect;

# define variables
my $keygencmd = 'ssh-keygen';
my $timeout = 10;

my ($remotehost, $remoteuser, $remoteuserpwd) = @ARGV;

if (not defined $remotehost) {
  die "Need hostname of remote server\n";
}

if (not defined $remoteuser) {
  die "Need username of user with ssh access to remote server\n";
}

if (not defined $remoteuserpwd) {
  die "Need password of user with ssh access to remote server\n";
}

# Generate the key
# ----------------------------
my $exp = Expect->new();
$exp->spawn($keygencmd)
  or die "Cannot spawn $keygencmd: $!\n";

$exp->expect($timeout,
  [ qr/Enter file.*:/ => \&enterfile ],
  [ qr/Overwrite \(y\/n\)\?/ => \&sayyes ], # if ssh key with same name already exists
  [ qr/Enter passphrase \(empty for no passphrase\):/ => \&enterpassphrase],
  [ qr/Enter same passphrase again:/ => \&enterpassphrase],
  [ timeout => \&timed_out ],
);

$exp->soft_close();

# ssh-copy key to remote server
# ----------------------------
my $copycmd = "ssh-copy-id $remoteuser\@$remotehost";

# Cannot reuse an object with an already spawned command
my $expcopy = Expect->new();

$expcopy->spawn($copycmd)
  or die "Cannot spawn $copycmd: $!\n";

$expcopy->expect($timeout,
  [ qr/Are you sure you want to continue connecting \(yes\/no\/\[fingerprint\]\)\?/ => \&sayyes ],
  [ qr/password:/ => \&enterpassword ],
  [ timeout => \&timed_out ],
);

$expcopy -> soft_close();

# ssh key file (going with default ~/.ssh/id_rsa)
sub enterfile {
  my $exp = shift;
  $exp->clear_accum();
  $exp->send( "\n" );
  exp_continue;
}

sub sayyes {
  my $exp = shift;
  $exp->clear_accum();
  $exp->send( "yes\n" );
  exp_continue;
}

# may want to actually have a passphrase someday?
sub enterpassphrase {
  my $exp = shift;
  $exp->clear_accum();
  $exp->send( "\n" );
  exp_continue;
}

sub enterpassword {
  my $exp = shift;
  $exp->clear_accum();
  $exp->send( "$remoteuserpwd\n" );
  exp_continue;
}

sub timed_out
{
  my $fail = qq(TIMEOUT!  Not what we EXPECT-ed);
  die $fail;
}