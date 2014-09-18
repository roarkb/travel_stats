#!/usr/bin/env ruby

# USAGE: ./top_places.rb <number of records>

require 'nokogiri'
require 'open-uri'

URL = "http://roark.sleptlate.org/travel-stats/"
RE = /^\d{1,3}\.\s/
RECORDS = ARGV.first.to_i

page = Nokogiri::HTML(open(URL))
text = page.at_css("#places").text.strip
place_rollup = {}
count = 0

text.each do |line|
  if line =~ RE
    a = line.gsub(" \342\200\223 ", "|").gsub(RE, "").chomp.split("|")
    
    place = a[0]
    days = a[1].to_i
  
    if place_rollup.keys.include?(place)
      place_rollup[place] += days
    else
      place_rollup[place] = days
    end
  end
end

puts

place_rollup.sort_by {|k,v| v}.reverse.each do |place,days|
  puts "#{place} - #{days}"
  count += 1
  break if count == RECORDS
end

puts
