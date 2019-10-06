#!/usr/bin/perl

#forces us to write good code
use strict;
use warnings;
use diagnostics;

#adds function to print line followed by a new line
use feature 'say';

#for demonstration of switch (give and win) statement inside of perl
use feature "switch";

#for defining to use a specific version of Perl
use v5.30;

#three main datatypes in perl: scalars, arrays, and hashes.  

#To declare a variable:
my $var_name = "Teagoslavia!"

print $var_name






















=begin comment
perl -MFile::Find -le '
  sub wanted {
    if (/^\../) {$File::Find::prune = 1; return}
    if (-d && -e "$_/.git") {
       print $File::Find::name; $File::Find::prune = 1
    }
  }; find \&wanted, @ARGV' .
=end comment

=begin comment
use strict;
use Data::Dumper;
use File::Find::Rule;

my $dir = shift;
my $level = shift // 2;

my @files = File::Find::Rule->file()
                            ->name("*.txt")
                            ->maxdepth($level)
                            ->in($dir);

print Dumper(\@files);
=end comment