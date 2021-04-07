#! /usr/bin/ruby

lsof -t -i tcp:#{ARGV.first} | xargs kill
