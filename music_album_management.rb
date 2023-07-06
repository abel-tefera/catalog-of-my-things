require_relative 'music_album'
require_relative 'genre'
require_relative 'util'
require 'json'
require 'date'

def load_music
  genres = JSON.parse(fetch_data('genres'))
  albums = JSON.parse(fetch_data('albums'))

  genres.each do |genre|
    @genres << Genre.new(genre['id'], genre['name'])
  end

  albums.each do |album|
    date_string = album['publish_date']
    publish_date = Date.parse(date_string)

    music_album = MusicAlbum.new(publish_date, on_spotify: album['on_spotify'])
    genre = @genres.find { |gen| gen.id == album['genre_id'] }
    genre.add_item(music_album)
    # Decide if to archive or not and assign archive attribute
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

def collect_date
  date = ''
  until date_valid?(date)
    print 'What is the publish date(YYYY-MM-DD): '
    date = gets.chomp
  end
  puts "\n"
  date
end

def collect_inputs
  date = collect_date

  genre = ''
  until (1..@genres.length).include?(genre)
    puts 'Select a genre from the following list by number'
    @genres.each_with_index do |gen, index|
      puts "#{index + 1}) #{gen.name}"
    end
    genre = gets.chomp.to_i
  end
  puts "\n"

  on_spotify = ''
  until %w[n y].include?(on_spotify)
    print 'Is this album on spotify? [y/n]: '
    on_spotify = gets.chomp.downcase
  end

  [date, genre, on_spotify]
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
  publish_date = Date.parse(inputs[0])

  case inputs[2]
  when 'n'
    music_album = MusicAlbum.new(publish_date, on_spotify: false)
    @albums << music_album
  when 'y'
    music_album = MusicAlbum.new(publish_date, on_spotify: true)
    @albums << music_album
  end

  # Assign genre
  @genres[inputs[1] - 1].add_item(music_album)

  # Decide if to archive or not and assign archive attribute
  music_album.move_to_archive

  save_albums
  puts 'Music album added successfully'
  puts "\n"
end
