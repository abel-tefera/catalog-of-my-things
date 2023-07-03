require_relative 'item'

class MusicAlbum < Item
  attr_accessor :multiplayer, :last_played_at

  def initialize(publish_date, archived: false, on_spotify: false)
    super(publish_date, archived: false)
    @on_spotify = on_spotify
  end

  def can_be_archived?
    super && on_spotify
  end
end