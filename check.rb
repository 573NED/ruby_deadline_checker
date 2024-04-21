require 'timecop'
require 'json'

def is_holiday?(check_date)
  holidays = JSON.parse(File.read('consultant2024.json'))['holidays']
  holidays.include?(check_date.strftime("%Y-%m-%d"))
end

def count_date (type, number, input_date)
  today = Date.new(input_date.year, input_date.month, 1)
  if type == 1 then
    workdays = 0
    while workdays < number do
      today += 1
      next if is_holiday?(today)
      workdays += 1
    end
  else 
    (1...number).each do today += 1
    end
  end
  today
end

def check_monthly(today)
  deadline = count_date(1, 10, today)
  if today <= deadline
    result = deadline
  else
    today =  today.next_month
    result = count_date(1, 10, today)
  end
  result
end

def check_quarter(type, today)
  while today.month != 4 && today.month != 7 && today.month != 10
    today = today.next_month
  end
  if type == 10 then
    deadline = count_date(1, 10, today)
    if today <= deadline
      result = deadline
    else
      result = count_date(1, 10, today.next_month)
    end
  else
    count_date(0, 30, today)
  end
end

def near_deadline (deadline1, deadline2, deadline3, today)
  a = (deadline1 - today).to_i 
  b = (deadline2 - today).to_i 
  c = (deadline3 - today).to_i 
  result = case 
    when a < b && a < c then "#{deadline1} | через #{a} дней | месячная"
    when b < a && b < c then "#{deadline2} | через #{b} дней | квартальная 10 рабочих"
    when c < a && c < b then "#{deadline3} | через #{c} дней | квартальная 30 календарных "
    when a == b then "#{deadline1} | через #{a} дней | месячная\n#{deadline2} | через #{b} дней | квартальная 10 рабочих"
  end
end

check_date = Time.parse("2024-04-01")
check_date = Date.new(check_date.year, check_date.month, check_date.day)
monthly_deadline = check_monthly(check_date)
quarter10_deadline = check_quarter(10, check_date)
quarter30_deadline = check_quarter(30, check_date)
tempereddddddd = near_deadline(monthly_deadline, quarter10_deadline, quarter30_deadline, check_date)

Timecop.freeze(check_date) do
  puts tempereddddddd
end