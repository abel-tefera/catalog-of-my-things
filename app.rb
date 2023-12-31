require_relative 'books_management'
require_relative 'game_management'
require_relative 'music_album_management'

class App
  attr_accessor :books, :albums, :games

  def initialize
    @books = []
    @albums = []
    @games = []
    @labels = []
    @authors = []
    @genres = []
  end

  def list_games
    list_all_games
  end

  def list_authors
    list_all_authors
  end

  def add_game
    create_game
  end

  def fetch_files
    load_books_json
    load_music
    load_game_json
  end

  def save_and_exit
    puts 'Thank you for using this app. Goodbye!'
    exit
  end

  def invalid_option
    puts 'Invalid option'
  end

  def options
    puts 'Please choose an option from the following: '
    puts '1 - List all books'
    puts '2 - List all music albums'
    puts '3 - List all games'
    puts '4 - List all genres'
    puts '5 - List all labels'
    puts '6 - List all authors'
    puts '7 - Add a book'
    puts '8 - Add a music album'
    puts '9 - Add a game'
    puts '10 - Exit'
  end
end
