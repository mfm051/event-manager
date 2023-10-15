require 'csv' 

def clean_phone_number(phone_number)
  raw_phone_number = phone_number.to_s
  clean_number = raw_phone_number.split('').keep_if { |element| ('0'..'9').include?(element) }.join

  return 'BAD NUMBER' unless (10..11).include?(clean_number.length)

  return 'BAD NUMBER' if clean_number.length == 11 && clean_number.start_with?('1') == false

  clean_number = clean_number.delete_prefix('1') if clean_number.length == 11
  
  clean_number
end

contents = CSV.open('event_attendees.csv', 
  headers: true, 
  header_converters: :symbol
)

contents.each do |row|
  phone_number = clean_phone_number(row[:homephone])

  puts phone_number
end