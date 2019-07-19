require 'io/console'

module Prompt
  def prompt(msg)
    print "> #{msg}"
  end
end

class Move
  attr_reader :value

  def scissors?
    self.class.to_s.downcase == 'scissors'
  end

  def rock?
    self.class.to_s.downcase == 'rock'
  end

  def paper?
    self.class.to_s.downcase == 'paper'
  end

  def lizard?
    self.class.to_s.downcase == 'lizard'
  end

  def spock?
    self.class.to_s.downcase == 'spock'
  end

  def lose_to_rock?
    scissors? || lizard?
  end

  def lose_to_paper?
    rock? || spock?
  end

  def lose_to_scissors?
    paper? || lizard?
  end

  def lose_to_lizard?
    spock? || paper?
  end

  def lose_to_spock?
    scissors? || rock?
  end

  def >(other_move)
    (rock? && other_move.lose_to_rock?) ||
      (paper? && other_move.lose_to_paper?) ||
      (scissors? && other_move.lose_to_scissors?) ||
      (lizard? && other_move.lose_to_lizard?) ||
      (spock? && other_move.lose_to_spock?)
  end

  def <(other_move)
    (lose_to_rock? && other_move.rock?) ||
      (lose_to_paper? && other_move.paper?) ||
      (lose_to_scissors? && other_move.scissors?) ||
      (lose_to_lizard? && other_move.lizard?) ||
      (lose_to_spock? && other_move.spock?)
  end
  
  def to_s
    self.class.to_s.downcase
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
  attr_reader :score, :match_wins, :move_history, :other_player_move_history
  KEY = { r:  ['rock', '[r]ock'], p: ['paper', '[p]aper'],
          s:  ['scissors', '[s]cissors'], l: ['lizard', '[l]izard'],
          sp: ['spock', '[sp]ock'] }

  def initialize
    @score = 0
    @match_wins = 0
    @name = 'default'
    @move_history = []
    @other_player_move_history = []
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

  def append_move_history(move)
    self.move_history << move
  end

  def append_others_history(move)
    self.other_player_move_history << move
  end

  def display_move_history
    puts self.move_history
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
    self.move = move_type(choice)
  end
end

class Computer < Player
  def analyze_human_history
    move_count = Hash.new(0)
    self.other_player_move_history.each { |move| move_count[move] += 1 }
    sorted_moves = move_count.values.sort
    most_frequent_move = sorted_moves[-1]
    move_count = move_count.invert
p move_count[most_frequent_move]

    move_count[most_frequent_move]
  end
  
  def recommend_move
    if self.other_player_move_history.length <= 5
      move_type(KEY.keys.sample.to_s)
    else
      move = analyze_human_history
      case 
      when move.lose_to_rock?     then Rock.new
      when move.lose_to_paper?    then Paper.new
      when move.lose_to_scissors? then Scissors.new
      when move.lose_to_lizard?   then Lizard.new
      when move.lose_to_spock?    then Spock.new
      end
    end
  end
    
  def choose
    self.move = recommend_move
  end
end

class RPSgame
  include Prompt
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
    @to_win = 5
  end

  def display_welcome_message
    prompt("🗿📄✂🦎🖖️ Rock, Paper, Scissors, Lizard, Spock Game 🗿📄✂🦎🖖️\n")
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

  def append_player_history
    self.human.append_move_history(self.human.move)
    self.human.append_others_history(self.computer.move)
    self.computer.append_move_history(self.computer.move)
    self.computer.append_others_history(self.human.move)
  end

  def display_player_history
    puts "#{self.human.name}'s move history:"
    self.human.display_move_history
    puts "#{self.computer.name}'s move history:"
    self.computer.display_move_history
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
      append_player_history
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
    display_player_history
  end
end

game = RPSgame.new
game.play
