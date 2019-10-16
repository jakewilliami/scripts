#!/usr/bin/ruby

#gem install pdf-reader if out of date
require 'pdf-reader'
require 'rubygems'
require 'colorize'
require 'pathname'
require 'rails'
require "find"

#puts 'What is your name?'
#name = gets.chomp
#puts "Hello #{name}!"

##########################################################

class String
def bgreen; "\033[1;38;5;2m#{self}\033[0;38m" end
def byellow; "\033[1;33m#{self}\033[0;38m" end
def bred; "\033[1;31m#{self}\033[0;38m" end
def bwhite; "\033[1;38m#{self}\033[0;38m" end
def bitwhite; "\033[1;3;38m#{self}\033[0;38" end
def bblue; "\033[1;38;5;26m#{self}\033[0;38m" end
end

mainDir = './'

stringName = ARGV[0]

foundCount = 0
pdfCount = 0
os_walk = Dir.glob( "#{mainDir}/**/*.pdf" )

#print color("BOLD"), "Usage: cd /dir/to/search/ && pdfsearch \"<search_term>\" [option...]\n", color("reset");
#    print color("BOLD"), italic("\nThe present programme will search PDFs in current directory and subdirectories for a search term, then print the PDFs for which said tern is found, and then print how many PDFs the search term was found in.  "), color("BOLD YELLOW"), italic("This PDF searching tool is presently case sensitive.  Ensure you are entering your search term case sensitively. It also presently cannot tell how many search terms are found; only in how many PDFs.  Sorry for any inconvenience.\n"), color("reset");

if ARGV[0] = "-h"
    puts "Usage: cd /dir/to/search/ && pdfsearch \"<search_term>\" [option...]\n".bwhite
    puts "The present programme will search PDFs in current directory and subdirectories for a search term, then print the PDFs for which said tern is found, and then print how many PDFs the search term was found in, and how many times it was found.".bitwhite
    puts
    print "   -h".bblue 
    puts "           Shows help (present output).".byellow
    exit
end

startTime = Time.now.to_f

for f in os_walk do
    found = false
    reader = PDF::Reader.new(f)
    PDF::Reader.open(f) do |reader|
    reader.pages.each do |page|
        plainText = page.text
        grepped = plainText.match(/#{stringName}/i)
        if grepped.nil?

        else
            foundCount += 1
            if not found
                pdfCount += 1
                found = true
                puts f.bwhite
            end
        end
    end
    end
end


endTime = Time.now.to_f
runTime = endTime - startTime

puts "#{runTime} seconds".byellow
puts "The word #{stringName} was found #{foundCount} times in #{pdfCount} pdfs".bgreen
