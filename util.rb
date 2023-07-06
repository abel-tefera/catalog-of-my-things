def fetch_data(file)
  if File.exist?("db/#{file}.json")
    File.read("db/#{file}.json")
  else
    empty_json = [].to_json
    File.write("db/#{file}.json", empty_json)
    empty_json
  end
end

def date_valid?(date)
  format = '%Y-%m-%d'
  DateTime.strptime(date, format)
  true
rescue ArgumentError
  false
end
