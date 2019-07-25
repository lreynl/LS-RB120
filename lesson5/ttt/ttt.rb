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
  def initialize
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
  end
  # play loop
    #check for win or draw
   
  def play
    display_title_screen
    loop do
      puts board
      human.move
      break if winner? || board_full?
      computer.move
      break if winner? || board_full?
    end
    display_winner
    display_goodbye_message
  end

  def winner?
  # test for winner
    true
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
    puts "Now get to work!"
  end

  private

  attr_accessor :board
  attr_reader :human, :computer
end

class Board
  def initialize
    @board = [ [' ', ' ', ' '],
               [' ', ' ', ' '],
               [' ', ' ', ' '] ]
  end

  def to_s
    "#{board[0][0]}|#{board[0][1]}|#{board[0][2]}\n" +
    "-+-+-\n"                                        +
    "#{board[1][0]}|#{board[1][1]}|#{board[1][2]}\n" +
    "-+-+\n"                                         +
    "#{board[2][0]}|#{board[2][1]}|#{board[2][2]}\n"
  end
  
  private

  attr_accessor :board
  # board state has Xs & Os ?
end

class Player
  # place piece on board
  def move
    puts "#{self.class.to_s} placed a piece"
  end
end

class Human < Player
end

class Computer < Player
end

class Piece
  # X or O
end

game = TTTgame.new
game.play