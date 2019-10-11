#!/usr/bin/perl

### WORK IN PROGRESS ###

#forces us to write good code and show us comprehensive errors
#use strict;
#use warnings;
#use diagnostics;

#adds function to print line followed by a new line
use feature 'say';

#for demonstration of switch (give and win) statement inside of perl
use feature "switch";

#for defining to use a specific version of Perl
use v5.30;

#install using `cpanm PDF::Core`
use PDF::Core;
use File::Extract::PDF;
use CAM::PDF;
use Text::FromAny;

#cannot install
#use CGI::Application::Search;
#use PDF::OCR::Thorough

########################################################################

my $filename = "/Users/jakeireland/Desktop/Study/Victoria University/2018/Trimester 2/PSYC221/Minority Report/Report/Minority Report.pdf";

my $searchstring = "Allport";
 
#my $pdf = CAM::PDF->new($filename);

my $tFromAny = Text::FromAny->new(
    file => $filename);
my $text = $tFromAny->text, "\n";

my $grepped = grep($searchstring, $text);

print($grepped);