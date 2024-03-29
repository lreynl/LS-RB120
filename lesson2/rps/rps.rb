require 'io/console'

module Prompt
  def prompt(msg)
    print "> #{msg}"
  end
end

class Move
  attr_reader :value

  KEY = { r:  ['rock', '[r]ock'], p: ['paper', '[p]aper'],
          s:  ['scissors', '[s]cissors'], l: ['lizard', '[l]izard'],
          sp: ['spock', '[sp]ock'] }.freeze

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

  def self.rock_move?(move)
    ['r', 'rock'].include?(move)
  end

  def self.paper_move?(move)
    ['p', 'paper'].include?(move)
  end

  def self.scissors_move?(move)
    ['s', 'scissors'].include?(move)
  end

  def self.lizard_move?(move)
    ['l', 'lizard'].include?(move)
  end

  def self.spock_move?(move)
    ['sp', 'spock'].include?(move)
  end

  def self.create_move(move)
    if    rock_move?(move)
      Rock.new
    elsif paper_move?(move)
      Paper.new
    elsif scissors_move?(move)
      Scissors.new
    elsif lizard_move?(move)
      Lizard.new
    elsif spock_move?(move)
      Spock.new
    end
  end

  def to_s
    self.class.to_s.downcase
  end
end

class Rock < Move
  def >(other_move)
    other_move.scissors? || other_move.lizard?
  end
end

class Paper < Move
  def >(other_move)
    other_move.rock? || other_move.spock?
  end
end

class Scissors < Move
  def >(other_move)
    other_move.paper? || other_move.lizard?
  end
end

class Lizard < Move
  def >(other_move)
    other_move.spock? || other_move.paper?
  end
end

class Spock < Move
  def >(other_move)
    other_move.scissors? || other_move.rock?
  end
end

class Player
  attr_accessor :move
  attr_reader :name, :score, :match_wins

  def initialize
    @score = 0
    @match_wins = 0
    @name = ''
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

  def input_name
    name = ''
    loop do
      prompt("What's your name? ")
      name = gets.chomp
      break unless name.empty?
    end
    @name = name
  end

  def append_move_history(move)
    move_history << move
  end

  def display_move_history
    puts move_history
  end

  def reset_history
    @move_history = []
  end

  private

  include Prompt

  attr_writer :score, :match_wins, :name
end

class Human < Player
  def choose
    choice = ''
    loop do
      options_list = ''
      Move::KEY.each_value { |val| options_list += val[1] + ' ' }
      prompt("Choose #{options_list}: ")
      choice = gets.chomp.downcase
      break choice if valid_move_choice?(choice)
      prompt("That wasn't an option!\n")
    end
    self.move = Move.create_move(choice)
  end

  private

  def valid_move_choice?(choice)
    choice.downcase!
    options_list = []
    Move::KEY.each_value { |val| options_list << val[0] }
    Move::KEY.key?(choice.to_sym) || options_list.include?(choice)
  end
end

