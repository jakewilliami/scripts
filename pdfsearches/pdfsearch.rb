#!/usr/bin/ruby

require 'pdf-reader'
require 'rubygems'
require 'pdf/reader'
require 'colorize'

#puts 'What is your name?'
#name = gets.chomp
#puts "Hello #{name}!"

#name = ARGV[0]
#puts "Hello #{name}!"

##########################################################

#coding: utf-8

class String
def bold;           "\033[1m#{self}"end
def italic;         "\033[3m#{self}" end
def underline;      "\033[4m#{self}" end
def blink;          "\033[5m#{self}" end
def reverse_color;  "\033[7m#{self}" end
end

filename = '/Users/jakeireland/Desktop/Study/Victoria University/2018/Trimester 2/PSYC221/Minority Report/Report/Minority Report.pdf'

stringname = ARGV[0]

reader = PDF::Reader.new('/Users/jakeireland/Desktop/Study/Victoria University/2018/Trimester 2/PSYC221/Minority Report/Report/Minority Report.pdf')

found = false

PDF::Reader.open(filename) do |reader|
    reader.pages.each do |page|
        plaintext = page.text
        grepped = plaintext.match(/#{stringname}/i)
        if grepped.nil?
              
        else
            found = true
        end
    end
end

if (found == true)
    puts "String #{stringname} found in #{filename}!".green
else
    puts "String #{stringname} not found in #{filename}".red
end

#puts reader.pdf_version
#puts reader.info
#puts reader.metadata
#puts reader.page_count