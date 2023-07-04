require_relative '../game'

describe Game do
  game = Game.new(Date.new(2010, 1, 1), false, Date.new(2021, 1, 1))
  context 'When creating a new game' do
    it 'should create a game with the correct published date attributes' do
      expect(game.publish_date).to eq(Date.new(2010, 1, 1))
    end
    it 'should create a game with archived equal false' do
      expect(game.archived).to eq(false)
    end
    it 'should create a game with multiplayer equal false' do
      expect(game.multiplayer).to eq(false)
    end
    it 'should create a game with the correct last_played_at attributes' do
      expect(game.last_played_at).to eq(Date.new(2021, 1, 1))
    end
  end

  context '#can_be_archived?' do
    it 'returns true for items older than 10 years and last_played_at greater than 2 years' do
      Date.today
      (11 * 365)
      expect(game.can_be_archived?).to be(true)
    end
  end
end
