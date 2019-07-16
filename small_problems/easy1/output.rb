class Pet
  attr_reader :name

  def initialize(name)
    @name = name.to_s
  end

  def to_s
    #@name.upcase!
    "My name is #{@name.upcase}." #just return the upcase-ed name instead of mutating
  end
end
=begin
name = 'Fluffy'
fluffy = Pet.new(name)
puts fluffy.name
puts fluffy
puts fluffy.name
puts name
=end
name = 42
fluffy = Pet.new(name)
name += 1
puts "fluffy.name: " + fluffy.name
puts "fluffy obj: " + fluffy.to_s
puts "fluffy.name: " + fluffy.name
puts "name: " + name.to_s