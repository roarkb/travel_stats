#!/usr/bin/env ruby

# USAGE: ./top_places.rb <min number of days and up>

require 'nokogiri'
require 'open-uri'

URL = "http://roark.sleptlate.org/travel-stats/"
MIN_DAYS = ARGV.first.to_i
RE_PLACE = /^\d{1,3}\.\s/
RE_DASH = /\s(\W|\\342\\200\\223)\s/

page = Nokogiri::HTML(open(URL))
text = page.at_css("#places").text.strip
place_rollup = {}

text.split("\n").each do |line|
  if line =~ RE_PLACE
    a = line.gsub(RE_DASH, "|").gsub(RE_PLACE, "").chomp.split("|")
    
    place = a[0]
    days = a[1].to_i
  
    if place_rollup.keys.include?(place)
      place_rollup[place][0] += days
      place_rollup[place][1] += 1
    else
      place_rollup[place] = [ days, 1 ]
    end
  end
end

puts
puts "PLACE: DAYS - VISITS\n--------------------"
place_rollup.sort_by {|k,v| v}.reverse.each do |place,days_and_visits|
  days = days_and_visits[0]
  visits = days_and_visits[1]
  
  puts "#{place}: #{days} - #{visits}" if days >= MIN_DAYS
end

puts
