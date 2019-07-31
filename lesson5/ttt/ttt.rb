require 'io/console'

module Prompt
  def prompt(message)
    print "> #{message}"
  end
end

class TTTgame
  HUMAN_PIECE = 'X'
  COMPUTER_PIECE = 'O'
  MATCH = 5
  GOES_FIRST = :choice # or HUMAN_PIECE or COMPUTER_PIECE

  def initialize
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
    @current_player = nil
  end

  def play
    intro
    match_loop
    display_goodbye_message
  end

  private

  include Prompt

  attr_accessor :human, :computer, :board

  def intro
    display_title_screen
    press_any_key
    assign_markers
    assign_names
    reset_current_player
    display_opponent
    press_any_key
  end

  def match_loop
    loop do
      round_loop
      show_board
      tally_score
      display_scores
      display_winner
      display_match_winner(board) if match?
      break unless play_again?
      reset_game
    end
  end

  def round_loop
    loop do
      show_board
      display_scores
      current_player_move
      break if board.winner? || board.full?
      switch_current_player
    end
  end

  def assign_markers
    human.choose_own_piece(computer.piece)
    computer.choose_own_piece
  end

  def assign_names
    human.player_name
    computer.player_name
  end

  def choose_player
    choice = ''
    loop do
      prompt("Do want to go first? (y/n) ")
      choice = gets.chomp.downcase
      break if %w(y n).include?(choice)
      prompt("That wasn't an option!\n")
    end
    choice == 'y' ? @human : @computer
  end

  def display_opponent
    prompt("Your opponent is #{computer.name}.\n")
  end

  def tally_score
    @current_player.increment_score if board.winner
  end

  def play_again?
    choice = ''
    loop do
      prompt("Play again? (y/n) ")
      choice = gets.chomp.downcase
      break if %w(y n).include?(choice)
    end
    choice == 'y'
  end

  def match?
    [human.score, computer.score].include?(MATCH)
  end

  def display_match_winner(board)
    match_winner = if board.winner == @computer.piece
                     'Computer wins'
                   else
                     'You win'
                   end
    prompt("#{match_winner} the match!\n")
  end

  def reset_game
    board.reset
    reset_current_player
    human.reset_score if human.score >= MATCH
    computer.reset_score if computer.score >= MATCH
  end

  def display_scores
    prompt("Score: You, #{human.score} - " \
           "#{@computer.name}, #{computer.score}\n")
  end

  def current_player_move
    @current_player.choose_square(board, human.piece, computer.piece)
    board.set_square_at(@current_player.move, @current_player.piece)
  end

  def switch_current_player
    @current_player = if @current_player.human?
                        @computer
                      else
                        @current_player = @human
                      end
  end

  def reset_current_player
    @current_player = if GOES_FIRST == human.piece
                        @human
                      elsif GOES_FIRST == computer.piece
                        @computer
                      else
                        choose_player
                      end
  end

  def show_board
    clear_screen
    prompt("You're #{@human.piece} - Computer is #{@computer.piece}\n")
    board.draw
  end

  def display_winner
    prompt("You won!\n") if board.winner == @human.piece
    prompt("Computer won!\n") if board.winner == @computer.piece
    prompt("It was a tie!\n") if board.winner.nil?
  end

  def display_title_screen
    clear_screen
    prompt("Ready, set, tic tac toe\n")
    prompt("\n")
    prompt("First to #{MATCH} wins\n")
  end

  def display_goodbye_message
    prompt("Thanks for playing!\n")
  end

  def clear_screen
    system 'clear' || 'cls'
  end

  def press_any_key
    prompt("\n")
    prompt("Press any key...\n")
    STDIN.getch
  end
end

