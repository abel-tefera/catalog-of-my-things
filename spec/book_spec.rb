require_relative '../book'

describe Book do
  it('should create a book with correct publisher') do
    book = Book.new('Mega', 'bad', '10-10-2010')
    expect(book.publisher).to eq('Mega')
  end

  it('should correctly check if it can be archived') do
    book1 = Book.new('Mega', 'bad', Date.new(2010, 10, 10))
    expect(book1.can_be_archived?).to eq(true)

    book2 = Book.new('Mega', 'good', Date.new(2020, 10, 10))
    expect(book2.can_be_archived?).to eq(false)

    book3 = Book.new('Mega', 'good', Date.new(2010, 10, 10))
    expect(book3.can_be_archived?).to eq(true)

    book4 = Book.new('Mega', 'bad', Date.new(2020, 10, 10))
    expect(book4.can_be_archived?).to eq(true)
  end
end
