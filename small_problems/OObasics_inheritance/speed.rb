class Vehicle
  def start_engine
    'Ready to go!'
  end
end

class Truck < Vehicle
  def start_engine(speed)
    super() + " Gotta go #{speed}!"
  end
end

truck1 = Truck.new
puts truck1.start_engine('fast')