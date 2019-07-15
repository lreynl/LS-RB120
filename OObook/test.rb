class Test
  attr_accessor :var
  def initialize(new_var)
    @var = new_var
  end
  def change_var(new_var)
    self.var = new_var
  end
  def p_var
    #p self.var
    puts "#{var}"
  end
end

stuff = Test.new(1234)
stuff.p_var
stuff.change_var(9876)
stuff.p_var