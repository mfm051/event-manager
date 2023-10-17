require 'csv'
require 'time'

contents = CSV.open('event_attendees.csv', 
  headers: true, 
  header_converters: :symbol
)

def max_count_elements(array)
  elements_counts = array.uniq.map { |element| array.count(element) }

  array.uniq.filter { |element| array.count(element) == elements_counts.max }
end

string_dates = contents.map { |row| row[:regdate] }

registration_dates = string_dates.map { |date| Time.strptime(date, "%m/%d/%y %H:%M") }

registration_days_indexes = registration_dates.map(&:wday)

peak_day_indexes = max_count_elements(registration_days_indexes)

days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']

# Days with the most registrations
if peak_day_indexes.one? 
  puts "#{days[peak_day_indexes[0]]} has the most registrations\n\n"
else
  peak_days = peak_day_indexes.each { |index| days[index] }.join(', ')
  puts "#{peak_days} have the most registrations\n\n"
end

# Peak hours per day
(0..6).each do |day_index|
  registrations_at_day = registration_dates.filter { |time| time.wday == day_index }

  hours_with_registration = registrations_at_day.map { |registration_time| registration_time.hour.to_s }
  
  next puts "#{days[day_index]}: No registrations" if hours_with_registration.empty?

  peak_hours = max_count_elements(hours_with_registration)
  
  if peak_hours.one?
    puts "#{days[day_index]}: #{peak_hours[0]}h"
  else
    peak_hours = peak_hours.map { |hour| hour + 'h' }.join(', ')
    puts "#{days[day_index]}: #{peak_hours}"
  end
end