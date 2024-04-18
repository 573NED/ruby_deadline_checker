require 'timecop'
require 'json'

def is_holiday?(user_date)
  holidays = JSON.parse(File.read('consultant2024.json'))['holidays']
  holidays.include?(user_date.strftime("%Y-%m-%d"))
end

date_to_check = Time.parse("2024-01-01")

Timecop.freeze(date_to_check) do
  puts is_holiday?(date_to_check) ? 'Выходной' : 'Рабочий день'
end