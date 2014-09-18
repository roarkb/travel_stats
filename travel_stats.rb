#!/usr/bin/env ruby

# calculate accumulative days i have spent in each country

require "date"

# "country name" => [list each date i entered a country]
COUNTRIES = {
  :thailand    => ["2013-3-12", "2013-12-23", "2014-2-11", "2014-3-1"],
  :india       => ["2013-4-2", "2013-7-1", "2014-8-3"],
  :nepal       => ["2013-5-13"],
  :indonesia   => ["2013-7-11", "2013-10-5"],
  :malaysia    => ["2013-9-6", "2013-9-16", "2013-12-23"],
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

SPACER = 15
START_DATE = "2013-3-11"
#END_DATE = nil # TODO: incorperate end date into this
TOTAL_COUNTRIES = COUNTRIES.length

def remove_underscores(text)
  text.split("_").join(" ")
end

# add blank space before a single digit number (returns string)
def front_pad(num) # int
  if num.to_s.length == 1
    return " #{num}"
  else
    return num
  end
end

def total_visits(country) # string
  COUNTRIES[country.to_sym].length
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

sorted_rollup = rollup.sort_by { |k,v| v }.reverse # turn into list sorted by days descending
total_days = (Date.today - Date.strptime(START_DATE, "%Y-%m-%d")).to_i

# HTML view
puts "\nHTML:\n\n<table>\n<tr><td><b>country</b></td><td><b>days</b></td><td><b>visits</b></td></tr>"

sorted_rollup.each do |e|
  country = e[0]
  days = e[1]
  puts "<tr><td>#{remove_underscores(country)} </td><td>#{days}</td><td>#{total_visits(country)}</td></tr>"
end

puts "</table>\n<table>\n<tr><td><b>total days traveled </b></td><td><b>#{total_days}</b></td></tr>\n</table>\n\n"

# human readable view
puts "\nCOUNTRIES (#{TOTAL_COUNTRIES})  DAYS (#{total_days}) | VISITS\n-----------------------------------"

sorted_rollup.each do |e|
  country = e[0]
  days = e[1]
  printf("%-#{SPACER}s %s\n", "#{remove_underscores(country)}:", "#{front_pad(days)}         | #{total_visits(country)}")
end

puts
