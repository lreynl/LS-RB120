module Walkable
  def walk
    puts "#{self.name} #{gait} forward." 
  end
end

class Person
  include Walkable
  
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "strolls"
  end
end

class Noble < Person
  attr_reader :title
  
  def initialize(name, title)
    super(name)
    @title = title
  end

  def walk
    "#{self.title} #{self.name} #{gait} forward."
  end

  private
  
  def gait
    "struts"
  end
end

byron = Noble.new("Byron", "Lord")
puts byron.walk