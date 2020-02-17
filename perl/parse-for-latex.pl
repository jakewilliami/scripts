#! /usr/bin/perl


# Run using perl -X perl/parse-for-latex.pl

#see this for unicode characters:
#https://tex.stackexchange.com/questions/34604/entering-unicode-characters-in-latex


use v5.30; # for defining to use a specific version of Perl
use warnings;
use strict;

use File::HomeDir; # Used to get home directory

# Specify home directory
my $home = File::HomeDir::home();
# define data file
my $filePRAWData = "${home}/scripts/python/temp.d/reddit-archive-to-be-read.txt";
my $filePerlParse = "${home}/scripts/perl/temp.d/parsePRAWData.txt";

open(READFILE, '<', $filePRAWData) or die $!;
    open(OUTFILE, '>>', $filePerlParse) or die $!;
    
    close(OUTFILE);
close(READFILE);