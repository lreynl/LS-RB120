class BeesWax
  attr_accessor :type
  
  def initialize(type)
    @type = type
  end
=begin
  def type
    @type
  end

  def type=(t)
    @type = t
  end
=end
  def describe_type
    puts "I am a #{type} of Bees Wax"
  end
end

BeesWax.new('block').describe_type