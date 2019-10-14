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
        end
    end
    end
end

endTime = Time.now.to_f
runTime = endTime - startTime

#puts f.bwhite

puts "#{runTime} seconds".byellow
puts "The word #{stringName} was found #{pdfCount} times in 1 pdfs".bgreen
