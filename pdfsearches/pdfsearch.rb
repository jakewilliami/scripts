#!/usr/bin/ruby

require 'pdf-reader'
require 'rubygems'
require 'pdf/reader'

#puts 'What is your name?'
#name = gets.chomp
#puts "Hello #{name}!"

#name = ARGV[0]
#puts "Hello #{name}!"

##########################################################

#coding: utf-8

filename = '/Users/jakeireland/Desktop/Study/Victoria University/2018/Trimester 2/PSYC221/Minority Report/Report/Minority Report.pdf'

stringname = 'Allport'

reader = PDF::Reader.new('/Users/jakeireland/Desktop/Study/Victoria University/2018/Trimester 2/PSYC221/Minority Report/Report/Minority Report.pdf')

PDF::Reader.open(filename) do |reader|
    reader.pages.each do |page|
        plaintext = page.text
        grepped = plaintext.match 'Allport'
        print(grepped)
        #t = File.read(filetotext, encoding: 'ISO-8859-1:UTF-8')
        #s = t.scan /\b#{stringname}\b/i
        #put s
    end
end

#puts reader.pdf_version
#puts reader.info
#puts reader.metadata
#puts reader.page_count

#######################################################################

# coding: utf-8

# A test script to test loading and parsing a PDF file
#
