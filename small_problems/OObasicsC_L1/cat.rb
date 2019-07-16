module Walkable
  def walk
    puts "Let's go for a walk!"
  end
end

class Cat
  include Walkable
  attr_accessor :name
  
  def initialize(name)
    @name = name
  end

  def greet
    puts "My name is #{name}!"
  end
end

kitty = Cat.new('buddy')
kitty.greet
kitty.name = "noel"
kitty.greet
kitty.walk