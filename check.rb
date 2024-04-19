require 'timecop'
require 'json'

def is_holiday?(check_date)
  holidays = JSON.parse(File.read('consultant2024.json'))['holidays']
  holidays.include?(check_date.strftime("%Y-%m-%d"))
end

def count_tenth_workday (input_date)
  first = Date.new(input_date.year, input_date.month, 1)
  workdays_count = 0
  last_day = first
  while workdays_count < 9 do
    last_day += 1
    next if is_holiday?(last_day)
    workdays_count += 1
  end
  last_day
end

def monthly_report(today)
  today = Date.new(today.year, today.month, today.day)
  deadline = count_tenth_workday(today)
  if today <= deadline
    result = today
  else
    today = Date.new(today.year, today.month+1, today.day)
    result = count_tenth_workday(today)
  end

  result
end

check_date = Time.parse("2024-04-19")
tenth_workday = monthly_report(check_date)

Timecop.freeze(check_date) do
  puts "крайний день сдачи месячной отчетности #{tenth_workday}"
end