require_relative '../music_album'
require_relative '../item'

describe MusicAlbum do
  before :all do
    @ulbum1 = MusicAlbum.new Date.new(2006, 6, 9)
    @ulbum2 = MusicAlbum.new(Date.new(2010, 4, 2), on_spotify: true)
  end

  describe 'inheriting from the Item class' do
    it 'inherits from the Item class' do
      expect(described_class).to be < Item
    end
  end

  describe 'creating a new MusicAlbum' do
    context 'when only publish date is given' do
      it 'takes one parameter and returns a MusicAlbum object' do
        expect(@ulbum1).to be_instance_of MusicAlbum
      end
    end

    context 'when two parameters are given' do
      it 'takes two parameters and returns a MusicAlbum object' do
        expect(@ulbum2).to be_instance_of MusicAlbum
      end
    end
  end

  describe '.publish_date' do
    it 'returns the correct id' do
      expect(@ulbum1.publish_date).to eq(Date.new(2006, 6, 9))
      expect(@ulbum2.publish_date).to eq(Date.new(2010, 4, 2))
    end
  end

  describe '.archived' do
    it 'returns false for archived attribute on newly created MusicAlbums' do
      expect(@ulbum1.archived).to be false
      expect(@ulbum2.archived).to be false
    end
  end

  describe '.on_spotify' do
    it 'it returns the right value' do
      expect(@ulbum1.on_spotify).to be false
      expect(@ulbum2.on_spotify).to be true
    end
  end

  describe '#can_be_archived? method' do
    it 'returns the right value' do
      result1 = @ulbum1.can_be_archived?
      result2 = @ulbum2.can_be_archived?
      expect(result1).to be false
      expect(result2).to be true
    end
  end

  describe '#move_to_archive method' do
    it 'returns the right value' do
      @ulbum1.move_to_archive
      @ulbum2.move_to_archive
      expect(@ulbum1.archived).to be false
      expect(@ulbum2.archived).to be true
    end
  end
end
