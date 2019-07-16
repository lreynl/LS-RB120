class Transform
  def initialize(stuff)
    @data = stuff
  end

  def uppercase
    self.data.upcase
  end

  def self.lowercase(str)
    str.downcase
  end

  protected

  attr_reader :data
end

my_data = Transform.new('abc')
puts my_data.uppercase
puts Transform.lowercase('XYZ')
