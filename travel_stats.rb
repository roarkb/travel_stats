#!/usr/bin/env ruby

# calculate accumulative days i have spent in each country

require "date"

# "country name" => [list each date i entered a country]
COUNTRIES = {
  :thailand    => ["2013-3-12", "2013-12-23", "2014-2-11", "2014-3-1"],
  :india       => ["2013-4-2", "2013-7-1"],
  :nepal       => ["2013-5-13"],
  :indonesia   => ["2013-7-11", "2013-10-5"],
  :malaysia    => ["2013-9-6", "2013-9-16"],
  :brunei      => ["2013-9-13"],
  :singapore   => ["2013-11-4", "2013-12-13", "2014-2-20"],
  :usa         => ["2013-11-10"],
  :philippines => ["2013-11-25", "2014-3-8"],
  :myanmar     => ["2014-1-14"],
  :hong_kong   => ["2014-4-20"],
  :germany     => ["2014-4-30"],
  :switzerland => ["2014-5-4"],
  :kyrgyzstan  => ["2014-6-28"],
}

SPACER = 12
START_DATE = "2013-3-11"

def remove_underscores(text)
  text.split("_").join(" ")
end

# convert COUNTRIES hash into list of [date,country] arrays ordered by date
visits = []
COUNTRIES.each do |country,dates|
  dates.each do |date|
    visits.push([Date.strptime(date, "%Y-%m-%d"), country.to_s]).sort!
  end
end

# add duration of each country visit to visits: [ [date,country.duration], ...]
visits.each_with_index do |visit,index|
  date = visit[0]

  begin
    visit.push((visits[index + 1][0] - date).to_i)
  rescue
    visit.push((Date.today - date).to_i)
  end
end

# add up total days per country in rollup hash: {country => total days, ...}
rollup = {}
visits.each do |visit|
  country = visit[1]
  days = visit[2]

  if rollup.keys.include?(country)
    rollup[country] += days
  else
    rollup[country] = days
  end
end

puts

# TODO: issue with using invert - if total days of a country is the same as another it will get overwritten because hash keys have to be unique
puts "DEBUG:"
p rollup
p rollup.invert
puts

sorted_rollup = rollup.invert.sort.reverse
total_days = (Date.today - Date.strptime(START_DATE, "%Y-%m-%d")).to_i

sorted_rollup.each do |days,country|
  printf("%-#{SPACER}s %s\n", "#{remove_underscores(country)}:", days)
end

puts "\ntotal days traveled: #{total_days}\n\n"

puts "\nHTML:\n\n<table>"

sorted_rollup.each do |days,country|
  puts "<tr><td>#{remove_underscores(country)} </td><td>#{days}</td></tr>"
end

puts "<tr><td><b>total days traveled </b></td><td><b>#{total_days}</b></td></tr>"
puts "</table>\n\n"

