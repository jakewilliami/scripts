#!/usr/bin/env perl

# ABSTRACT: A tool for counting the number of films or series in your Plex Media Server.
# PODNAME: countmedia

use v5;
use warnings;
use strict;

use Pod::Usage qw(pod2usage);
use Getopt::Long qw(GetOptions);

# VERSION

=head1 SYNOPSIS

    countmedia [-f | -s]


-f | --film: Counts the number of films in our media vault.

-s | --series: Counts the number of series in our media vault.

=head1 DESCRIPTION

...

=cut
my $filmsdir = ".";
my $seriesdir = ".";
# GetOptions('help|?|h' => \my $help, 'film|f' => \$count_exts($filmsdir, "mp4", "mkv", "avi"), 'series|s' => count_dirs($seriesdir)) or pod2usage(2);
GetOptions("film" => \&count_exts($filmsdir, "mp4", "mkv", "avi"),
            "series"   => \&count_dirs($seriesdir))
or die("Error in command line arguments\n");

## If no arguments were given, then allow STDIN to be used only
## if it's not connected to a terminal (otherwise print usage)
# pod2usage("$0 requires a flag.  Use -h for help.")  if ((@ARGV == 0) && (-t STDIN));

# GetOptions(
    # q(help)             => \my $help,
# ) or pod2usage(q(-verbose) => 1);
# pod2usage(q(-verbose) => 1) if $help;

sub count_exts {
	my ($dir, $ext1, $ext2, $ext3, @extra) = @_;
	die "Extra args, do not know how to parse" if @extra;
	my $count = 0;
	opendir(my $d, $dir) or die "opendir($dir): $!";

	while (my $del = readdir($d)) {
		if ($del =~ /^.*\.\Q$ext1\E$|^.*\.\Q$ext2\E$|^.*\.\Q$ext3\E$/){
			$count++;
		}
		# if (-d $del){
			# count_exts($dir, $ext1, $ext2, $ext3)
		# }
	}

	closedir($d);
	print "You have $count films in your Plex Media Server.";
}

sub count_dirs {
	my ($root, @extra) = @_;
	die "Extra args, do not know how to parse" if @extra;
	my $count = 0;
	my @files = <$root/*>;

	foreach my $file (@files){
		if (-d $file){
			$count++;
			# count_dirs($file) # uncomment for recursion
		}
	}

	print "You have $count television series in your Plex Media Server.";
}



