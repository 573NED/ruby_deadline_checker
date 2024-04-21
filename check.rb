require 'timecop'
require 'json'

def is_holiday?(check_date)
  holidays = JSON.parse(File.read('consultant2024.json'))['holidays']
  holidays.include?(check_date.strftime("%Y-%m-%d"))
end

def count (type, number, input_date)
  today = Date.new(input_date.year, input_date.month, 1)
  if type == 1 then
    workdays = 0
    while workdays < number do
      today += 1
      next if is_holiday?(today)
      workdays += 1
    end
  else 
    (1...number).each do |input_date|
      today += 1
    end
  end
  today
end

def check_monthly_report(today)
  deadline = count(1, 10, today)
  if today <= deadline
    result = deadline
  else
    today =  today.next_month
    result = count(1, 10, today)
  end
  result
end

def check_quarter(type, today)
  while today.month != 4 && today.month != 7 && today.month != 10
    today = today.next_month
  end
  if type == 10 then
    deadline = count(1, 10, today)
    if today <= deadline
      result = deadline
    else
      result = count(1, 10, today)
    end
  else
    count(0, 30, today)
  end
end

check_date = Time.parse("2024-01-15")
check_date = Date.new(check_date.year, check_date.month, check_date.day)
monthly_deadline = check_monthly_report(check_date)
quarter10_deadline = check_quarter(10, check_date)
quarter30_deadline = check_quarter(30, check_date)

tempereddddd = (quarter10_deadline - check_date).to_i

Timecop.freeze(check_date) do
  puts "крайний день сдачи месячной      отчетности #{monthly_deadline}"
  puts "крайний день сдачи квартальной10 отчетности #{quarter10_deadline}"
  puts "крайний день сдачи квартальной30 отчетности #{quarter30_deadline}"
  puts tempereddddd
end