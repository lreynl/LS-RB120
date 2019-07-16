class Person

  def initialize
    @name = ''
  end
  
  def name=(new_name)
    @name = new_name.downcase.capitalize
  end

  def name
    @name
  end
end

person1 = Person.new
person1.name = 'eLiZaBeTh'
puts person1.name