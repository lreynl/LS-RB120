class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231" # accesses instance variable template directly
  end

  def show_template
    template # calls getter method
  end
end


class Computer
  attr_accessor :template

  def create_template
    self.template = "template 14231" # calls setter method
  end

  def show_template
    self.template # calls getter method
  end
end