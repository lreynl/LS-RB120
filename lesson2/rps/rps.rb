require 'io/console'

module Prompt
  def prompt(msg)
    print "> #{msg}"
  end
end

class Move
  attr_reader :value
=begin
  def initialize(value)
    if value == 'spock' || value == 'sp'
      @value = 'sp'
    else
      @value = value[0].downcase
    end
  end
=end

  def scissors?
    self.class.to_s.downcase == 'scissors'
  end

  def rock?
    self.class.to_s.downcase == 'rock'
  end

  def paper?
    self.class.to_s.downcase == 'paper'
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
    self.value
  end
end

class Rock < Move

end

class Paper < Move

end

class Scissors < Move

end

class Lizard < Move

end

class Spock < Move

end

class Player
  include Prompt
  attr_accessor :move, :name
  attr_reader :score, :match_wins
  KEY = { r: ['rock', '[r]ock'], p: ['paper', '[p]aper'],
          s: ['scissors', '[s]cissors'] } # , l: ['lizard', '[l]izard'],
  # sp: ['spock', '[sp]ock'] }

  def initialize
    @score = 0
    @match_wins = 0
    @name = 'default'
  end

  def valid_move_choice?(choice)
    choice.downcase!
    options_list = []
    KEY.each_value { |val| options_list << val[0] }
    KEY.keys.include?(choice.to_sym) || options_list.include?(choice)
  end

  def increment_score
    self.score += 1
  end

  def increment_match_wins
    self.match_wins += 1
  end

  def reset_score
    self.score = 0
  end

  def move_type(move)
    if    move == 'r'  || move == 'rock'
      Rock.new
    elsif move == 'p'  || move == 'paper'
      Paper.new
    elsif move == 's'  || move == 'scissors'
      Scissors.new
    elsif move == 'l'  || move == 'lizard'
      Lizard.new
    elsif move == 'sp' || move == 'spock'
      Spock.new
    end
  end
  
  protected

  attr_writer :score, :match_wins
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
    self.move = move_type(choice)#Move.new(choice)
  end
end

class Computer < Player
  def choose
    #self.move = Move.new(KEY.keys.sample.to_s)
    move = move_type(KEY.keys.sample.to_s)
    self.move = move#_type(KEY.keys.sample.to_s)
    p move
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
    display_results(decide_winner)
  end

  def decide_winner
    if human.move > computer.move
      'player'
    elsif human.move < computer.move
      'comp'
    else
      'tie'
    end
  end

  def display_results(winner)
    prompt("#{human.move.class.to_s.upcase} vs. " \
           "#{computer.move.class.to_s.upcase} ... ")
    case winner
    when 'tie'
      print "TIE\n"
    when 'player'
      print "You Win!\n"
    when 'comp'
      print "Computer Wins!\n"
    end
  end

  def increment_score(type)
    winner = decide_winner
    return nil if winner == 'tie'
    if type == :round
      winner == 'player' ? human.increment_score : computer.increment_score
    elsif type == :match
      winner == 'player' ? human.increment_match_wins :
                           computer.increment_match_wins
    end
  end    

  def show_final_score
    prompt("Match score... \n")
    prompt("#{human.name.upcase}: #{human.match_wins}. " \
           "#{computer.name.upcase}: #{computer.match_wins}.\n")
  end

  def show_current_score
    prompt("#{human.name.upcase}: #{human.score} " \
           "#{computer.name.upcase}: #{computer.score}\n")
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

  def match_ended?
    human.score == @to_win || computer.score == @to_win
  end

  def press_any_key
    prompt('press any key...')
    STDIN.getch
  end
  
  def clear_screen
    system('clear') || system('cls')
  end

  def reset_scores
    human.reset_score
    computer.reset_score
  end

  def match_loop
    loop do
      human.choose
      computer.choose
      display_winner
      increment_score(:round)
      show_current_score      
      if match_ended?
        increment_score(:match)
        break
      end
    end
  end

  def play
    clear_screen
    display_welcome_message
    press_any_key
    clear_screen
    loop do
      match_loop
      show_final_score
      break unless again?
      clear_screen
      reset_scores
    end
    display_goodbye_message
  end
end

game = RPSgame.new
game.play
