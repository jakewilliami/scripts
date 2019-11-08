#!/usr/bin/perl

# Run using perl -X perl/applications.pl

# for defining to use a specific version of Perl
use v5.30;
use warnings;
use strict;

use XML::LibXML;
use String::Approx 'amatch';  # Used to approximate matches
use Text::Fuzzy;  # Used to approximate matches
use File::HomeDir;  # Used to get home directory

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



### The load_xml() class method is called to parse the XML file and return a document object
my $dom = XML::LibXML -> load_xml(location => $filename1);
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
my $filename3 = "${home}/bin/scripts/perl/dataApps.txt";
open(FH, '>', $filename3) or die $!;
    dataApps();
close(FH);


#dataApps();








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



