#!/usr/bin/env ruby

# USAGE: ./top_places.rb <min number of days and up>
# TODO: add num visits

require 'nokogiri'
require 'open-uri'

URL = "http://roark.sleptlate.org/travel-stats/"
MIN_DAYS = ARGV.first.to_i
RE_PLACE = /^\d{1,3}\.\s/

# depending on the internet's mood...
#RE_DASH = " \342\200\223 "
#RE_DASH = /\s\W\s/
RE_DASH = /\s(\W|\\342\\200\\223)\s/ # try this one to pick up both

page = Nokogiri::HTML(open(URL))
text = page.at_css("#places").text.strip
place_rollup = {}

#text.split("\n").each {|line| puts line}

text.split("\n").each do |line|
  if line =~ RE_PLACE
    a = line.gsub(RE_DASH, "|").gsub(RE_PLACE, "").chomp.split("|")
    
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
  puts "#{place} - #{days}" if days >= MIN_DAYS
end

puts
