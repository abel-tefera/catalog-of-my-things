require_relative 'game'
require_relative 'author'
require 'json'

# method to fetch data from json file
  def fetch_data(file_name)
    if File.exist?("db/#{file_name}.json")
      File.read("db/#{file_name}.json")
    else
      empty_json = [].to_json
      File.write("db/#{file_name}.json", empty_json)
      empty_json
    end
  end

  # method to get data from json file
  def load_data
    games = JSON.parse(fetch_data('games'))
    authors = JSON.parse(fetch_data('authors'))

    games.each do |game|
      @games << Game.new(game['publish_date'], game[' multiplayer'], game['last_played_at'])
    end

    authors.each do |author|
      @authors << Author.new(author['first_name'], author['last_name'])
    end
  end

  # method to create a game
  def create_game
    puts 'What is the first name of the author of the game:'
    first_name = gets.chomp

    puts 'What is the last name of the author of the game:'
    last_name = gets.chomp

    puts 'What is the published date of the game:'
    publish_date = gets.chomp

    puts 'How many player is required:'
    multiplayer = gets.chomp

    puts 'What was the game last played:'
    last_played_at = gets.chomp

    game = Game.new(publish_date, multiplayer, last_played_at)
    @game << game

    author = Author.new(first_name, last_name)
    author.add_item(game)
    @authors << author

    puts 'Game created successfully.'
  end

  #method to save game
  def save_game
    all_games = []

    @games.each do |game|
      all_games << { 'id' => game.id, 'publish_date' => game.publish_date, 'multiplayer' => game.multiplayer, 'last_played_at' => game.last_played_at }
    end
    File.write('db/games.json', JSON.pretty_generate(all_games))
      all_games << { 'title' => book.title, 'author' => book.author }

  end

  #method to save author
  def save_author
    all_authors = []

    @authors.each do |author|
    all_authors << { 'first Name' => author.first_name, 'last Name' => author.last_name }
    end
    File.write('db/authors.json', JSON.pretty_generate(all_authors))
  end
