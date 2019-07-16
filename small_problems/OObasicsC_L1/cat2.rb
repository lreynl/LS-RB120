class Cat
  attr_accessor :name
  @@cat_count = 0
  COLOR = 'black'
      
  def self.generic_greeting
    puts "I'm a #{COLOR} cat!"
  end

  def initialize(name)
    @name = name
    @@cat_count += 1
  end

  def personal_greeting
    puts "My name is #{name} and I'm #{COLOR}"
  end

  def rename(name)
    self.name = name
  end

  def identify
    self.inspect
  end

  def self.total
    puts @@cat_count
  end

  def to_s
    "I'm #{name}!"
  end
end

Cat.generic_greeting
kitty = Cat.new('sophie')
p kitty.class
kitty.class.generic_greeting
p kitty.name
kitty.rename('noel')
p kitty.name
puts kitty.identify
kitty.personal_greeting
kitty2 = Cat.new('mittens')
Cat.total
puts kitty
puts kitty2