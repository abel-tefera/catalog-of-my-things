class Genre
  attr_accessor :name
  attr_reader :id, :items

  def initialize(id, name)
    @id = id
    @name = name
    @items = []
  end

  def add_item(item)
    @items << item
    item.add_genre(self)
  end
end
