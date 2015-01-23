#!/usr/bin/env ruby

# EXAMPLE: ./pro_rate.rb 2014-6-18 2014-7-17 19.94

require "date"

abort "\nEXAMPLE: '#{$0} 2014-6-18 2014-7-17 19.94'\n\n" unless ARGV.length == 3

IN_DATE = Date.strptime("2014-7-5", "%Y-%m-%d")
OUT_DATE = Date.strptime("2015-1-1", "%Y-%m-%d")
#OUT_DATE = nil

start_date = Date.strptime(ARGV[0], "%Y-%m-%d") # YYYY-MM-DD
end_date = Date.strptime(ARGV[1], "%Y-%m-%d") # YYYY-MM-DD
full_amount = ARGV[2].to_f # 00.00
full_days = end_date - start_date + 1

def round_it(int)
  '%.2f' % [(int * 100).round / 100.0]
end

if OUT_DATE == nil
  if start_date < IN_DATE
    pr = "yes"
    charge_days = end_date - IN_DATE + 1 
    percent_days = round_it(charge_days / full_days * 100).to_f
    charge_amount = round_it(full_amount * (percent_days / 100)).to_f
    note = "pro-rate #{charge_days} of #{full_days} days (#{percent_days}%)"
  else
    pr = "no"
    charge_days = full_days
    charge_amount = full_amount
    note = "none"
  end
else
  if end_date > OUT_DATE
    pr = "yes"
    charge_days = OUT_DATE - start_date
    percent_days = round_it(charge_days / full_days * 100).to_f
    charge_amount = round_it(full_amount * (percent_days / 100)).to_f
    note = "pro-rate #{charge_days} of #{full_days} days (#{percent_days}%)"
  else
    pr = "no"
    charge_days = full_days
    charge_amount = full_amount
    note = "none"
  end
end

puts "
   start date: #{start_date}
     end date: #{end_date}
  full amount: $#{full_amount}
    pro rate?: #{pr}
charge amount: $#{charge_amount}
         note: #{note}
\n"
