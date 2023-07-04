require_relative '../author'

describe Author do
  author = Author.new('John', 'Doe')
  context 'When creating a new author' do
    it 'should create an author with the correct first name' do
      expect(author.first_name).to eq('John')
    end
    it 'should create an author with the correct last name' do
      expect(author.last_name).to eq('Doe')
    end
  end
end
