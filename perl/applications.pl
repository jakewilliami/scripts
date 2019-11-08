#!/usr/bin/perl

# Run using perl -X perl/applications.pl

# for defining to use a specific version of Perl
use v5.30;

# install using `cpanm lib::rary`
# INSTALLING IS CASE SENSITIVE
use warnings;
use strict;

#use XML::Simple;
use XML::LibXML;
use Data::Dumper;

### Gets standard output from system profiler and write it to a $filename
my $sys_profile = `system_profiler -xml SPApplicationsDataType`;
my $filename = '/Users/jakeireland/bin/scripts/perl/system_profile.txt';
open(FH, '>', $filename) or die $!;
print FH $sys_profile;
close(FH);

### The load_xml() class method is called to parse the XML file and return a document object
my $dom = XML::LibXML->load_xml(location => $filename);
my %dom;


my @names = $dom -> findvalue('string(/plist/array/dict/array/dict/key[. = "_name"][1]/following-sibling::*[1])');

my @obtained_froms = $dom -> findvalue('string(/plist/array/dict/array/dict/key[. = "obtained_from"][1]/following-sibling::*[1])');

for my $name (@names) {
    say $name;
}

#my @datKeys = $dom -> findnodes('/plist/array/dict/array/dict/key') -> to_literal();

#say $name;















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



