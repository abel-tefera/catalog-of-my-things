require_relative 'book'
require_relative 'label'
require 'json'

def fetch_json(file)
  if File.exist?("db/#{file}.json")
    File.read("db/#{file}.json")
  else
    placeholder = [].to_json
    File.write("db/#{file}.json", placeholder)
    placeholder
  end
end

def load_books_json
  books = JSON.parse(fetch_json('books'))
  labels = JSON.parse(fetch_json('labels'))

  books.each do |book|
    @books << Book.new(book['publisher'], book['cover_state'], book['published_at'])
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
                   'published_at' => book.publish_date }
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

def add_book
  puts 'What is the title of the book?'
  title = gets.chomp

  puts 'What is the color of the book?'
  color = gets.chomp

  puts 'Who is the publisher?'
  publisher = gets.chomp

  puts 'What is the condition of the cover? (good/bad)'
  cover_state = gets.chomp.downcase

  puts 'On what date was the book published?'
  published_at = gets.chomp

  book = Book.new(publisher, cover_state, published_at)
  @books << book

  label = Label.new(title, color)
  label.add_item(book)

  @labels << label

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
