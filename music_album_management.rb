require_relative 'music_album'
require_relative 'genre'
require_relative 'author'
require 'json'

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
  # labels = JSON.parse(fetch_data('labels'))
  authors = JSON.parse(fetch_data('authors'))

  albums = JSON.parse(fetch_data('albums'))

  genres.each do |genre|
    @genres << Genre.new(genre['id'], genre['name'])
  end

  authors.each do |author|
    @authors << Author.new(author['first_name'], author['last_name'])
  end

  albums.each do |album|
    music_album = MusicAlbum.new(album['publish_date'], on_spotify: album['on_spotify'])
    genre = @genres.find { |genre| genre.id == album['genre_id'] }
    label = @labels.find { |label| label.id == album['label_id'] }
    author = @authors.find { |author| author.id == album['author_id'] }
    genre.add_item(music_album)
    label.add_item(music_album)
    author.add_item(music_album)
    music_album.can_be_archived?
    @albums << music_album
  end
end

def list_albums
  @albums.each do |album|
    genre = @genres.find { |genre| genre.id == album.genre.id }
    label = @labels.find { |label| label.id == album.label.id }
    author = @authors.find { |author| author.id == album.author.id }
    puts "ID: #{album.id}, Genre: #{genre.name}, Label: #{label.title}, Author: #{author.first_name} #{author.last_name}"
  end
end

def list_genres
  @genres.each { |genre| puts "\"#{genre.name}\"" }
end

def get_inputs
  print 'What is the publish date(YYYY/MM/DD): '
  date = gets.chop
  puts "\n"

  puts 'Select an author from the following list by number'
  @authors.each_with_index do |author, index|
    puts "#{index}) #{author.first_name} #{author.last_name}"
  end
  author = gets.chomp.to_i
  puts "\n"

  puts 'Select a label from the following list by number'
  @labels.each_with_index do |label, index|
    puts "#{index}) #{label.title}"
  end
  label = gets.chomp.to_i
  puts "\n"

  puts 'Select a genre from the following list by number'
  @genres.each_with_index do |genre, index|
    puts "#{index}) #{genre.name}"
  end
  genre = gets.chomp.to_i
  puts "\n"

  return date, author, label, genre
end

def save_albums
  updated_albums = []

  @albums.each do |album|
    updated_albums << { 'id' => album.id, 'genre_id' => album.genre.id, 'author_id' => album.author.id,
    'label_id' => album.label.id, 'publish_date' => album.publish_date, 'archived' => album.archived, 'on_spotify' => album.on_spotify }
  end

  File.write('db/albums.json', JSON.pretty_generate(updated_albums))
end

def add_album
  inputs = get_inputs
  print 'Is this album on spotify? [Y/N]: '
  on_spotify = gets.chomp.downcase

  case on_spotify
  when 'n'
    music_album = MusicAlbum.new(inputs[0], on_spotify: false)
    @albums << music_album
  when 'y'
    music_album = MusicAlbum.new(inputs[0], on_spotify: true)
    @albums << music_album
  end

  #Assign genre, label, source, author
  @genres[inputs[3]].add_item(music_album)
  @labels[inputs[2]].add_item(music_album)
  @authors[inputs[1]].add_item(music_album)
  
  # Determine if to archive or not
  music_album.can_be_archived?

  save_albums

  puts 'Music album added successfully'
  puts "\n"
end

