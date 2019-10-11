# Run using perl -X pdfsearches/pdfsearch.pl

#!/usr/bin/perl

### WORK IN PROGRESS ###

# adds function to print line followed by a new line
use feature 'say';

# for defining to use a specific version of Perl
use v5.30;

# install using `cpanm lib::rary`
use PDF::Core;
use File::Extract::PDF;
use CAM::PDF;
use Text::FromAny;
use Term::ANSIColor;
use warnings;

# This is a helper function to initialize our %mutc variable.  (https://github.com/evalEmpire/method-signatures/pull/129/commits/bbed93f169a74b94da67c08d1f5f9e2c39daf130)
#no warnings 'deprecated';
#require Any::Moose;
#Any::Moose->import('::Util::TypeConstraints');

my $filename = "/Users/jakeireland/Desktop/Study/Victoria University/2018/Trimester 2/PSYC221/Minority Report/Report/Minority Report.pdf";

my $searchstring = "Allport";

my $tFromAny = Text::FromAny->new(
    file => $filename);
    
my $text = $tFromAny->text, "\n";

my $grepped = grep($searchstring, $text);

if (not defined $grepped) {
    print color("red"), "Not found in ${filename}", color("reset");
} else {
    print color("green"), "Found in ${filename}!", color("reset");
}