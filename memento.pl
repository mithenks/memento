#!/Applications/MAMP/Library/bin/perl
package Memento;
use strict; use warnings;
use feature 'say';
use Getopt::Std;
$Getopt::Std::STANDARD_HELP_VERSION = 1;

my $file = `which memento`;
$_ = `ls -l $file`;

our ($root);
if (/ (\/[\w\/\-]+?memento\.pl)$/) {
  $root = $1;
  $root =~ s/\/memento.pl$//;
}

require "$root/Daemon.pm";
getopts('v');

if ($#ARGV > -1) {
  my $type = shift;
  my $command = shift || "help";
  if (my $memento = Memento->instantiate($type, $command)) {
    $memento->_pre(@ARGV);
    $memento->$command(@ARGV);
    $memento->_done(@ARGV);
  }
}
else {
  say splash();
}

sub instantiate {
  my $class = shift;
  my $type = shift;
  my $command = shift;
  my $location = "Memento/$type.pm";
  $class = "Memento::$type";

  if (-f "$root/$location") {
    require "$root/$location";
    return $class->new(@_, $type, $command);
  }
}

sub splash {
  return Daemon::read("$root/splash");
}

sub main::VERSION_MESSAGE {
  my @splash = &splash();
  "@splash" =~ /(v\d+\.\d+\.\w+)/;
  say $1;
}

1;
