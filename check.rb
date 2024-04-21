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
  if result <= today
    result = count_date(10, today.next_month)
  else
    result
  end
end

def check_quarter(days, today)
  while today.month != 4 && today.month != 7 && today.month != 10
    today = today.next_month
  end
  if days == 10 then
    check_monthly(today)
  else
    count_date(30, today)
  end
end

def check_yearly (days, today)
  day = Date.new(today.year+1, 1, 1)
  if days == 10 then
    check_monthly(day) 
  else
    count_date(30, day)
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

  if days_to_monthly == min_days
    closest_deadlines << "#{check_monthly(check_date)} месячная (через #{min_days} дней)"
  end
  if days_to_quarter10 == min_days
    closest_deadlines << "#{check_quarter(10, check_date)} квартальная 10 рабочих (через #{min_days} дней)"
  end
  if days_to_quarter30 == min_days
    closest_deadlines << "#{check_quarter(30, check_date)} квартальная 30 календарных (через #{min_days} дней)"
  end
  if days_to_yearly10 == min_days
    closest_deadlines << "#{check_yearly(10, check_date)} годовая 10 рабочих (через #{min_days} дней)"
  end
  if days_to_yearly30 == min_days
    closest_deadlines << "#{check_yearly(30, check_date)} годовая 30 календарных (через #{min_days} дней)"
  end

  closest_deadlines.each do |deadline|
    puts deadline
  end
end

check_date = Time.parse("2024-12-20")
check_date = Date.new(check_date.year, check_date.month, check_date.day)

Timecop.freeze(check_date) do
  calculate_days_and_find_closest(check_date)
end