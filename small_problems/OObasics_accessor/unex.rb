class Person
  def initialize
    @first_name = ''
    @last_name = ''
  end
  
  def name=(new_name)
    split_name = new_name.split(' ')
    @first_name = split_name[0]
    @last_name = split_name[1]
  end

  def name
    "#{@first_name} #{@last_name}"
  end
  
end

person1 = Person.new
person1.name = 'John Doe'
puts person1.name