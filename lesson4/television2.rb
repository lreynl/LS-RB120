class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

tv = Television.new
tv.manufacturer # no method error
tv.model # => model method

Television.manufacturer # => manufacturer class method
Television.model # no method error