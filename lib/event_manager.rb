require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zip(zip)
  zip.to_s[0, 5].rjust(5, '0')
end

def legislators_by_zip(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    legislators = civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
  ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')
  
  filename = "output/thanks_#{id}.html"
  File.open(filename, 'w') { |file| file.puts form_letter }
end

contents = CSV.open('event_attendees.csv', 
  headers: true, 
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

contents.each do |row|
  name = row[:first_name]
  zip = clean_zip(row[:zipcode])
  legislators = legislators_by_zip(zip)

  id = row[0]
  form_letter = erb_template.result(binding)

  save_thank_you_letter(id,form_letter)
end