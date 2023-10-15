require 'csv'
require 'time'

contents = CSV.open('event_attendees.csv', 
  headers: true, 
  header_converters: :symbol
)

registration_dates = contents.map { |row| row[:regdate] }

registration_times = registration_dates.map { |date| Time.strptime(date, "%m/%d/%y %H:%M") }

(0..6).each do |day_index|
  days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']

  registrations_in_day = registration_times.filter { |time| time.wday == day_index }

  hours_with_registration = registrations_in_day.map(&:hour)

  return puts "#{days[day_index]}: No registrations" if hours_with_registration.empty?

  # limitation: when there are two hours with the same count, this method picks the smaller one 
  peak_hour = hours_with_registration.max do |a,b|
    hours_with_registration.count(a) <=> hours_with_registration.count(b)
  end

  puts "#{days[day_index]}: #{peak_hour}h"
end