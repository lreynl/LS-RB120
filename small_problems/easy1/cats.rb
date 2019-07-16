class Pet
  def initialize(name, age)
    @name = name
    @age = age
  end
end

class Cat < Pet
  def initialize(name, age, coloration)
    super(name, age)
    @coloration = coloration
  end

  def to_s
    "My cat #{name} is #{age} years old and has #{coloration} fur."
  end

  private

  attr_reader :name, :age, :coloration
end

pudding = Cat.new('Pudding', 7, 'black and white')
butterscotch = Cat.new('Butterscotch', 10, 'tan and white')
puts pudding, butterscotch