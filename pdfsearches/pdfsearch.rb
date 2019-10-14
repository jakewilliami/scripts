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
def bold;           "\033[1m#{self}"end
def italic;         "\033[3m#{self}" end
def underline;      "\033[4m#{self}" end
def blink;          "\033[5m#{self}" end
def reverse_color;  "\033[7m#{self}" end
end

fileName = '/Users/jakeireland/Desktop/Study/Victoria University/2018/Trimester 2/PSYC221/Minority Report/Report/Minority Report.pdf'

mainDir = '/Users/jakeireland/Desktop/Study/Victoria University/2018/Trimester 2/PSYC221/'

stringName = ARGV[0]

found = false
pdfCount = 0
os_walk = Dir.glob( "#{mainDir}/**/*.pdf" )

startTime = Time.now.to_f

for f in os_walk do
    reader = PDF::Reader.new(f)
    PDF::Reader.open(f) do |reader|
    reader.pages.each do |page|
        plainText = page.text
        grepped = plainText.match(/#{stringName}/i)
        if grepped.nil?

        else
            found = true
            if (found == true)
                pdfCount = pdfCount + 1
            end
#                puts "String #{stringName} found in #{f}!".green
#            else
#                puts "String #{stringName} not found in #{f}".red
        end
    end
    end
end

endTime = Time.now.to_f
runTime = endTime - startTime

puts "this is the count #{pdfCount}"
puts "\n#{runTime} seconds"

#puts reader.pdf_version
#puts reader.info
#puts reader.metadata
#puts reader.page_count
