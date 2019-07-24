class Fruit
  def initialize(name)
    name = name # does nothing
  end
end

class Pizza
  def initialize(name)
    @name = name #instance variable assigned the value name
  end
end

p Fruit.new('banana')
p Pizza.new('12in')