class App
  attr_accessor :books, :albums, :games

  def initialize
    @books = []
    @albums = []
    @games = []
  end

  def list_books
    puts 'Feature loading...'
  end

  def list_albums
    puts 'Feature loading...'
  end

  def list_games
    puts 'Feature loading...'
  end

  def list_genres
    puts 'Feature loading...'
  end

  def list_labels
    puts 'Feature loading...'
  end

  def list_authors
    puts 'Feature loading...'
  end

  def list_sources
    puts 'Feature loading...'
  end

  def add_book
    puts 'Feature loading...'
  end

  def add_album
    puts 'Feature loading...'
  end

  def add_game
    puts 'Feature loading...'
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
    puts '7 - List all sources'
    puts '8 - Add a book'
    puts '9 - Add a music album'
    puts '10 - Add a game'
    puts '11 - Exit'
  end
end
