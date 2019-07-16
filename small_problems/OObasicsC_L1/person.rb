class Person
  attr_writer :secret

  def share_secret
    puts secret
  end

  def compare_secret(person)
    secret == person.share_secret
  end
  
  protected

  attr_reader :secret

end

person1 = Person.new
person1.secret = "It's a secret to everybody!"
person1.share_secret
person2 = Person.new
person2.secret = "Lets play money making game!"
p person1.compare_secret(person2)