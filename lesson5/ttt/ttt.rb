#TICTACTOE
#Tic tac toe is a game played by two players on a 3x3 square board. The players alternate placing
#their piece on the board. The first player to get three of their piece in a row wins. 
#If the board is full without a winner then it's a draw.

# nouns
# game, player, board, piece

# verbs
# play, place, win, draw

class TTTgame
  # has a board with state
  # has two players
  HUMAN_PIECE = 'X'
  COMPUTER_PIECE = 'O'
  def initialize
    @board = Board.new
    @human = Human.new(HUMAN_PIECE)
    @computer = Computer.new(COMPUTER_PIECE)
  end
  # play loop
    #check for win or draw
   
  def play
    display_title_screen
    loop do
      puts board
      human.choose_square(board)
      board.set_square_at(human.move, human.piece)
      #break if winner? || board_full?
      computer.choose_square(board)
      board.set_square_at(computer.move, computer.piece)
      puts board
      
      #break if winner? || board_full?
      
    end
    display_winner
    display_goodbye_message
  end

  def winner?
  # test for winner
    #true
  end

  def board_full?

  end

  def display_winner
    puts "Nobody won!"
  # display the winner
  end

  def display_title_screen
    puts "Ready, set, tic tac toe"
  end

  def display_goodbye_message
    puts "Maybe later."
  end

  private

  attr_accessor :board
  attr_accessor :human, :computer
end

class Board
  BLANK_SQUARE = ' '
  def initialize
    @board = {}
    (1..9).each { |num| self.set_square_at(num, BLANK_SQUARE) }
  end

  def to_s
    "#{get_square_at(1)}|#{get_square_at(2)}|#{get_square_at(3)}\n" +
    "-+-+-\n"                                                       +
    "#{get_square_at(4)}|#{get_square_at(5)}|#{get_square_at(6)}\n" +
    "-+-+-\n"                                                       +
    "#{get_square_at(7)}|#{get_square_at(8)}|#{get_square_at(9)}\n"
  end

  def empty_squares
    board.keys.select { |square| unmarked?(board[square]) }

  end

  def unmarked?(square)
    square == BLANK_SQUARE
  end

  def get_square_at(square)
    board[square]
  end

  def set_square_at(square, piece)
    board[square] = piece
    #p piece
  end
  
  private

  attr_accessor :board
  # board state has Xs & Os ?
end

class Player
  attr_reader :move

  def initialize(piece)
    @move = nil
    @piece = piece
  end

  # place piece on board
end

class Human < Player  
  def choose_square(board)
    square = nil
    loop do
      print "Choose a square from #{format_empty_squares(board)}: "
      square = gets.chomp.to_i
      break if board.empty_squares.include?(square)
      puts "Not a valid square!"
    end
    @move = square
  end

  def format_empty_squares(board)
    board.empty_squares.join(', ')
  end
  
    def piece
      @piece
    end
end

class Computer < Player  
  def choose_square(board)
    @move = board.empty_squares.sample
  end

  def piece
    @piece
  end
end

class Piece
  # X or O
end

game = TTTgame.new
game.play