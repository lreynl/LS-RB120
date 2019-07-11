class Person
  attr_accessor :name

  def initialize(name)
    @name = name
  end

#  def name
#    "#{@name}"
#  end

#  def name=(name)
#    @name = name
#  end
  def name_uc
    "#{name.upcase}"
  end

  def hi
    "Hi, I'm #{name}"
  end
end

me = Person.new('LER')
puts me.hi
you = Person.new("they")
puts you.hi
puts me.name
puts you.name
you.name = "them"
puts you.hi
puts you.name_uc