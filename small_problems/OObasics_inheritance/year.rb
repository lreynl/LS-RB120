class Vehicle
  attr_reader :year

  def initialize(year)
    @year = year
  end
end

class Car < Vehicle
end

class Truck < Vehicle

  def start_engine(speed)
    puts "Ready to go! Gotta go #{speed}!"
  end
end

car = Car.new(2006)
truck = Truck.new(1959)

puts car.year
puts truck.year
truck.start_engine('slow')