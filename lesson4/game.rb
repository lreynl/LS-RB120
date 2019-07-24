class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def play # overrides inherited play method
    'What are you waiting for?'
  end

  def rules_of_play
    #rules of play
  end
end

p Bingo.new.play