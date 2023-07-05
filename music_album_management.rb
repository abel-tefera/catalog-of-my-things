require_relative 'music_album'
require_relative 'genre'
require 'json'
require 'date'

def fetch_data(file)
  if File.exist?("db/#{file}.json")
    File.read("db/#{file}.json")
  else
    empty_json = [].to_json
    File.write("db/#{file}.json", empty_json)
    empty_json
  end
end

def load_music
  genres = JSON.parse(fetch_data('genres'))
  albums = JSON.parse(fetch_data('albums'))

  genres.each do |genre|
    @genres << Genre.new(genre['id'], genre['name'])
  end

  albums.each do |album|
    date_string = album['publish_date']
    year = date_string[0, 4].to_i
    month = date_string[5, 7].to_i
    day = date_string[8, 10].to_i

    music_album = MusicAlbum.new(Date.new(year, month, day), on_spotify: album['on_spotify'])
    genre = @genres.find { |gen| gen.id == album['genre_id'] }
    genre.add_item(music_album)
    # Determine if to archive or not
    music_album.move_to_archive
    @albums << music_album
  end
end

def list_albums
  puts 'LIST OF ALBUMS'
  @albums.each do |album|
    genre = @genres.find { |gen| gen.id == album.genre.id }
    puts "ID: #{album.id}, Genre: #{genre.name}, Archived: #{album.archived}, On Spotify: #{album.on_spotify}"
  end
end

def list_genres
  puts 'LIST OF GENRES'
  @genres.each { |genre| puts "ID: #{genre.id}, Name: #{genre.name}" }
end

def date_valid?(date)
  format = '%Y-%m-%d'
  DateTime.strptime(date, format)
  true
rescue ArgumentError
  false
end

def collect_inputs
  date = ''
  until date_valid?(date)
    print 'What is the publish date(YYYY-MM-DD): '
    date = gets.chomp
  end
  puts "\n"

  puts 'Select a genre from the following list by number'
  @genres.each_with_index do |genre, index|
    puts "#{index}) #{genre.name}"
  end
  genre = gets.chomp.to_i
  puts "\n"

  [date, genre]
end

def save_albums
  updated_albums = []

  @albums.each do |album|
    updated_albums << { 'id' => album.id, 'genre_id' => album.genre.id, 'publish_date' => album.publish_date.to_s,
                        'archived' => album.archived, 'on_spotify' => album.on_spotify }
  end

  File.write('db/albums.json', JSON.pretty_generate(updated_albums))
end

def add_album
  inputs = collect_inputs

  year = inputs[0][0, 4].to_i
  month = inputs[0][5, 7].to_i
  day = inputs[0][8, 10].to_i
  
  print 'Is this album on spotify? [Y/N]: '
  on_spotify = gets.chomp.downcase

  case on_spotify
  when 'n'
    music_album = MusicAlbum.new(Date.new(year, month, day), on_spotify: false)
    @albums << music_album
  when 'y'
    music_album = MusicAlbum.new(Date.new(year, month, day), on_spotify: true)
    @albums << music_album
  end

  # Assign genre
  @genres[inputs[1]].add_item(music_album)

  # Determine if to archive or not
  music_album.move_to_archive

  save_albums
  puts 'Music album added successfully'
  puts "\n"
end
