class MiniLangError < StandardError
end

class InvalidOpError < MiniLangError
end

class StackEmptyError < MiniLangError
end

class Minilang
  VALID_OPS = %w(PUSH POP PRINT ADD SUB MULT DIV MOD).freeze

  def initialize(program)
    @program = program
    @register = 0
    @stack = []
  end

  def eval(arg = nil)
    if arg
      program = format(@program, arg)
      machine(program)
    else
      machine(@program)
    end
  end

  private

  def machine(ops)
    op_list = numbers_to_ints(ops.split)
    begin
      until op_list.empty?
        op = op_list.shift
        unless valid?(op)
          raise InvalidOpError, "Error: invalid operation #{op}"
        end
        if op.class == Integer
          write_register(op)
        else
          send op.downcase.to_sym
        end
      end
    rescue ZeroDivisionError
      puts 'Error: divison by 0!'
    rescue MiniLangError => e
      puts e.message
    end
  end

  def write_register(num)
    @register = num
  end

  def push
    @stack.push(@register)
  end

  def add
    stack_empty?
    @register += @stack.pop
  end

  def sub
    stack_empty?
    @register -= @stack.pop
  end

  def mult
    stack_empty?
    @register *= @stack.pop
  end

  def div
    stack_empty?
    @register /= @stack.pop
  end

  def mod
    stack_empty?
    @register %= @stack.pop
  end

  def print
    puts @register
  end

  def pop
    stack_empty?
    @register = @stack.pop
  end

  def numbers_to_ints(op_list)
    op_list.map { |op| op.to_i.to_s == op ? op.to_i : op }
  end

  def valid?(op)
    VALID_OPS.include?(op) || op.class == Integer
  end

  def stack_empty?
    raise StackEmptyError, 'Error: empty stack!' if @stack.empty?
  end
end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)

Minilang.new('0 PUSH 5 DIV PUSH PRINT').eval

CENTIGRADE_TO_FAHRENHEIT = '5 PUSH %<degrees_c>d PUSH 9 MULT DIV PUSH 32 ADD PRINT'
minilang = Minilang.new(CENTIGRADE_TO_FAHRENHEIT)
minilang.eval(degrees_c: 0)
minilang.eval(degrees_c: 25)
minilang.eval(degrees_c: -40)
minilang.eval(degrees_c: 100)

AREA_OF_SQUARE = '%<side_1>d PUSH %<side_2>d MULT PRINT'
minilang = Minilang.new(AREA_OF_SQUARE)
minilang.eval({side_1: 5, side_2: 5})
