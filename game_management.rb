require_relative 'game'
require_relative 'author'
require_relative 'util'
require 'json'

# method to get data from json file
def load_game_json
  games = JSON.parse(fetch_data('games'))
  authors = JSON.parse(fetch_data('authors'))

  authors.each do |author|
    @authors << Author.new(author['id'], author['first_name'], author['last_name'])
  end

  games.each do |game|
    publish_date = Date.parse(game['publish_date'])
    last_played_at = Date.parse(game['last_played_at'])
    new_game = Game.new(publish_date, game['multiplayer'], last_played_at)
    author = @authors.find { |auth| auth.id == game['author_id'] }

    author.add_item(new_game)
    # Decide if to archive or not and assign archive attribute
    new_game.move_to_archive
    @games << new_game
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
    publish_date = Date.parse(date_string)

    music_album = MusicAlbum.new(publish_date, on_spotify: album['on_spotify'])
    genre = @genres.find { |gen| gen.id == album['genre_id'] }
    genre.add_item(music_album)
    # Decide if to archive or not and assign archive attribute
    music_album.move_to_archive
    @albums << music_album
  end
end

# method to save game
def save_game
  all_games = []

  @games.each do |game|
    all_games << { 'id' => game.id, 'publish_date' => game.publish_date.to_s, 'multiplayer' => game.multiplayer,
                   'last_played_at' => game.last_played_at.to_s, 'archived' => game.archived,
                   'author_id' => game.author.id }
  end
  File.write('db/games.json', JSON.pretty_generate(all_games))
end

def collect_input
  author = ''
  until (1..@authors.length).include?(author)
    puts 'Select an author from the following list by number'
    @authors.each_with_index do |auth, index|
      puts "#{index + 1}) #{auth.first_name} #{auth.last_name}"
    end
    author = gets.chomp.to_i
  end

  publish_string_date = ''
  until date_valid?(publish_string_date)
    print 'What is the publish date of the game(YYYY-MM-DD): '
    publish_string_date = gets.chomp
  end
  publish_date = Date.parse(publish_string_date)

  [author, publish_date]
end

# method to create a game
def create_game
  inputs = collect_input

  multiplayer = 0
  until multiplayer > 0
    puts 'How many player is required (number must be greater than 0): '
    multiplayer = gets.chomp.to_i
  end

  last_played_string_date = ''
  until date_valid?(last_played_string_date)
    print 'When was the game last played(YYYY-MM-DD): '
    last_played_string_date = gets.chomp
  end
  last_played_at = Date.parse(last_played_string_date)

  game = Game.new(inputs[1], multiplayer, last_played_at)
  game.move_to_archive
  @games << game

  @authors[inputs[0] - 1].add_item(game)
  save_game
  puts 'Game created successfully.'
end

# Method to list all authors
def list_all_authors
  return puts 'There are no author in the collection yet!' if @authors.empty?

  puts 'List of all authors:'
  @authors.each do |author|
    puts '------------------------------'
    puts "Id: #{author.id} "
    puts "Fist Name: #{author.first_name} "
    puts "Last Name: #{author.last_name}"
    puts '------------------------------'
  end
end

# Method to list all games
def list_all_games
  return puts 'There are No game in the collection yet!' if @games.empty?

  puts 'List of all games:'
  @games.each do |game|
    puts '------------------------------'
    puts "Published date: #{game.publish_date} "
    puts "Multiplayer: #{game.multiplayer}"
    puts "Last played date: #{game.last_played_at}"
    puts '------------------------------'
  end
end