class Board
  WINS = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
         [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
         [[1, 5, 9], [3, 5, 7]].freeze

  attr_reader :winner, :board

  BLANK_SQUARE = ' '

  def initialize
    @board = {}
    reset
    @winner = nil
  end

  def reset
    (1..9).each { |num| set_square_at(num, BLANK_SQUARE) }
  end

  def draw
    puts build_board
  end

  def empty_squares
    board.keys.select { |square| unmarked?(board[square]) }
  end

  def winner?
    !!winning_piece
  end

  def set_square_at(square, piece)
    board[square] = piece
  end

  def full?
    board.keys.none? { |square| unmarked?(board[square]) }
  end

  def empty_squares_list
    empty = empty_squares
    format_empty_squares_list(empty)
  end

  private

  attr_writer :board
  attr_writer :winner

  def unmarked?(square)
    square == BLANK_SQUARE
  end

  def winning_piece
    piece = nil
    WINS.each do |line|
      if winning_line?(line)
        piece = board[line[0]]
        unless piece == BLANK_SQUARE
          self.winner = piece
          return piece
        end
      end
    end
    piece = nil if piece == BLANK_SQUARE
    self.winner = piece
    piece
  end

  def winning_line?(line)
    board[line[0]] == board[line[1]] &&
      board[line[0]] == board[line[2]]
  end

  def build_board
    "   |   |   \n"                               \
    " #{board[1]} | #{board[2]} | #{board[3]} \n" \
    "   |   |   \n"                               \
    "---+---+---\n"                               \
    "   |   |   \n"                               \
    " #{board[4]} | #{board[5]} | #{board[6]} \n" \
    "   |   |   \n"                               \
    "---+---+---\n"                               \
    "   |   |   \n"                               \
    " #{board[7]} | #{board[8]} | #{board[9]} \n" \
    "   |   |   \n"
  end

  def format_empty_squares_list(empty, separator = ',', andor = 'or')
    available = ''
    empty.each_with_index do |square, index|
      square = square.to_s
      available += if index < empty.length - 2
                     square + separator + ' '
                   elsif index == empty.length - 2
                     square + separator + ' ' + andor + ' '
                   else
                     square
                   end
    end
    available
  end
end

class Player
  attr_reader :move, :score
  attr_accessor :piece, :name

  def initialize
    reset_score
    @score = 0
  end

  def human?
    self.class == Human
  end

  def increment_score
    @score += 1
  end

  def reset_score
    @score = 0
  end

  def player_name
    name = ''
    loop do
      prompt("What's your name? ")
      name = gets.chomp
      break if !name.empty? && name.chars.none? do |char|
        /[0-9]/ =~ char
      end
      prompt("That doesn't look right.\n")
    end
    self.name = name
  end
end

class Human < Player
  include Prompt

  def choose_own_piece(computer_piece)
    self.piece = choose_player_marker(computer_piece) || HUMAN_PIECE
  end

  def choose_player_marker(computer_piece)
    choice = ''
    loop do
      prompt("Choose a character for your piece: ")
      choice = gets.chomp
      if choice == computer_piece
        prompt("That one is taken :)\n")
        next
      end
      break if choice.length == 1
      prompt("Your piece marker should be 1 character long.\n")
    end
    choice
  end

  def choose_square(board, _, _)
    square = nil
    loop do
      prompt("Choose a square from #{board.empty_squares_list}: ")
      square = gets.chomp.to_i
      break if board.empty_squares.include?(square)
      prompt("Not a valid square!\n")
    end
    @move = square
  end
end

class Computer < Player
  COMPUTER_NAMES = ['2007 Iphone', 'Blackberry', 'Game & Watch', 'Arduino',
                    'Raspberry PI 1', 'StarTAC']

  def choose_square(board, human_piece, computer_piece)
    square = at_risk_square(board, computer_piece)
    square = at_risk_square(board, human_piece) if square.nil?
    square = 5 if board.empty_squares.include?(5)
    square = board.empty_squares.sample if square.nil?
    @move = square
  end

  def choose_own_piece
    self.piece = TTTgame::COMPUTER_PIECE
  end

  def player_name
    self.name = COMPUTER_NAMES.sample
  end
  
  private

  def at_risk_square(board, piece)
    Board::WINS.each do |line|
      line_pieces = line.map { |square| board.board[square] }
      if line_pieces.count(piece) == 2 &&
         line_pieces.include?(Board::BLANK_SQUARE)
        return line[line_pieces.index(Board::BLANK_SQUARE)]
      end
    end
    nil
  end
end

TTTgame.new.play
