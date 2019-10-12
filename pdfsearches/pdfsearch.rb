#!/usr/bin/ruby

#For rails to work, you need to run 
#sudo gem install rails
#which requires ruby 2.4.4 and above.  So run the following lines, which installs Ruby 2.6.4 and sets it as your default Ruby version
#brew install ruby-build
#brew install rbenv
#rbenv install 2.6.4
#rbenv global 2.6.4

#gem install pdf-reader if out of date
require 'pdf-reader'
require 'rubygems'
require 'pdf/reader'
require 'colorize'
require 'pathname'
require 'rails'

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

def os_walk(dir)
  root = Pathname(dir)
  files, dirs = [], []
  Pathname(root).find do |path|
    unless path == root
      dirs << path if path.directory?
      files << path if path.file?
    end
  end
  [root, files, dirs]
end

fileName = '/Users/jakeireland/Desktop/Study/Victoria University/2018/Trimester 2/PSYC221/Minority Report/Report/Minority Report.pdf'

mainDir = '/Users/jakeireland/Desktop/Study/Victoria University/2018/Trimester 2/PSYC221/'

stringName = ARGV[0]

root, files, dirs = os_walk(mainDir)

#for f in os_walk(mainDir) do
#    if File.extname("#{f}") == ".pdf"
#        puts "#{f}"
#    else
#        puts "nothing"
#    end  
#end

#reader = PDF::Reader.new('/Users/jakeireland/Desktop/Study/Victoria University/2018/Trimester 2/PSYC221/Minority Report/Report/Minority Report.pdf')

found = false

##for f in os_walk(mainDir) do
#Dir[ './*.pdf' ].select{ |f| File.file? f } 
##    Dir.glob('*.pdf').each do |f|
#    #  fileName = Dir.glob('*.pdf')
#    #  File.open(fileName, 'r') do |file|
#        reader = PDF::Reader.new('#{f}')
#        PDF::Reader.open(f) do |reader|
#        reader.pages.each do |page|
#            plainText = page.text
#            grepped = plainText.match(/#{stringName}/i)
#            if grepped.nil?
#
#            else
#                found = true
#            end
#        end
##        end
#    #  end
#    end
#end
##end

#for f in os_walk(mainDir) do
#Dir[ 'mainDir/*.pdf' ].select{ |f| File.file? f } 
    #  File.open(fileName, 'r') do |file|
    reader = PDF::Reader.new(Rails.mainDir.join(f))
    PDF::Reader.open(f) do |reader|
    reader.pages.each do |page|
        plainText = page.text
        grepped = plainText.match(/#{stringName}/i)
        if grepped.nil?

        else
            found = true
        end
    end
    end
#end



if (found == true)
    puts "String #{stringName} found in #{fileName}!".green
else
    puts "String #{stringName} not found in #{fileName}".red
end

#puts reader.pdf_version
#puts reader.info
#puts reader.metadata
#puts reader.page_count
