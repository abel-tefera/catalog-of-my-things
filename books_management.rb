require_relative 'book'
require_relative 'label'
require_relative 'util'
require 'json'

def load_books_json
  books = JSON.parse(fetch_data('books'))
  labels = JSON.parse(fetch_data('labels'))

  books.each do |book|
    date_string = book['publish_date']
    year = date_string[0, 4].to_i
    month = date_string[5, 7].to_i
    day = date_string[8, 10].to_i

    @books << Book.new(book['publisher'], book['cover_state'], Date.new(year, month, day))
  end

  labels.each do |label|
    @labels << Label.new(label['title'], label['color'])
  end
end

def save_book
  books_arr = []

  @books.each do |book|
    books_arr << { 'id' => book.id,
                   'publisher' => book.publisher,
                   'cover_state' => book.cover_state,
                   'publish_date' => book.publish_date }
  end

  File.write('db/books.json', JSON.pretty_generate(books_arr))
end

def save_label
  labels_arr = []

  @labels.each do |label|
    labels_arr << { 'title' => label.title,
                    'color' => label.color }
  end

  File.write('db/labels.json', JSON.pretty_generate(labels_arr))
end

def add_book # rubocop:disable Metrics/MethodLength
  puts 'What is the title of the book?'
  title = gets.chomp

  puts 'What is the color of the book?'
  color = gets.chomp

  puts 'Who is the publisher?'
  publisher = gets.chomp

  puts 'What is the condition of the cover? (good/bad)'
  cover_state = gets.chomp.downcase

  publish_date = ''
  until date_valid?(publish_date)
    puts 'On what date was the book published? (YYYY-MM-DD)'
    publish_date = gets.chomp
  end

  book = Book.new(publisher, cover_state, Date.parse(publish_date))
  @books << book

  label = Label.new(title, color)
  label.add_item(book)

  @labels << label

  book.move_to_archive

  save_book
  save_label

  puts 'Book created successfully!'
end

def list_books
  @books.each do |book|
    puts '------------------------------'
    puts "Publisher: #{book.publisher} "
    puts "Cover Condition: #{book.cover_state} "
    puts "Published on: #{book.publish_date}"
    puts '------------------------------'
  end
end

def list_labels
  @labels.each { |label| puts "Title: #{label.title} color: #{label.color}" }
end
