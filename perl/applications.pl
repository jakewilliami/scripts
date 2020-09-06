#!/usr/bin/env perl

# Run using perl -X ${HOME}/scripts/perl/applications.pl

# cpanm install XML::LibXML String::Approx Text::Fuzzy Regexp::Approx File::HomeDir
# cpan install XML::LibXML
# cpan install String::Approx
# cpan install Text::Fuzzy
# cpan install Text::Fuzzy::PP
# cpan install File::HomeDir

# for defining to use a specific version of Perl
use v5.30.3;
use warnings;
use strict;

use XML::LibXML;
# use String::Approx 'amatch';  # Used to approximate matches
# use Text::Fuzzy;  # Used to approximate matches
# package Regexp::Approx;  # Allows String::Approx within Regex
use File::HomeDir;  # Used to get home directory
#use re::engine::TRE max_cost => 2;  # Allows regex approx matching

### Specify home directory
my $home = File::HomeDir::home();

### Gets standard output from system profiler and write it to a $filename
my $sys_profile = `system_profiler -xml SPApplicationsDataType`;
my $filesysProf = "${home}/scripts/perl/temp.d/system_profile.txt";
open(FH, '>', $filesysProf) or die $!;
    print FH $sys_profile;
close(FH);


### Gets standard output from brew cask install
my $casks = `brew list --cask`;
my $filecasks = "${home}/scripts/perl/temp.d/casks.txt";
open(FH, '>', $filecasks) or die $!;
    print FH $casks;
close(FH);



### The load_xml() class method is called to parse the XML file and return a document object
my $dom = XML::LibXML -> load_xml(location => $filesysProf);
my %dom;

sub dataApps {
    for my $node ($dom -> findnodes('//key[text() = "_name"]/following-sibling::string[1]') -> get_nodelist()) {
        my $key   =  $node -> textContent;
        my $value =  $node -> findvalue('./following::key[text() = "obtained_from"][1]/following-sibling::string[1]');
        next if ($value =~ /apple/);
        next if ($value =~ /mac_app_store/);
        print FH $key, ': ', $value, "\n";
    }
}

### Write dataApps to file
my $filedataApps = "${home}/scripts/perl/temp.d/dataApps.txt";
open(FH, '>', $filedataApps) or die $!;
    dataApps();
close(FH);




##### Print only those lines not in cask
#open(<APPS1>, "<${home}/scripts/perl/dataApps.txt")
#open(<APPS2>, "<${home}/scripts/perl/casks.txt")
#    foreach my $first_apps (<APPS1>) {
#        foreach my $second_apps (<APPS2>) {
#            print unless $second_apps =~ /(fuzzy) wuzzy was a (bear)/xi
#        }
#    }
#close(APPS1);
#close(APPS2);

use Text::Fuzzy::PP;
my $tf = Text::Fuzzy::PP->new ('boboon');


open (APPS1, "<${home}/scripts/perl/temp.d/dataApps.txt") or die $!;
    my %file_1_hash;
    my $line;
    my $line_counter = 0;

    #read the 1st file into a hash
    while ($line=<APPS1>){
    #  chomp ($line); #-only if you want to get rid of 'endl' sign
        $line_counter++;
        if (!($line =~ m/^\s*$/)){
            $file_1_hash{$line}=$line_counter;
        }
    }
close (APPS1);

    #read and compare the second file
    open(APPS2, "<${home}/scripts/perl/temp.d/casks.txt") or die $!;
    $line_counter = 0;
    while ($line=<APPS2>){
        $line_counter++;
    #  chomp ($line);
#        print unless ;
      if (defined $file_1_hash{$line}){
        print "Got a match: \"$line\"
    in line #$line_counter in casks.txt and line #$file_1_hash{$line} at dataApps.txt\n";
      }
    }
close (FILE2);



#my $Apps = `cat ${home}/scripts/perl/dataApps.txt`;
#my $filefuzzyMatch = "${home}/scripts/perl/fuzzy-match.txt";
#my $outfile = "${home}/bin/scripts/perl/fuzzy-match-out.txt";
#open(FH, '>', $filefuzzyMatch) or die $!;
#    print FH $Apps;
#close(FH);
#open(FH, '<', $filefuzzyMatch) or die $!;
#    my @lines = <FH>;
#    my %file2;
#    open my $file2, '<', "${home}/scripts/perl/casks.txt" or die $!;
#        while ( my $line = <$file2> ) {
#            ++$file2{$line};
#        }
#        open(FHOUT, '>', $filefuzzyMatch) or die $!;
#            for (@lines) {
#                print FHOUT $_ unless $file2;
#            }
#        close $filefuzzyMatch;
#    close $file2;
#close(FH);

#### Print only those lines not in cask
#open my $file1, '<', "${home}/scripts/perl/dataApps.txt" or die $!;
#while ( my $line = <$file1> ) {
#    print $line unless $file2{$line};
#}
#
#close $file1;
#close $file2;


#print if amatch("foobar");
#
#my @matches = amatch("xyzzy", dataApps());
#
#my @catches = amatch("plugh", ['2'], dataApps());
#
#
##dataApps();
