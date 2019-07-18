module Prompt
  def prompt(msg)
    print "> #{msg}"
  end
end

class Move
  attr_reader :OPTIONS, :value
  OPTIONS = %w(r p s) # l sp)

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (paper? && other_move.scissors?) ||
      (scissors? && other_move.rock?)
  end

  def to_s
    @value
  end
end

class Player
  include Prompt
  attr_accessor :move
  KEY = { r: ['rock', '[r]ock'], p: ['paper', '[p]aper'],
          s: ['scissors', '[s]cissors'] } # , l: ['lizard', '[l]izard'],
  # sp: ['spock', '[sp]ock'] }

  def valid_move_choice?(choice)
    Move::OPTIONS.include?(choice)
  end
end

class Human < Player
  def choose
    choice = ''
    loop do
      options_list = ''
      KEY.each_value { |val| options_list += val[1] + ' ' }
      prompt("Choose #{options_list}: ")
      choice = gets.chomp.downcase
      break choice if valid_move_choice?(choice)
      prompt("That wasn't an option!\n")
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def choose
    self.move = Move.new(Move::OPTIONS.sample)
  end
end

class RPSgame
  include Prompt
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
    @to_win = 5
    @key = { r: ['rock', '[r]ock'], p: ['paper', '[p]aper'],
             s: ['scissors', '[s]cissors'] }.freeze # , l:['lizard','[l]izard'],
    # sp: ['spock', '[sp]ock'] }
    # l:  ['paper', 'spock'],
    # sp: ['rock', 'scissors'] }.freeze
  end

  def display_welcome_message
    prompt("🗿📄✂️ Rock, Paper, Scissors Game 🗿📄✂️\n")
    prompt("First to #{@to_win} wins!\n")
    prompt("\n")
  end

  def display_goodbye_message
    prompt("Thanks of playing!\n")
  end

  def display_winner
    winner = decide_winner(human.move.value, computer.move.value)
    display_results(winner)
  end

  def decide_winner(player, comp)
    if player > comp
      'player'
    elsif player < comp
      'comp'
    else
      'tie'
    end
  end

  def display_results(winner)
    prompt("#{@key[human.move.value.to_sym][0]} vs. " \
           "#{@key[computer.move.value.to_sym][0]} ... ")
    case winner
    when 'tie'
      print "TIE\n"
    when 'player'
      print "You Win!\n"
    when 'comp'
      print "Computer Wins!\n"
    end
  end

  def again?
    do_again = ' '
    loop do
      prompt("REMATCH? (y/n) ")
      do_again = gets.chomp.downcase
      next if do_again.length.zero?
      break true if do_again == 'y'
      break false if do_again == 'n'
      prompt("That wasn't an option!\n")
    end
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_winner
      break unless again?
    end
    display_goodbye_message
  end
end

game = RPSgame.new
game.play
