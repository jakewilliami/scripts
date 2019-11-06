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

### The $dom variable now contains an object representing all the elements of the XML document arranged in a tree structure known as a Document Object Model
### The findnodes() method is called to search the DOM for the elements we’re interested in and a foreach loop is used to iterate through the matching elements
### The findnodes() method takes one argument: an XPath expression. This is a string describing the location and characteristics of the elements we want to find.  The findnodes() method then returns a list of objects from the DOM that match the XPath expression.
### Obtains each key name for corresponding values
my @datVals = $dom -> findnodes('/plist/array/dict/array/dict/string');

foreach my $value (@datVals) {
        say $value -> to_literal();
    }

### Obtains each value for corresponding keys
my @datKeys = $dom -> findnodes('/plist/array/dict/array/dict/key');
     
foreach my $key (@datKeys) {
        say $key -> to_literal();
    }


### Construct hash of keys = values
#use List::MoreUtils qw/zip/;
#my %hash = zip @datKeys, @datVals;

#my %hash;
#@hash{@datKeys} = @datVals;

#print Dumper(\@datKeys);


#foreach my $i (\@datVals) {
#    say "$i";
#}

#print Dumper(\@datKeys);

#my $values = $dom -> findnodes('/plist/array/dict/array/dict/string') -> to_literal();
#
#say $values;

#my $data_array = join '\n', map {
#        $_ -> to_literal();
#    } $dom -> findnodes('/plist/array/dict/array/dict/string') -> to_literal();
#    
#print $data_array




#my %hash = map {
#    foreach my $name ($dom -> findnodes('/plist/array/dict/array/dict/string')) {
#        say $name -> to_literal();
#    },
#    foreach my $name ($dom -> findnodes('/plist/array/dict/array/dict/key')) {
#        say $name -> to_literal();
#    }
#}

#foreach my $sys_data ($dom -> findnodes('/plist/array/dict/array/dict')) {
#    say 'KEY:   ', $sys_data -> findvalue('./key');
#}

#foreach my $sys_data ($dom -> findnodes('/plist/array/dict/array/dict')) {
##    say 'KEY:   ', $sys_data -> findvalue('./key');
##    say 'VALUE: ', $sys_data -> findvalue('./string');
##    
##    my $data_array = join '\n', map {
##        $_ -> to_literal();
##    } $sys_data -> findnodes('./key');
##    say $data_array;
##    say "";
#    
#    
#}


#foreach my $movie ($dom->findnodes('//movie')) {
#    say 'Title:    ', $movie->findvalue('./title');
#    say 'Director: ', $movie->findvalue('./director');
#    say 'Rating:   ', $movie->findvalue('./mpaa-rating');
#    say 'Duration: ', $movie->findvalue('./running-time'), " minutes";
#    my $cast = join ', ', map {
#        $_->to_literal();
#    } $movie->findnodes('./cast/person/@name');
#    say 'Starring: ', $cast;
#    say "";
#}


#Title:    Apollo 13
#Director: Ron Howard
#Rating:   PG
#Duration: 140 minutes
#Starring: Tom Hanks, Bill Paxton, Kevin Bacon, Gary Sinise, Ed Harris
#
#Title:    Solaris
#Director: Steven Soderbergh
#Rating:   PG-13
#Duration: 99 minutes
#Starring: George Clooney, Natascha McElhone, Ulrich Tukur


