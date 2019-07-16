class PrivateTest
  attr_reader :var

  def initialize(var)
    @var = var
  end

  def change_var(arg)
    self.var = arg
  end

  def reset_var(arg)
    self.var = arg
  end

  private

  attr_writer :var
end

stuff = PrivateTest.new(12345)
p stuff.var
stuff.change_var(9876)
p stuff.var
stuff.reset_var(555)
p stuff.var