module Stuff
  class FirstClass
    def identify
      puts "I'm in first class"
    end
  end

  def SecondClass
    def identify
      puts "I'm in second class"
    end
  end
end

class Test
  include Stuff
end

tryme = Test.new
other = tryme.FirstClass.new
other.identify
