#!/usr/bin/perl

# Run using perl -X perl/applications.pl

# for defining to use a specific version of Perl
use v5.30;

# install using `cpanm lib::rary`
# INSTALLING IS CASE SENSITIVE
use warnings;
use strict;

use XML::LibXML;
use Data::Dumper;
use String::Approx 'amatch';
use Text::Fuzzy;
use File::HomeDir;
use File::Copy qw(move);

### Specify home directory
my $home = File::HomeDir::home();

### Gets standard output from system profiler and write it to a $filename
my $sys_profile = `system_profiler -xml SPApplicationsDataType`;
my $filename1 = "${home}/bin/scripts/perl/system_profile.txt";
open(FH, '>', $filename1) or die $!;
    print FH $sys_profile;
close(FH);


### Gets standard output from brew cask install
my $casks = `brew cask list`;
my $filename2 = "${home}/bin/scripts/perl/casks.txt";
open(FH, '>', $filename2) or die $!;
    print FH $casks;
close(FH);


### Gets standard output from mac app store
#my $mas = `mas list`;
#my $filename3 = "${home}/bin/scripts/perl/mas.txt";
#open(FH, '>', $filename3) or die $!;
#    for my $line ( <$mas> ) {
#        if ($line =~ /(^\d+)/) {
#            my $match = $1;
#            print FH $match;
#        }
#    }
#close(FH);
my $mas = `mas list`;
my $filename3 = "${home}/bin/scripts/perl/mas.txt";
my $outfile = "${home}/bin/scripts/perl/mas-out.txt";
open(FH, '>', $filename3) or die $!;
    print FH $mas;
close(FH);
open(FH, '<', $filename3) or die $!;
    my @lines = <FH>;
open(FHOUT, '>', $filename3) or die $!;
    for (@lines) {
        s/(\d+)//g;
        s/(\(.*\))//g;
        print FHOUT $_;
    }
close(FH);



### The load_xml() class method is called to parse the XML file and return a document object
my $dom = XML::LibXML -> load_xml(location => $filename1);
my %dom;


#my @names = $dom -> findvalue('string(/plist/array/dict/array/dict/key[. = "_name"][1]/following-sibling::*[1])');
#
#my @obtained_froms = $dom -> findvalue('string(/plist/array/dict/array/dict/key[. = "obtained_from"][1]/following-sibling::*[1])');

sub dataApps {
    for my $node ($dom -> findnodes('//key[text() = "_name"]/following-sibling::string[1]') -> get_nodelist()) {
        my $key   =  $node -> textContent;
        my $value = $node -> findvalue('string(/plist/array/dict/array/dict/key[. = "obtained_from"][1]/following-sibling::*[1])');
        say $key, ': ', $value;
    }
}

















# Bad practice parsing XML using regex
my @dataXml = split(/\n/, $dom);


sub nameXml {
    my $type = @_;
    for my $idx (0..$#dataXml) {
        if ($dataXml[$idx] =~ /<key>_name<\/key>/) {
            for my $ii ($idx..($idx + 1)) {
                unless ($dataXml[$ii] =~ /<key>_name<\/key>/ || $dataXml[$ii] =~ /<dict>/) {
                    say $dataXml[$ii];
                }
            }
        }
    }
}


sub obtainedFromXml {
    my $type = @_;
    for my $idx (0..$#dataXml) {
        if ($dataXml[$idx] =~ /<key>obtained_from<\/key>/) {
            for my $ii ($idx..($idx + 1)) {
                unless ($dataXml[$ii] =~ /<key>obtained_from<\/key>/ || $dataXml[$ii] =~ /<dict>/) {
                    say $dataXml[$ii];
                }
            }
        }
    }
}



