class Author
  attr_accessor: items
  def initialize (id, first_name, last_name)
    @id = id
    @first_name = first_name
    @last_name = last_name
    @items = []
  end

  def add_item(item)
    @items << (item, self)
  end
end
