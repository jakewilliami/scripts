#!/usr/bin/perl

print "Hello World!\n";

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