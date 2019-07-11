#a module is like a class with only methods;
#it adds functionality to a class
module Name
  def print_name
    puts 'LER'
  end
end

class Person
  include Name
end

me = Person.new
me.print_name()