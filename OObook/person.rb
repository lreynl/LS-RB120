class Person
  attr_accessor :first_name, :last_name
  
  def initialize(init_name)
    set_name(init_name)
  end

  def name
    if @last_name.nil? || @last_name.empty?
      p @first_name
    else
      p @first_name + ' ' + @last_name
    end
  end

  def name=(full_name)
    set_name(full_name)
  end

  def compare_name(person_obj)
    self.name == person_obj.name
  end

  def to_s
    name
  end

  private

  def set_name(full_name)
    split_name = full_name.split(' ')
    @first_name = split_name[0]
    @last_name = split_name[1]
  end
  
end

bob = Person.new('Robert')
bob.name
bob.first_name
bob.last_name
bob.last_name = 'Smith'
bob.name

john = Person.new('John smith')
john.name
p john.first_name
p john.last_name

john_s = Person.new('John smith')

p john_s.compare_name(john)

puts "The person's name is: #{bob}"
