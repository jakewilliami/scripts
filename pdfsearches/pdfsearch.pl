#!/usr/bin/perl

#forces us to write good code and show us comprehensive errors
use strict;
use warnings;
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

#cannot install
#use CGI::Application::Search;

my $filename = "/Users/jakeireland/Desktop/CHEM203 CompChem Assignment 2019.pdf";
 
#my $pdf = CAM::PDF->new($filename);
# 
#my $contentTree = $pdf->getPageContentTree(4);
#$contentTree->validate() || die 'Syntax error';
#print $contentTree->render('CAM::PDF::Renderer::Text');
#$pdf->setPageContent(5, $contentTree->toString());






















#perl -MFile::Find -le '
#  sub wanted {
#    if (/^\../) {$File::Find::prune = 1; return}
#    if (-d && -e "$_/.git") {
#       print $File::Find::name; $File::Find::prune = 1
#    }
#  }; find \&wanted, @ARGV' .
#
#
#
#use strict;
#use Data::Dumper;
#use File::Find::Rule;
#
#my $dir = shift;
#my $level = shift // 2;
#
#my @files = File::Find::Rule->file()
#                            ->name("*.txt")
#                            ->maxdepth($level)
#                            ->in($dir);
#
#print Dumper(\@files);