class Computer < Player
  # HAL has skill 3 and tries to win as fast as possible
  # R2D2 has skill 1 because he doesn't have hands or speak english
  # Data is skill 0 because he tries to tie every time
  #  in order to play indefinitely
  # Johnny 5 is in between
  COMPUTER_NAMES_SKILL = { 'hal' => 3, 'johnny5' => 2,
                           'r2d2' => 1, 'data' => 0 }

  # After how many human moves does the computer start
  # to base its move on the human player's
  TRACK_PLAYER_COUNT = 3

  def initialize
    super()
    input_name
  end

  def choose(human_history)
    self.move = recommend_move(human_history)
  end

  private

  attr_accessor :skill

  def input_name
    set_computer_name_skill
  end

  def set_computer_name_skill
    comp_player = COMPUTER_NAMES_SKILL.keys.sample
    @name = comp_player
    @skill = COMPUTER_NAMES_SKILL[comp_player]
  end

  def string_to_move_obj(str)
    case str
    when 'rock'     then Rock.new
    when 'paper'    then Paper.new
    when 'scissors' then Scissors.new
    when 'lizard'   then Lizard.new
    when 'spock'    then Spock.new
    end
  end

  # Gets a player's most frequently chosen move
  def analyze_human_history(history)
    move_count = Hash.new(0)
    # Every move object is different, so to make a
    # hash with objects as keys they need to be
    # converted to strings and back
    history.each { |move| move_count[move.to_s] += 1 }
    most_frequent_move = move_count.values.max
    move = move_count.key(most_frequent_move)
    move = string_to_move_obj(move)
    adjust_for_skill(move)
  end

  def skill_0_choose(move)
    if move.rock?
      Rock.new
    elsif move.paper?
      Paper.new
    elsif move.scissors?
      Scissors.new
    elsif move.lizard?
      Lizard.new
    elsif move.spock?
      Spock.new
    end
  end

  def skill_1_choose
    Move.create_move(Move::KEY.keys.sample.to_s)
  end

  def skill_2_choose(move)
    if [true, false].sample
      skill_1_choose
    else
      skill_3_choose(move)
    end
  end

  def skill_3_choose(move)
    if move.lose_to_rock?
      Rock.new
    elsif move.lose_to_paper?
      Paper.new
    elsif move.lose_to_scissors?
      Scissors.new
    elsif move.lose_to_lizard?
      Lizard.new
    elsif move.lose_to_spock?
      Spock.new
    end
  end

  def adjust_for_skill(move)
    case skill
    when 0
      skill_0_choose(move)
    when 1
      skill_1_choose
    when 2
      skill_2_choose(move)
    when 3
      skill_3_choose(move)
    end
  end

  def recommend_move(history)
    if history.length <= TRACK_PLAYER_COUNT
      skill_1_choose
    else
      move = analyze_human_history(history)
      self.move = move
    end
  end
end

class RPSgame
  def initialize
    @human = Human.new
    @computer = Computer.new
    @to_win = 5
    @human_history = []
    @computer_history = []
  end

  def play
    display_title_screen
    human.input_name
    display_opponent
    loop do
      match_loop
      show_final_score
      break unless again?
      clear_screen
      reset_scores
      reset_histories
    end
    display_goodbye_message
    # display_player_history
  end

  private

  include Prompt
  attr_accessor :human, :computer, :human_history, :computer_history

  def clear_screen
    system('clear') || system('cls')
  end

  def display_title_screen
    clear_screen
    prompt("🗿📄✂🦎🖖️ Rock, Paper, Scissors, Lizard, Spock Game 🗿📄✂🦎🖖\n")
    prompt("\n")
    prompt("First to #{@to_win} wins!\n")
    prompt("\n")
    press_any_key
    clear_screen
  end

  def display_opponent
    prompt("Your opponent is #{computer.name.capitalize}.\n")
  end

  def display_goodbye_message
    prompt("Thanks for playing!\n")
  end

  def display_winner
    display_results(decide_winner)
  end

  def decide_winner
    if human.move > computer.move
      'player'
    elsif computer.move > human.move
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

  def increment_round_score(winner)
    if winner == 'player'
      human.increment_score
    else
      computer.increment_score
    end
  end

  def increment_match_score(winner)
    if winner == 'player'
      human.increment_match_wins
    else
      computer.increment_match_wins
    end
  end

  def increment_score(type)
    winner = decide_winner
    return nil if winner == 'tie'
    if type == :round
      increment_round_score(winner)
    elsif type == :match
      increment_match_score(winner)
    end
  end

  def append_player_history
    human_history << human.move
  end

  def append_computer_history
    computer_history << computer.move
  end

  def display_player_history
    puts "#{human.name}'s move history:"
    puts human_history
    puts "#{computer.name}'s move history:"
    puts computer_history
  end

  def show_final_score
    prompt("\n")
    prompt("Match score... \n")
    prompt("#{human.name.upcase}: #{human.match_wins}. " \
           "#{computer.name.upcase}: #{computer.match_wins}.\n")
    prompt("\n")
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

  def reset_scores
    human.reset_score
    computer.reset_score
  end

  def reset_histories
    self.human_history = []
    self.computer_history = []
  end

  def match_loop
    loop do
      human.choose
      append_player_history
      computer.choose(@human_history)
      append_computer_history
      display_winner
      increment_score(:round)
      show_current_score
      if match_ended?
        increment_score(:match)
        break
      end
      press_any_key
      clear_screen
    end
  end
end

game = RPSgame.new
game.play
