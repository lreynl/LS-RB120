class Student
  attr_reader :name
#  attr_writer :grade

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(other_grade)
    request_grade > other_grade.request_grade
  end

  protected

  def request_grade
    @grade
  end

  def to_s
    "Name: #{name} Grade: #{request_grade}"
  end
end

me = Student.new("LR", 90)
you = Student.new("Somebody", 89)
puts "Well done, #{me.name}." if me.better_grade_than?(you)
puts me