class MyCar
  MAX_SPEED = 100
  BRAKE_INCREMENT = 10

  attr_accessor :color
  attr_reader :model, :year

  def self.mpg(gallons_used, miles_traveled)
    (miles_traveled / gallons_used.to_f).round(1)
  end
  
  def initialize(year, color, model)
    @year  = year
    @color = color
    @model = model
    @current_speed = 0
    @car_on = false
  end

  def speed_up
    @current_speed += 5 unless @current_speed >= MAX_SPEED
  end

  def brake
    if @current_speed < BRAKE_INCREMENT
      @current_speed = 0
    else
      @current_speed -= 10
    end
  end

  def turn_off
    @car_on = false
  end

  def turn_on
    @car_on = true
  end

  def spray_paint(color)
    self.color = color
  end

  def to_s
    "Year: #{year}\n"  \
    "Model #{model}\n" \
    "Color #{color}\n"
  end
end

car = MyCar.new("2019", 'white', 'Model 3')
puts car