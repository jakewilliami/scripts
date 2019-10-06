

# `sudo gem install pdf-reader`
require 'pdf-reader'

#puts 'What is your name?'
#name = gets.chomp
#puts "Hello #{name}!"

#name = ARGV[0]
#puts "Hello #{name}!"

#require "yomu"
#yomu = Yomu.new "dracula-shortened.pdf"
#puts yomu.html

#def add_keywords_to_profile(user)
#  io = open(user.resume_pdf.to_s)
#  reader = PDF::Reader.new(io)
#  reader.pages.each do |page|
#    string = page.text
#    KeywordHelper.keywords.each do |word|
#      if string.downcase.include?(word.downcase)
#        user.keywords.push(word)
#        user.save
#      end
#    end
#  end
#end

dir = "/Users/jakeireland/Desktop/Study/Victoria University/2018/Trimester 2/PSYC221"

reader = PDF::Reader.new('/Users/jakeireland/Desktop/Study/Victoria University/2018/Trimester 2/PSYC221/Minority Report/Report/Minority Report.pdf')

#reader.pages.each do |page|
#  puts page.text
#end

puts reader.pdf_version
puts reader.info
puts reader.metadata
puts reader.page_count