class Cat
  def initialize(type)
    @type = type
  end

  def to_s
    "I'm a #{@type} cat."
  end
end

kitty = Cat.new('fluffy')
puts kitty
