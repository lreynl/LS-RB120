module NotSwimmable
  def swim
    "can't swim!"
  end
end

module NotFetchable
  def fetch
    "can't fetch!"
  end
end

class Dog
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end

  def run
    'running!'
  end

  def jump
    'jumping!'
  end

  def fetch
    'fetching!'
  end
end

class Cat < Dog
  include NotSwimmable
  include NotFetchable
  def speak
    'meow'
  end
end  

class Bulldog < Dog
  include NotSwimmable
end

teddy = Dog.new
puts teddy.speak
puts teddy.swim

spot = Bulldog.new
puts spot.speak
puts spot.swim

tabby = Cat.new
puts tabby.run
puts tabby.swim
puts tabby.fetch
puts tabby.speak