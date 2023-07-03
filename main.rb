require_relative 'app'

def menu(app)
  app.options
  print 'Prompt > '
  gets.chomp.to_i
end

def manage_selection(app, option)
  tasks = {
    1 => :list_books,
    2 => :list_albums,
    3 => :list_movies,
    4 => :list_genres,
    5 => :list_labels,
    6 => :list_authors,
    7 => :list_sources,
    8 => :add_book,
    9 => :add_album,
    10 => :add_movie,
    11 => :exit,
    default: :invalid_option
  }

  selection = tasks[option] || tasks[:default]
  app.send(selection)

  return unless option == 7

  exit
end

def main
  app = App.new

  puts '------------------------------'
  puts 'Welcome to Catalog of my things!'
  puts '------------------------------'

  loop do
    manage_selection(app, menu(app))
    puts "\n"
  end
end

main
