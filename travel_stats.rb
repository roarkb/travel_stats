#!/usr/bin/env ruby

require "date"

# "country name" => [day count of last visit, arrival date if current country? else 0]
COUNTRIES = {
  :thailand    => [42, 0],
  :india       => [51, 0],
  :nepal       => [49, 0],
  :indonesia   => [86, 0],
  :malaysia    => [27, 0],
  :brunei      => [3,  0],
  :singapore   => [14, 0],
  :usa         => [13, 0],
  :philippines => [19, 0],
  :myanmar     => [0, "2014-1-12"],
}

TODAY = Date.today

country_list = {}
country_name_length = 0
total_country_days = 0

COUNTRIES.each do |country,array|
  if array[1] == 0
    country_list[country] = array[0]
  else
    cur_country = country
    cur_country_days = (TODAY - Date.strptime(array[1], "%Y-%m-%d") + array[0]).to_i
    country_list[cur_country] = cur_country_days
  end
 
  l = country.to_s.length
  if l > country_name_length
    country_name_length = l
  end
end

total_days = (TODAY - Date.strptime("2013-3-11", "%Y-%m-%d")).to_i
spacer = country_name_length + 1
total_country_days = 0

puts
country_list.sort_by {|k,v| v}.reverse.each do |country,days|
  total_country_days += days
  printf("%-#{spacer}s %s\n", "#{country.to_s}:", days)
end

puts "\ntotal days traveled: #{total_days}"
puts "aprox nights spent in transit: #{total_days - total_country_days}\n\n"
