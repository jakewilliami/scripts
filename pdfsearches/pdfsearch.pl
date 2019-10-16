# Run using perl -X pdfsearches/pdfsearch.pl

#!/usr/bin/perl

### WORK IN PROGRESS ###

# for defining to use a specific version of Perl
use v5.30;

# install using `cpanm lib::rary`
use warnings;
use PDF::Core;
use File::Extract::PDF;
use CAM::PDF;
use Text::FromAny;
use Term::ANSIColor;
use strict;
use File::Find;
use Time::HiRes qw( time );
use File::Spec::Functions 'catfile';

# This is a helper function to initialize our %mutc variable.  (https://github.com/evalEmpire/method-signatures/pull/129/commits/bbed93f169a74b94da67c08d1f5f9e2c39daf130)
#no warnings 'deprecated';
#require Any::Moose;
#Any::Moose->import('::Util::TypeConstraints');

my $fileDir = "/Users/jakeireland/Desktop/Study/Victoria University/2018/Trimester 2/PSYC221/";
my $searchString = $ARGV[0];
#my $insensitiveSearch = /$searchString/i;

print color("BOLD RED"), "\nThis PDF searching tool is presently case sensitive.  Ensure you are entering your search term case sensitively.\nThis PDF searching tool presently cannot tell how many search terms are found; only in how many PDFs.  Sorry for any inconvenience.\n\n", color("reset");

my $countPdfsFound = 0;
my $countTerms = 0;

my $found = "false";

sub eachFile {
    my $filename = $_;
    my $fullpath = $File::Find::name;
    foreach my $f ($filename) {
        if ($f =~ /\.pdf\z/) {
            my $tFromAny = Text::FromAny->new(
            file => $f);
            my $text = $tFromAny->text;
            if (index($text, $searchString) != -1) {
                print color("BOLD"), "\"${searchString}\" found in ${fullpath}/${filename}!\n", color("reset");
                $countPdfsFound++;
            } 
        }
    }
}

my $startTime = time();

find (\&eachFile, $fileDir);

my $endTime = time();
my $runTime = $endTime - $startTime;

print color("BOLD YELLOW"), "\n${runTime} seconds\n", color("reset");
print color("BOLD GREEN"), "The word \"${searchString}\" was found in ${countPdfsFound} pdfs\n", color("reset");