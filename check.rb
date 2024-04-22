require 'timecop'
require 'json'

def is_holiday?(check_date)
  holidays = JSON.parse(File.read('consultant2024.json'))['holidays'] + JSON.parse(File.read('consultant2025.json'))['holidays']
  holidays.include?(check_date.strftime("%Y-%m-%d"))
end

def count_date (number, day)
  day = Date.new(day.year, day.month, 1)
  if number == 10 then
    workdays = 0
    while workdays < number do
      day += 1
      next if is_holiday?(day)
      workdays += 1
    end
  else 
    (1...number).each do day += 1
    end
  end
  day
end

def check_monthly(today)
  result = count_date(10, today)
  result <= today ? result = count_date(10, today.next_month) : result
end

def check_quarter(ndays, today)
  while today.month != 4 && today.month != 7 && today.month != 10
    today = today.next_month
  end
  ndays == 10 ? check_monthly(today) : count_date(30, today)
end

def check_yearly (ndays, today)
  day = Date.new(today.year, 1, 1)
  if ndays == 10 then
    result = check_monthly(day) 
    (result - today).to_i <= 0 ? result = check_monthly(day.next_year) : result
  else
    result = count_date(30, day)
    (result - today).to_i <= 0 ? result = count_date(30, result.next_year) : result
  end
end

def calculate_days_and_find_closest(check_date)
  days_to_monthly = (check_monthly(check_date) - check_date).to_i
  days_to_quarter10 = (check_quarter(10, check_date) - check_date).to_i
  days_to_quarter30 = (check_quarter(30, check_date) - check_date).to_i
  days_to_yearly10 = (check_yearly(10, check_date) - check_date).to_i
  days_to_yearly30 = (check_yearly(30, check_date) - check_date).to_i

  min_days = [days_to_monthly, days_to_quarter10, days_to_quarter30, days_to_yearly10, days_to_yearly30].min
  
  closest_deadlines = []
  days_to_monthly == min_days ? closest_deadlines << "#{check_monthly(check_date)} месячная (через #{min_days} дней)" : nil
  days_to_quarter10 == min_days ? closest_deadlines << "#{check_quarter(10, check_date)} квартальная 10 рабочих (через #{min_days} дней)" : nil
  days_to_quarter30 == min_days ? closest_deadlines << "#{check_quarter(30, check_date)} квартальная 30 календарных (через #{min_days} дней)" : nil
  days_to_yearly10 == min_days ? closest_deadlines << "#{check_yearly(10, check_date)} годовая 10 рабочих (через #{min_days} дней)" : nil
  days_to_yearly30 == min_days ? closest_deadlines << "#{check_yearly(30, check_date)} годовая 30 календарных (через #{min_days} дней)" : nil

  closest_deadlines.each do |deadline|
    puts deadline
  end
end

check_date = Time.now
date = Date.new(check_date.year, check_date.month, check_date.day)
calculate_days_and_find_closest(date)