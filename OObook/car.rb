class Vehicle
  attr_accessor :color, :model, :speed, :car_on
  attr_reader :year, :TYPE
  @@inventory_size = 0

  def self.inventory
    puts "There are #{@@inventory_size} vehicles currently."
  end
  
  def initialize(year, color, model)
    @@inventory_size += 1
    @year = year
    @color = color
    @model = model
    @speed = 0
    @car_on = false
  end

  def to_s
    "This is a #{color} #{year} #{model}."
  end

  def accelerate
    self.speed += 10 unless speed >= 100 || car_on == false
  end

  def slow_down
    if speed <= 10
      self.speed = 0
    else
      self.speed -= 10
    end
  end

  def powered_on?
    "#{car_on}"
  end

  def turn_off
    self.car_on = false if self.speed.zero?
  end

  def turn_on
    self.car_on = true
  end

  def self.calculate_mpg(miles, gallons_used)
    "The MPG is #{miles / gallons_used.to_f}."
  end

  def spray_paint=(new_color)
    puts "Old color: #{self.color}."
    self.color = new_color
    puts "New color: #{self.color}!"
  end

  def age
    calc_age
  end

  private

  def calc_age
    current_year = Time.new.year
    current_year - year
  end  
end  

module Navigation
  attr_accessor :nav_active
  @@nav_active = false

  def nav_on?
    @@nav_active
  end

  def toggle_nav_system
    @@nav_active = !@@nav_active
  end
end

class MyCar < Vehicle
  include Navigation
  
  TYPE = 'sedan'

  def self.what_am_i
    "I'm just a #{TYPE}"
  end

end

class MyTruck < Vehicle
  TYPE = 'pickup'

  def self.what_am_i
    "I'm just a #{TYPE}"
  end

end  
  

car = MyCar.new(2006, 'black', 'prius')
puts car
car.accelerate
puts car.powered_on?
puts car.turn_on
puts car.powered_on?
puts car.year
puts car.color
puts car.speed
car.accelerate
car.accelerate
puts car.speed
car.slow_down
puts car.speed
car.spray_paint = 'yellow'
puts car.color
puts MyCar.what_am_i
puts car
puts MyCar.calculate_mpg(500, 10)

truck = MyTruck.new(1959, 'green', 'Apache')
puts truck
puts MyTruck.what_am_i
Vehicle.inventory
p car.nav_on?
car.toggle_nav_system
p car.nav_on?
p MyCar.ancestors
p MyTruck.ancestors

puts "car is #{car.age} years old"
puts "truck is #{truck.age} years old"