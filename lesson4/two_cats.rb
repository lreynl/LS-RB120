class AngryCat
  def initialize(age, name)
    @age  = age
    @name = name
  end

  def age
    puts @age
  end

  def name
    puts @name
  end

  def hiss
    puts "Hisssss!!!"
  end
end

cat1 = AngryCat.new(2, 'Stupid')
cat2 = AngryCat.new(3, 'Ugly')
cat1.name
cat1.age
cat2.name
cat2.age