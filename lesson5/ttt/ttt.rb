# TODO set custom player marker

require 'io/console'

module Prompt
  def prompt(message)
    print "> #{message}"
  end
end

module WinsData
  WINS = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
         [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
         [[1, 5, 9], [3, 5, 7]].freeze
end

class TTTgame
  HUMAN_PIECE = 'X'
  COMPUTER_PIECE = 'O'
  MATCH = 5
  GOES_FIRST = :choice # HUMAN_PIECE or COMPUTER_PIECE

  def initialize
    @human_piece = HUMAN_PIECE
    @computer_piece = COMPUTER_PIECE
    @board = Board.new
    @human = Human.new(HUMAN_PIECE)
    @computer = Computer.new(COMPUTER_PIECE)
    display_title_screen
    reset_current_player
    # choose_player_marker
  end

  def play
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
    display_goodbye_message
  end

  private

  include Prompt

  attr_accessor :board
  attr_accessor :human, :computer

  def round_loop
    loop do
      show_board
      display_scores
      current_player_move
      break if board.winner? || board.full?
      switch_current_player
    end
  end

  def choose_player_marker
    choice = ''
    loop do
      prompt("Choose a character for your piece: ")
      choice = gets.chomp
      if choice == @computer_piece
        prompt("That one is taken :)\n")
        next
      end
      break if choice.length == 1
      prompt("Your piece marker should be 1 character long.\n")
    end
    @human_piece = choice
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
    match_winner = if board.winner == @computer_piece
                     'Computer wins'
                   else
                     'You win'
                   end
    prompt("#{match_winner} the match!\n")
  end

  def reset_game
    board.reset
    reset_current_player
    @human.reset_score if @human.score >= MATCH
    @computer.reset_score if @computer.score >= MATCH
  end

  def display_scores
    prompt("Score: You, #{human.score} - Computer, #{computer.score}\n")
  end

  def current_player_move
    @current_player.choose_square(board, @human.piece, @computer.piece)
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
    @current_player = if GOES_FIRST == @human_piece
                        @human
                      elsif GOES_FIRST == @computer_piece
                        @computer
                      else
                        choose_player
                      end
  end

  def choose_player
    choice = ''
    loop do
      prompt("Do want to go first? (y/n) ")
      choice = gets.chomp.downcase
      break if %w(y n).include?(choice)
      prompt("That wasn't an option!")
    end
    choice == 'y' ? @human : @computer
  end

  def show_board
    clear_screen
    prompt("You're #{HUMAN_PIECE} - Computer is #{@computer_piece}\n")
    board.draw
  end

  def display_winner
    prompt("You won!\n") if board.winner == @human_piece
    prompt("Computer won!\n") if board.winner == @computer_piece
    prompt("It was a tie!\n") if board.winner.nil?
  end

  def display_title_screen
    clear_screen
    prompt("Ready, set, tic tac toe\n")
    prompt("\n")
    prompt("First to #{MATCH} wins\n")
    press_any_key
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

  include WinsData

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
    "#{board[1]}|#{board[2]}|#{board[3]}\n" \
    "-+-+-\n"                               \
    "#{board[4]}|#{board[5]}|#{board[6]}\n" \
    "-+-+-\n"                               \
    "#{board[7]}|#{board[8]}|#{board[9]}"
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
  attr_reader :move, :piece, :score

  def initialize(piece)
    @move = nil
    @piece = piece
    reset_score
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
end

class Human < Player
  include Prompt

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
  def choose_square(board, human_piece, computer_piece)
    square = complete_line(board, computer_piece)
    square = complete_line(board, human_piece) if square.nil?
    square = 5 if board.empty_squares.include?(5)
    square = board.empty_squares.sample if square.nil?
    @move = square
  end

  private

  include WinsData

  def complete_line(board, piece)
    WINS.each do |line|
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
