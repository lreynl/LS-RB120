class Minilang
  def initialize(program)
    @program = program
    @register = 0
    @stack = []
  end

  def machine(ops)
    op_list = numbers_to_ints(ops.split)
#    return puts 'invalid input' unless valid?(op_list)
    until op_list.empty?
      op = op_list.shift
      if !valid?(op)
        puts "Invalid operation: #{op}"
        break
      end
      set_register(num) if op.class == Integer
      push     if op == 'PUSH'
      add(op)  if op == 'ADD'
      subtract if op == 'SUB'
      multiply if op == 'MULT'
      divide   if op == 'DIV'
      modulo   if op == 'MOD'
      printout if op == 'PRINT'
      pop      if op == 'POP'
    end
  end

  def eval
    machine(program)
  end

  private

  attr_accessor :register, :stack
  attr_reader :program

  def set_register(num)
    register = num
  end

  def push
    stack.push(register)
  end

  def add(op)
    register += stack.pop
  end

  def subtract
    register -= stack.pop
  end

  def multiply
    register *= stack.pop
  end

  def divide
    begin
      register /= stack.pop
    rescue
      puts 'Error: division by 0!'
    end
  end

  def modulo
    begin
      register %= stack.pop
    rescue
      puts 'Error: division by 0!'
    end
  end

  def printout
    puts register
  end

  def pop
    if op == 'POP'
      if stack.empty?
        puts 'Empty stack!'
        break
      else
        register = stack.pop
      end
    end
  end
    
  def numbers_to_ints(op_list)
    op_list.map { |op| op.to_i.to_s == op ? op.to_i : op }
  end
  
  def valid?(op)
    valid_ops = %w(PUSH POP PRINT ADD SUB MULT DIV MOD)
    valid_ops.include?(op) || op.class == Integer
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