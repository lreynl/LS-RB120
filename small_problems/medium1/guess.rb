class GuessGame
  attr_reader :max, :min
  
  def initialize
    @number = nil
    @player = Player.new
    @guesses = nil
    @min = nil
    @max = nil
  end

  def play
    get_min_max_numbers
    init_number
    @guesses = calculate_guesses
    until @guesses == 0
      guesses_remaining(@guesses)
      guess = @player.guess(@guesses, min, max)
      break if guess == @number
      compare_to_number(guess)
      @guesses -= 1
    end
    win_or_lose(@guesses)
  end

  private

  def get_min_max_numbers
    choice = ''
    loop do
      print "Enter the smallest number the computer can choose: "
      choice = gets.chomp.to_i
      break unless choice < 0
      puts "Number should be positive!"
    end
    @min = choice
    choice = ''
    loop do
      print "Enter the largest number the computer can choose: "
      choice = gets.chomp.to_i
      break unless choice <= @min
      puts "Number should be bigger than the first number!"
    end
    @max = choice
  end

  def calculate_guesses
    @guesses = Math.log2(@max - @min).to_i + 1
  end

  def win_or_lose(guesses)
    if guesses == 0
      puts "Out of tries... the number was #{@number}."
    else
      puts "Good guess!"
    end
  end

  def guesses_remaining(guesses)
    puts "You have #{guesses} guesses left."
  end

  def init_number
    p @min
    p @max
    @number = Array(@min..@max).sample
  end

  def compare_to_number(guess)
    if @number < guess
      puts "Too high!"
    else
      puts "Too low!"
    end
  end
end

class Player
  def guess(guesses, min, max)
    choice = ''
    loop do
      print "Enter number between #{min} and #{max} "
      choice = gets.chomp.to_i
      break unless choice < 0
      puts "You should at least choose a positive number..."
    end
    choice
  end
end

game = GuessGame.new
game.play
